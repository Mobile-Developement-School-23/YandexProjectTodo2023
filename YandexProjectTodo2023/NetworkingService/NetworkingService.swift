import Foundation
import FileCachePackage

enum RequestType {
    case fetch
    case getItem
    case patch
    case post
    case put
    case delete
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum ServerString: String {
    case url = "https://beta.mrdekk.ru/todobackend/list/"
    case token = "despoil"
}

enum NetworkError: Error {
    case badURL
    case serverError
    case parseError(Error)
}

typealias NetworkCompletionHandler = @Sendable (Result<FileCachePackage.TodoList, NetworkError>) -> Void

protocol NetworkingServiceDelegate: AnyObject {
    func didStartLoading()
    func didFinishLoading()
}

// MARK: Settings for Yandex server

final class DefaultNetworkingService: Sendable {
    
    private lazy var _activeRequests = Int()
    private let activeRequestsQueue = DispatchQueue(label: "activeRequestsQueue")
    
    var activeRequests: Int {
        get {
            return activeRequestsQueue.sync {
                _activeRequests
            }
        }
        set {
            activeRequestsQueue.sync {
                _activeRequests = newValue
                NotificationCenter.default.post(name: .activeRequestsChanged, object: nil)
            }
        }
    }
    
    private var retryCount = 0
    private let maxRetryCount = 5
    private var fetchRequestStart = false
    
    private let minDelay: Double = 2
    private let maxDelay: Double = 120
    private let factor: Double = 1.5
    private let jitter: Double = 0.05
    private var currentDelay: Double = 2
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    private func getURL(for type: RequestType, with id: String? = nil) -> URL? {
        let urlString: String
        switch type {
        case .getItem, .put, .delete:
            guard let id = id else { return nil }
            urlString = ServerString.url.rawValue + id
        default:
            urlString = ServerString.url.rawValue
        }
        return URL(string: urlString)
    }
    
    private func createRequest(for url: URL, method: HTTPMethod, token: String, revision: String = "0", requestBody: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue(revision, forHTTPHeaderField: "X-Last-Known-Revision")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = method.rawValue
        request.httpBody = requestBody
        return request
    }
    
    private func createBodyDataFrom(_ todoItem: FileCachePackage.ToDoItem) -> Data? {
        //        print(Thread.current) Not main thread
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom { date, encoder in
            let seconds = Int64(date.timeIntervalSince1970)
            var container = encoder.singleValueContainer()
            try container.encode(seconds)
        }
        
        return try? encoder.encode(FileCachePackage.TodoList(status: "ok", element: todoItem))
    }
    
    private func createNetworkTask(_ request: URLRequest, _ completion: @escaping NetworkCompletionHandler, _ type: RequestType, _ todoItem: ToDoItem, _ revision: Int) -> URLSessionDataTask {
        return urlSession.dataTask(with: request) { (data, response, error) in
            
            self.processResponseData(data, error) { (result: Result<FileCachePackage.TodoList, NetworkError>) in
                print(result)
                print("RetryCount - \(self.retryCount)")
                switch result {
                case .success(let list):
                    completion(.success(list))
                    self.retryCount = 0
                    self.resetDelay()
                    self.activeRequests -= 1
                case .failure(let error):
                    print("Failed to fetch data due to: \(error)")
                    self.retryCount += 1
                    self.retryRequest {
                        switch type {
                            
                        case .fetch:
                            self.handleRequest(method: .get, type: .fetch, completion: completion)
                            
                        case .getItem:
                            self.handleRequest(todoItem: todoItem, method: .get, type: .getItem, completion: completion)
                            
                        case .patch:
                            self.handleRequest(method: .patch, type: .patch, completion: completion)
                            
                        case .post:
                            self.handleRequest(todoItem: todoItem, method: .post, type: .post, revision: revision, completion: completion)
                            
                        case .put:
                            self.handleRequest(todoItem: todoItem, method: .put, type: .put, revision: revision, completion: completion)
                            
                        case .delete:
                            self.handleRequest(todoItem: todoItem, method: .delete, type: .delete, revision: revision, completion: completion)
                            
                        }
                    }
                }
            }
        }
    }
    
    private func processResponseData<T: Decodable>(_ data: Data?, _ error: Error?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        if let error = error {
            completion(.failure(.serverError))
        } else if let data = data {
            do {
                let list = try decoder.decode(T.self, from: data)
                completion(.success(list))
            } catch {
                completion(.failure(.parseError(error)))
            }
        }
    }

    private func makeRequest(
        todoItem: FileCachePackage.ToDoItem = FileCachePackage.ToDoItem(text: "", priority: .normal),
        method: HTTPMethod,
        type: RequestType,
        revision: Int,
        requestBody: Data? = nil,
        completion: @escaping NetworkCompletionHandler) {
            
            activeRequests += 1
            if retryCount >= maxRetryCount && !fetchRequestStart {
                self.handleRequest(method: .get, type: .fetch, completion: completion)
                retryCount = 0
                return
            } else if retryCount >= maxRetryCount && fetchRequestStart {
                return
            }
            
            guard let url = getURL(for: type, with: todoItem.id) else {
                completion(.failure(.badURL))
                return
            }
            
            let request = createRequest(for: url, method: method, token: ServerString.token.rawValue, revision: "\(revision)", requestBody: requestBody)
            
            let task = createNetworkTask(request, completion, type, todoItem, revision)
            
            task.resume()
        }
    

}

// MARK: Methods for use

extension DefaultNetworkingService {
    
    func handleRequest(todoItem: FileCachePackage.ToDoItem? = nil, method: HTTPMethod, type: RequestType, revision: Int = 0, completion: @escaping NetworkCompletionHandler) {
        DispatchQueue.global().async {
            let bodyData = todoItem != nil ? self.createBodyDataFrom(todoItem ?? FileCachePackage.ToDoItem(text: "", priority: .normal)) : nil
            self.makeRequest(todoItem: todoItem ?? FileCachePackage.ToDoItem(text: "", priority: .normal), method: method, type: type, revision: revision, requestBody: bodyData, completion: completion)
        }
    }
    
}

// MARK: Result processing + Jitter

extension FirstScreenViewController {
    
    func resultProcessing(result: Result<FileCachePackage.TodoList, NetworkError>) {
        switch result {
        case .success(let networkCache):
            DispatchQueue.main.async {
                self.networkCache = networkCache
            }
        case .failure(let error):
            print(error)
        }
    }
}

// Jitter

extension DefaultNetworkingService {
    
    private func retryRequest(_ request: @escaping @Sendable () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + currentDelay) {
            request()
        }
        updateDelay()
    }
    
    private func updateDelay() {
        let randomJitter = Double.random(in: 0...(jitter * currentDelay))
        currentDelay = min(maxDelay, factor * currentDelay) + randomJitter
    }
    
    private func resetDelay() {
        currentDelay = minDelay
    }
}
