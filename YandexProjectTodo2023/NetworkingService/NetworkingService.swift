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

class DefaultNetworkingService {
    
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

    private func makeRequest(for endpoint: String, method: String, revision: String, requestBody: Data? = nil, completion: @escaping @Sendable (Result<FileCachePackage.TodoList, Error>) -> Void) {
//        print(Thread.current) Not main thread
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        let request = createRequest(for: url, method: method, token: "despoil", revision: revision, requestBody: requestBody)

        let task = urlSession.dataTask(with: request) { (data, _, error) in

            self.processResponseData(data, error, completion: completion)
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

extension DefaultNetworkingService: NetworkingService {
    
    func fetchData(todoId: String? = nil, completion: @escaping @Sendable (Result<FileCachePackage.TodoList, Error>) -> Void) {
        DispatchQueue.global().async {
            self.makeRequest(for: todoId ?? "", method: "GET", revision: "0", completion: completion)
        }

    }
    
    func getTodoItemFromId(todoId: String, completion: @Sendable @escaping (Result<FileCachePackage.TodoList, Error>) -> Void) {
        DispatchQueue.global().async {
            self.makeRequest(for: todoId, method: "GET", revision: "0", completion: completion)
        }
    }

    func patchData(completion: @escaping @Sendable (Result<FileCachePackage.TodoList, Error>) -> Void) {
        DispatchQueue.global().async {
            self.makeRequest(for: "", method: "PATCH", revision: "0", completion: completion)
        }
    }

    func postTodoItem(todoItem: FileCachePackage.ToDoItem, revision: Int, completion: @Sendable @escaping (Result<FileCachePackage.TodoList, Error>) -> Void) {
        DispatchQueue.global().async {
            let bodyData = self.createBodyDataFrom(todoItem)
            self.makeRequest(for: "", method: "POST", revision: "\(revision)", requestBody: bodyData, completion: completion)
        }
    }

    func putTodoItem(todoItem: FileCachePackage.ToDoItem, revision: Int, completion: @Sendable @escaping (Result<FileCachePackage.TodoList, Error>) -> Void) {
        DispatchQueue.global().async {
            let bodyData = self.createBodyDataFrom(todoItem)
            self.makeRequest(for: "\(todoItem.id)", method: "PUT", revision: "\(revision)", requestBody: bodyData, completion: completion)
        }
    }

    func deleteTodoItem(todoItem: FileCachePackage.ToDoItem, revision: Int, completion: @Sendable @escaping (Result<FileCachePackage.TodoList, Error>) -> Void) {
        DispatchQueue.global().async {
            let bodyData = self.createBodyDataFrom(todoItem)
            self.makeRequest(for: "\(todoItem.id)", method: "DELETE", revision: "\(revision)", requestBody: bodyData, completion: completion)
        }
    }
}


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
