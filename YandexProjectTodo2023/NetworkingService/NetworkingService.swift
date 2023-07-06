import Foundation
import FileCachePackage

protocol NetworkingService {
    
    func fetchData(todoId: String?, completion: @escaping @Sendable (Result<FileCachePackage.TodoList, Error>) -> Void)
    func getTodoItemFromId(todoId: String, completion: @Sendable @escaping (Result<FileCachePackage.TodoList, Error>) -> Void)
    func patchData(completion: @escaping @Sendable (Result<FileCachePackage.TodoList, Error>) -> Void)
    func postTodoItem(todoItem: FileCachePackage.ToDoItem, revision: Int, completion: @Sendable @escaping (Result<FileCachePackage.TodoList, Error>) -> Void)
    func putTodoItem(todoItem: FileCachePackage.ToDoItem, revision: Int, completion: @Sendable @escaping (Result<FileCachePackage.TodoList, Error>) -> Void)
    func deleteTodoItem(todoItem: FileCachePackage.ToDoItem, revision: Int, completion: @Sendable @escaping (Result<FileCachePackage.TodoList, Error>) -> Void)
}

// MARK: Settings for Yandex server

final class DefaultNetworkingService: Sendable {
    
    // Default settings fo jitter
    
    private let minDelay: Double = 2
    private let maxDelay: Double = 120
    private let factor: Double = 1.5
    private let jitter: Double = 0.05
    private var currentDelay: Double = 2
    
    private let urlSession: URLSession
    private let baseURL = "https://beta.mrdekk.ru/todobackend/list"
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    private func createRequest(for url: URL, method: String, token: String, revision: String = "0", requestBody: Data? = nil) -> URLRequest {
//                print(Thread.current) Not main thread
        var request = URLRequest(url: url)
        request.addValue(revision, forHTTPHeaderField: "X-Last-Known-Revision")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = method
        request.httpBody = requestBody
        return request
    }
    
    private func processResponseData<T: Decodable>(_ data: Data?, _ error: Error?, completion: @escaping (Result<T, Error>) -> Void) {
//        print(Thread.current) Not main thread
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        if let error = error {
            completion(.failure(error))
        } else if let data = data {
            do {
                let list = try decoder.decode(T.self, from: data)
                completion(.success(list))
            } catch {
                completion(.failure(error))
            }
        }
    }

    private func makeRequest(todoItem: FileCachePackage.ToDoItem, method: String, type: RequestType, revision: String, requestBody: Data? = nil, completion: @escaping @Sendable (Result<FileCachePackage.TodoList, Error>) -> Void) {
//        print(Thread.current) Not main thread
        guard let url = URL(string: "\(baseURL)/\(todoItem.id)") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        let request = createRequest(for: url, method: method, token: "despoil", revision: revision, requestBody: requestBody)

        let task = urlSession.dataTask(with: request) { (data, _, error) in

            self.processResponseData(data, error) { (result: Result<FileCachePackage.TodoList, Error>) in
                            switch result {
                            case .success(let list):
                                completion(.success(list))
                                self.resetDelay()
                            case .failure(let error):
                                print("Failed to fetch data due to: \(error)")
                                self.retryRequest {
                                    switch type {
                                        
                                    case .fetch:
                                        self.fetchData(todoItem: todoItem, completion: completion)
                                    case .getItem:
                                        self.getTodoItemFromId(todoItem: todoItem, completion: completion)
                                    case .patch:
                                        self.patchData(completion: completion)
                                    case .post: break
                                        
                                    case .put: break
                                    case .delete: break
                                    }
                                    
                                    
                                    
                                }
                            }
                        }
                    }
        task.resume()
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
}

// MARK: Methods for use

extension DefaultNetworkingService  {
    
    func fetchData(todoItem: FileCachePackage.ToDoItem, completion: @escaping @Sendable (Result<FileCachePackage.TodoList, Error>) -> Void) {
        DispatchQueue.global().async {
            self.makeRequest(todoItem: todoItem, method: "GET", type: .fetch, revision: "0", completion: completion)
        }

    }
    
    func getTodoItemFromId(todoItem: FileCachePackage.ToDoItem, completion: @Sendable @escaping (Result<FileCachePackage.TodoList, Error>) -> Void) {
        DispatchQueue.global().async {
            self.makeRequest(todoItem: todoItem, method: "GET", type: .getItem, revision: "0", completion: completion)
        }
    }

    func patchData(completion: @escaping @Sendable (Result<FileCachePackage.TodoList, Error>) -> Void) {
        DispatchQueue.global().async {
            self.makeRequest(todoItem: todoItem, method: "PATCH", type: .patch, revision: "0", completion: completion)
        }
    }

    func postTodoItem( todoItem: FileCachePackage.ToDoItem, revision: Int, completion: @Sendable @escaping (Result<FileCachePackage.TodoList, Error>) -> Void) {
        DispatchQueue.global().async {
            let bodyData = self.createBodyDataFrom(todoItem)
            self.makeRequest(todoItem: todoItem, method: "POST", type: .post, revision: "\(revision)", requestBody: bodyData, completion: completion)
        }
    }

    func putTodoItem(todoItem: FileCachePackage.ToDoItem, revision: Int, completion: @Sendable @escaping (Result<FileCachePackage.TodoList, Error>) -> Void) {
        DispatchQueue.global().async {
            let bodyData = self.createBodyDataFrom(todoItem)
            self.makeRequest(todoItem: todoItem, method: "PUT", type: .put, revision: "\(revision)", requestBody: bodyData, completion: completion)
        }
    }

    func deleteTodoItem(todoItem: FileCachePackage.ToDoItem, revision: Int, completion: @Sendable @escaping (Result<FileCachePackage.TodoList, Error>) -> Void) {
        DispatchQueue.global().async {
            let bodyData = self.createBodyDataFrom(todoItem)
            self.makeRequest(todoItem: todoItem, method: "DELETE", type: .delete, revision: "\(revision)", requestBody: bodyData, completion: completion)
        }
    }
}

// MARK: Result processing + Jitter

extension FirstScreenViewController {
    
    func resultProcessing(result: Result<FileCachePackage.TodoList, Error>) {
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

enum RequestType {
    case fetch
    case getItem
    case patch
    case post
    case put
    case delete
}

