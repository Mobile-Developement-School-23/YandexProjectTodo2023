import Foundation

public enum FileType {
    case json
    case csv
}

enum ErrorToDo: Error {
    case toDoWithThisIdAlreadyCreated
}

@available(iOS 15, *)
open class FileCache {
    
    public init() {}
    
    private var collectionToDo = [String: ToDoItem]()
    
    open func getCollectionToDo() -> [ToDoItem] {
        return Array(collectionToDo.values)
    }
    
    open func addNewToDo(_ todo: ToDoItem) throws {
        if collectionToDo[todo.id] == nil {
            collectionToDo[todo.id] = todo
        } else {
            throw ErrorToDo.toDoWithThisIdAlreadyCreated
        }
    }
    
    open func deleteToDo(_ id: String) {
        collectionToDo[id] = nil
    }
    
    public static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

@available(iOS 15, *)
extension FileCache {
    
    public func convertJsonToString() -> String {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self.createCache(fileType: .json), options: []) else {
            print("Convert JSONSerialization error")
            return ""
        }
        let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
        return jsonString
    }
    
   public static func readJsonString(jsonString: String) -> Any {
        guard let jsonData = jsonString.data(using: String.Encoding.utf8) else {
            print("couldn't encode string as UTF-8")
            return ""
        }
        guard let dictionaryFunc = try? JSONSerialization.jsonObject(with: jsonData, options: .fragmentsAllowed) else {
            print("Ошибка FileCahche JSONSerialization")
            return ""
        }
        return dictionaryFunc
    }
}

@available(iOS 15, *)
extension FileCache {
    
   public static func readFromFile(fileName: String, fileType: FileType) -> FileCache? {
        
        let fileCache = FileCache()
        
        guard fileType == .json else {
            
            let fullPath = getDocumentsDirectory().appendingPathComponent(fileName)
            guard let content = try? String(contentsOf: fullPath) else {
                print("readFromFile content Error")
                return nil
            }
            let parsedCSV = content.components(separatedBy: "\n").dropLast()
            for i in parsedCSV {
                
                guard let toDoItem = ToDoItem.parseCSV(csv: i) else { continue }
                do {
                    try fileCache.addNewToDo(toDoItem)
                } catch {
                    return nil
                }
            }
            if fileCache.getCollectionToDo().isEmpty {
                return nil
            }
            return fileCache
        }
        
        let fullPath = getDocumentsDirectory().appendingPathComponent(fileName )
        guard let content = try? String(contentsOf: fullPath, encoding: .utf8) else {
            print("readFromFile content Error")
            return nil
        }
        
        guard let allToDoString = readJsonString(jsonString: content) as? [ String: [Any]] else {
            print("readFromFile allToDoString Error")
            return nil
        }
        
        guard let allToDo = allToDoString["collectionToDo"] else {return nil}
        for iToDo in allToDo {
            let todoTmp = ToDoItem.parseJson(json: iToDo) ?? ToDoItem(id: "", text: "", priority: .low)
            
                try? fileCache.addNewToDo(todoTmp)// ?
        }
        return fileCache
    }
}

@available(iOS 15, *)
extension FileCache {
    
    public func createCache(fileType: FileType) -> [String: [Any]] {
        var todoItemJsonRepresentationArray = [Any]()
        for item in collectionToDo.values {
            let todo = fileType == .json ? item.json : item.csv
            todoItemJsonRepresentationArray.append(todo)
        }
        let jsonObject = ["collectionToDo": todoItemJsonRepresentationArray]
        return jsonObject
    }
    
    public func saveToFile(fileName: String, fileType: FileType) {
        
        let fullPath = FileCache.getDocumentsDirectory().appendingPathComponent(fileName )
        var strFrom = String()
        if fileType == .csv {
            for i in collectionToDo {
                
                let str = (i.value.csv as? String ?? "") + "\n"
                strFrom.append(str)
                
            }
        } else {
            strFrom = convertJsonToString()
        }
        
        do {
            try strFrom.write(to: fullPath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print( "failed to write file")
        }
    }
}
// MARK: Save CacheToFileAsync

@available(iOS 15, *)
extension FileCache {
    
   public static func saveToDefaultFileAsync(collectionToDo: [ToDoItem], collectionToDoComplete: [ToDoItem]) {
       
        DispatchQueue.global(qos: .userInitiated).async {
            
            let fileCache = FileCache()
            
            for i in collectionToDo {
                if i.creationDate != .distantFuture && i.creationDate != .distantPast {
                    try? fileCache.addNewToDo(i)
                }
            }
            for i in collectionToDoComplete {
                try? fileCache.addNewToDo(i)
            }
            
            fileCache.saveToFile(fileName: "fileCacheForTests", fileType: .json)
        }
    }
}
