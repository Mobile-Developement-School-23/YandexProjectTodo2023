import Foundation
import FileCachePackage

protocol NetworkingService {
    func fetchData(completion: @escaping @Sendable (Result<ToDoItem, Error>) -> Void)
    // Определите остальные методы в соответствии с вашим API
}

class DefaultNetworkingService: NetworkingService {
    private let urlSession: URLSession
  
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func fetchData(completion: @escaping @Sendable (Result<ToDoItem, Error>) -> Void) {
        guard let url = URL(string: "https://beta.mrdekk.ru/todobackend/list") else {
            // Обработка ошибки
            return
        }

        var request = URLRequest(url: url)
        request.addValue("0", forHTTPHeaderField: "X-Last-Known-Revision")
        request.addValue("Bearer despoil", forHTTPHeaderField: "Authorization")

        let task = urlSession.dataTask(with: request) { (data, response, error) in
//            print(response)
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
//                print(data)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                var js = try?  JSONSerialization.jsonObject(with: data)
                print(js)

//                print(response)
//                do {
//                    
//                    let list = try decoder.decode(ToDoItem.self, from: data)
//                    completion(.success(list))
//                } catch {
//                    completion(.failure(error))
//                }
            }
        }

        task.resume()
    }
    
    func sendData()  {
        

        let encoder = JSONEncoder()

        
        var lastModel = FileCachePackage.TodoItemServerModel(id: "123", text: "sfsdf", importance: "low", deadline: 123214, done: false, color: "#FFFFFF", created_at: 123456, changed_at: 123456, last_updated_by: "kn")
        var lastList = APIListResponse(status: "ok", list: [lastModel], revision: 0)
        var lastElem = APIElementResponse(element: lastModel)

        let jsonData = try? encoder.encode(lastElem)
        
        print(try? JSONSerialization.jsonObject(with: jsonData!))
        
        guard let url = URL(string: "https://beta.mrdekk.ru/todobackend/list/") else {
            // Обработка ошибки
            return
        }
        

        

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.addValue("Bearer despoil", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("0", forHTTPHeaderField: "X-Last-Known-Revision")

        request.httpMethod = "POST"
        var resultString = String(data: jsonData!, encoding: .utf8)
        print(resultString)
        request.httpBody = jsonData

        
        let task = urlSession.dataTask(with: request) { data, response, error in
            print(response)
        }
        task.resume()
    }
}
