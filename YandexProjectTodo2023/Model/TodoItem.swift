import Foundation

@available(iOS 15, *)
public struct TodoList: Codable {
    public let status: String
    public let list: [ToDoItem]?
    public let revision: Int?
    public let element: ToDoItem?
    
    public init(status: String = "ok", list: [ToDoItem]? = nil, revision: Int? = nil, element: ToDoItem? = nil) {
        self.status = status
        self.list = list
        self.revision = revision
        self.element = element
    }
}

@available(iOS 15, *)
public struct ToDoItem: Codable, Sendable {
    
    public let id: String
    public var text: String
    public var priority: Priority
    public var deadline: Date?
    public var isDone: Bool
    public var creationDate: Date
    public var modifyDate: Date?
    public var colorHEX: String
    public var last_updated_by: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case priority = "importance"
        case deadline
        case isDone = "done"
        case creationDate = "created_at"
        case modifyDate = "changed_at"
        case colorHEX = "color"
        case last_updated_by
    }
    
    public enum Priority: String, Codable, Sendable {
        case low
        case normal = "basic"
        case high = "important"
    }
    
   public init(id number: String = UUID().uuidString,
         text: String,
         priority: Priority,
         deadline: Date? = nil,
         isDone: Bool = false,
         creationDate: Date = .now,
               modifyDate: Date? = .now,
        colorHEX: String = "000000FF",
        last_updated_by: String = "") {
        id = number
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.modifyDate = modifyDate
        self.colorHEX = colorHEX
        self.last_updated_by = last_updated_by
    }
  
}

@available(iOS 15, *)
extension ToDoItem {
    
    public var json: Any {
        var contentOfObj = ["text": text,
                            "isDone": String(isDone),
                            "creationDate": String(Int64(creationDate.timeIntervalSince1970)),
                            "modifyDate": String(Int64(modifyDate?.timeIntervalSince1970 ?? 0)),
                            "colorHEX": colorHEX]
        if deadline != nil {
            contentOfObj["deadline"] = String(Int64(deadline?.timeIntervalSince1970 ?? 0))
        }
        if priority.rawValue != "normal" {
            contentOfObj["priority"] = priority.rawValue
        }
        let jsonObject = [id: contentOfObj as [String: Any]]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            return jsonString
        } catch {
            print("error writing JSON: \(error)")
        }
        return jsonObject
    }
    
    public static func parseJson(json: Any) -> ToDoItem? {
        guard let json = json as? String else {
            print("JSON not String")
            return nil
        }
        guard let jsonData = json.data(using: String.Encoding.utf8) else {
            print("couldn't encode string as UTF-8")
            return nil
        }
        guard let dictionaryFunc = try? JSONSerialization.jsonObject(with: jsonData,
                                                                     options: .fragmentsAllowed) as? [String: [String: String]] else {
            print("Ошибка JSONSerialization")
            return nil
        }
        return createToDoFromDictionary(dictionaryFunc: dictionaryFunc)
    }

}

@available(iOS 15, *)
extension ToDoItem {
    
    public var csv: Any {
        let contentOfObj = "\(id),\(text),\(priority.rawValue),\((deadline?.timeIntervalSince1970) ?? 0),\(isDone),\(creationDate.timeIntervalSince1970),\((modifyDate?.timeIntervalSince1970) ?? 0)"
   
        return contentOfObj
    }

    public static func parseCSV(csv: Any) -> ToDoItem? {
        guard let csv = csv as? String else {
            print("csv not String")
            return nil
        }
        let parsedCSV = csv.components(
            separatedBy: ",")
        guard parsedCSV.count >= 7 else {return nil}
        var dictionaryFunc = [parsedCSV[0]: ["text": parsedCSV[1], "priority": parsedCSV[2], "deadline": parsedCSV[3], "isDone": parsedCSV[4], "creationDate": parsedCSV[5], "modifyDate": parsedCSV[6]]]

        if dictionaryFunc[parsedCSV[0]]?["deadline"] == "0.0" {
            dictionaryFunc[parsedCSV[0]]?["deadline"] = nil
        }
        if dictionaryFunc[parsedCSV[0]]?["modifyDate"] == "0.0" {
            dictionaryFunc[parsedCSV[0]]?["modifyDate"] = nil
        }
        return createToDoFromDictionary(dictionaryFunc: dictionaryFunc)
    }
}

@available(iOS 15, *)
extension ToDoItem {
    
    static func createToDoFromDictionary(dictionaryFunc: [String: [String: String]]) -> ToDoItem? {
        
        let id = dictionaryFunc.keys.first ?? ""
        guard let dictionaryId = dictionaryFunc[id] else {
            print("Error dictionaryId")
            return nil
        }
        guard let textFunc = dictionaryId["text"] else {
            return nil
        }
        let priorityFunc = Priority(rawValue: dictionaryId["priority"] ?? "") ?? .normal
        var deadlineFunc: Date?
        if let deadlineString = dictionaryId["deadline"] {
            if let deadlineDouble = Double(deadlineString) {
                deadlineFunc = Date(timeIntervalSince1970: deadlineDouble)
            }
        }
        let isDoneFunc = dictionaryId["isDone"] == "true"
        var creationDateFunc = Date()
        if let creationDateString = dictionaryId["creationDate"] {
            if let creationDateDouble = Double(creationDateString) {
                creationDateFunc = Date(timeIntervalSince1970: creationDateDouble)
            }
        }
        var modifyDateFunc: Date?
        if let modifyDatecreationDateString = dictionaryId["modifyDate"] {
            if let creationModifyDouble = Double(modifyDatecreationDateString) {
                modifyDateFunc = Date(timeIntervalSince1970: creationModifyDouble)
            }
        }
        let colorHEX = dictionaryId["colorHEX"] ?? "000000FF"
        
        let toDo = ToDoItem(id: id,
                            text: textFunc,
                            priority: priorityFunc,
                            deadline: deadlineFunc,
                            isDone: isDoneFunc,
                            creationDate: creationDateFunc,
                            modifyDate: modifyDateFunc,
                            colorHEX: colorHEX)
        return toDo
    }
}
