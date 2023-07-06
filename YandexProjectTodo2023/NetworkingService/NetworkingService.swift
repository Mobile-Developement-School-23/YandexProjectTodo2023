import Foundation
import FileCachePackage

protocol NetworkingService {
    func fetchData(completion: @escaping @Sendable (Result<FileCachePackage.TodoList, Error>) -> Void)
    // Определите остальные методы в соответствии с вашим API
}

class DefaultNetworkingService: NetworkingService {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchData(completion: @escaping @Sendable (Result<FileCachePackage.TodoList, Error>) -> Void) {
        guard let url = URL(string: "https://beta.mrdekk.ru/todobackend/list") else {
            // Обработка ошибки
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("0", forHTTPHeaderField: "X-Last-Known-Revision")
        request.addValue("Bearer despoil", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                do {
                    let list = try decoder.decode(FileCachePackage.TodoList.self, from: data)
//                    print(list)
                    completion(.success(list))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func patchData(todoList: FileCachePackage.TodoList, completion: @escaping (Result<FileCachePackage.TodoList, Error>) -> Void) {
        
        guard let url = URL(string: "https://beta.mrdekk.ru/todobackend/list") else {
            // Обработка ошибки
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("0", forHTTPHeaderField: "X-Last-Known-Revision")
        request.addValue("Bearer despoil", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom { date, encoder in
            let seconds = Int64(date.timeIntervalSince1970)
            var container = encoder.singleValueContainer()
            try container.encode(seconds)
        }
        
        let list = try? encoder.encode(todoList)
//        print(Thread.current) !!! Main
        request.httpBody = list
        
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
//                completion(.failure(error))
            } else if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                do {
                    let list = try decoder.decode(FileCachePackage.TodoList.self, from: data)
//                    print(list)
                    completion(.success(list))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func getTodoItemFromId(todoId: String, completion: @Sendable @escaping (Result<FileCachePackage.TodoList, Error>) -> Void) {
        
        guard let url = URL(string: "https://beta.mrdekk.ru/todobackend/list/\(todoId)") else {
            // Обработка ошибки
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("0", forHTTPHeaderField: "X-Last-Known-Revision")
        request.addValue("Bearer despoil", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(response as Any)
                completion(.failure(error))
            } else if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                do {
                    let list = try decoder.decode(FileCachePackage.TodoList.self, from: data)
                    completion(.success(list))
                } catch {
                    print(response as Any)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
        
    }
    
    func postTodoItem(todoItem: FileCachePackage.ToDoItem, revision: Int, completion: @Sendable @escaping (Result<FileCachePackage.TodoList, Error>) -> Void) {
        
        guard let url = URL(string: "https://beta.mrdekk.ru/todobackend/list") else {
            // Обработка ошибки
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        request.addValue("Bearer despoil", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom { date, encoder in
            let seconds = Int64(date.timeIntervalSince1970)
            var container = encoder.singleValueContainer()
            try container.encode(seconds)
        }
        
        let list = try? encoder.encode(FileCachePackage.TodoList(status: "ok", element: todoItem))
//        print(Thread.current) !!! Main
        request.httpBody = list
        
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                do {
                    let list = try decoder.decode(FileCachePackage.TodoList.self, from: data)
                    completion(.success(list))
                } catch {
                    print(response as Any)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    
    func putTodoItem(todoItem: FileCachePackage.ToDoItem, revision: Int, completion: @Sendable @escaping (Result<FileCachePackage.TodoList, Error>) -> Void) {
        
        guard let url = URL(string: "https://beta.mrdekk.ru/todobackend/list/\(todoItem.id)") else {
            // Обработка ошибки
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        request.addValue("Bearer despoil", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom { date, encoder in
            let seconds = Int64(date.timeIntervalSince1970)
            var container = encoder.singleValueContainer()
            try container.encode(seconds)
        }
        
        let list = try? encoder.encode(FileCachePackage.TodoList(status: "ok", element: todoItem))
//        print(Thread.current) !!! Main
        request.httpBody = list
        
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                do {
                    let list = try decoder.decode(FileCachePackage.TodoList.self, from: data)
                    completion(.success(list))
                } catch {
                    print(response as Any)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func deleteTodoItem(todoItem: FileCachePackage.ToDoItem, revision: Int, completion: @Sendable @escaping (Result<FileCachePackage.TodoList, Error>) -> Void) {
        
        guard let url = URL(string: "https://beta.mrdekk.ru/todobackend/list/\(todoItem.id)") else {
            // Обработка ошибки
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        request.addValue("Bearer despoil", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom { date, encoder in
            let seconds = Int64(date.timeIntervalSince1970)
            var container = encoder.singleValueContainer()
            try container.encode(seconds)
        }
        
        let list = try? encoder.encode(FileCachePackage.TodoList(status: "ok", element: todoItem))
//        print(Thread.current) !!! Main
        request.httpBody = list
        
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                do {
                    let list = try decoder.decode(FileCachePackage.TodoList.self, from: data)
                    completion(.success(list))
                } catch {
                    print(response as Any)
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
    func createTaskAndSendList(request: URLRequest, completion:  (Result<FileCachePackage.TodoList, Error>)) -> URLSessionDataTask {
        let task = urlSession.dataTask(with: request) { (data, response, error) in
           
            
            if let error = error {
//                completion(.failure(error))
            } else if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                do {
                    let list = try decoder.decode(FileCachePackage.TodoList.self, from: data)
//                    completion(.success(list))
                } catch {
                    print(response as Any)
//                    completion(.failure(error))
                }
            }
        }
        
        
      return task
    }
}
