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
        encoder.dateEncodingStrategy = .custom { date, encoder in
            let seconds = Int64(date.timeIntervalSince1970)
            var container = encoder.singleValueContainer()
            try container.encode(seconds)
        }
   
        var myModel = FileCachePackage.ToDoItem(id: "12342", text: "text", priority: .normal, deadline: .now, isDone: false, creationDate: .now, modifyDate: .now, colorHEX: "#FFFFFF", last_updated_by: "str")
        var myList =  FileCachePackage.TodoList(status: "ok", list: [myModel])
        

        guard let url = URL(string: "https://beta.mrdekk.ru/todobackend/list/") else {
            // Обработка ошибки
            return
        }
        var todoElement = FileCachePackage.TodoList(status: "ok", element: myModel)

        

        var request = URLRequest(url: url)
        request.addValue("Bearer despoil", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("13", forHTTPHeaderField: "X-Last-Known-Revision")

        request.httpMethod = "PATCH"
        
        let jsonDataMyModel = (try? encoder.encode(myList))

        request.httpBody = jsonDataMyModel

        
        let task = urlSession.dataTask(with: request) { data, response, error in
            print(response)
        }
        task.resume()
    }
}
