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
        request.addValue("Bearer despoil", forHTTPHeaderField: "Authorization")

        let task = urlSession.dataTask(with: request) { (data, response, error) in
//            print(response)
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                var js = try?  JSONSerialization.jsonObject(with: data)
                print(js)

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
    
    func sendData() {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let item = ToDoItem(id: "123", text: "df", priority: .normal)
        
        let fullPath = FileCachePackage.FileCache.getDocumentsDirectory().appendingPathComponent("fileCacheForTestsTwo")
        
        guard let content = try? Data(contentsOf: fullPath) else {
            print("readFromFile content Error")
            return 
        }

        
        var x = FileCachePackage.FileCache.readFromFile(fileName: "fileCacheForTestsTwo", fileType: .json)
        var collection = x!.getCollectionToDo()
        var collectionList = [String: [[String: Any]]]()
        collectionList["list"] = [[:]]
        for i in collection {
            collectionList["list"] = [[
                "id": i.id,
                "text": i.text,
                "importance": i.priority.rawValue,
                "deadline": i.deadline?.timeIntervalSince1970,
                "done": i.isDone,
                "color": "\(i.colorHEX)",
                "created_at": i.creationDate.timeIntervalSince1970,
                "changed_at": i.modifyDate?.timeIntervalSince1970,
                "last_updated_by": "5300880" ]]
        }
        collectionList["list"]?.removeFirst()
        
        var testCollection = [String:[[String:Any]]]()
        
        testCollection["list"] = [["id": 2342342, // уникальный идентификатор элемента
        "text": "blablabla",
        "importance": "low", // importance = low | basic | important
        "deadline": 234234234, // int64, может отсутствовать, тогда нет
        "done": false,
        "color": "#FFFFFF", // может отсутствовать
        "created_at": 234234234,
        "changed_at": 23423423,
        "last_updated_by": 234234234]]
        

        let jsonData = try? JSONSerialization.data(withJSONObject: collectionList)
        
//        print(collectionList)
        
        
        let urlSession = URLSession.shared
        guard let url = URL(string: "https://beta.mrdekk.ru/todobackend/list/") else {
            // Обработка ошибки
            return
        }
        var request = URLRequest(url: url)
        request.addValue("Bearer despoil", forHTTPHeaderField: "Authorization")
        request.addValue("1", forHTTPHeaderField: "X-Last-Known-Revision")
        request.httpMethod = "PATCH"
        request.httpBody = jsonData
//        print(jsonData)
        var js = try?  JSONSerialization.jsonObject(with: jsonData!)
                    print(js)
        

//        do {
//            let jsonData = try JSONEncoder().encode(x)
//            request.httpBody = jsonData
//            var js = try?  JSONSerialization.jsonObject(with: jsonData)
//            print(js)
//        } catch {
//            // Обработка ошибки
//            print("error")
//        }
        let task = urlSession.dataTask(with: request) { data, response, error in
            print(response)
        }

        task.resume()
    }
}
