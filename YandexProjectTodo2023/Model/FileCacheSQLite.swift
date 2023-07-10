import SQLite
import Foundation


// MARK: SQLite

class FileCacheSQLite {
    
    private static let nameDB = "SQLiteTodoDB.sqlite3"
    
    private static let todo = Table("todo")
    
    private static let id = Expression<String>("id")
    private static let text = Expression<String>("text")
    private static let priority = Expression<String>("priority")
    private static let deadline = Expression<Int64?>("deadline")
    private static let isDone = Expression<Bool>("isDone")
    private static let creationDate = Expression<Int64>("creationDate")
    private static let modifyDate = Expression<Int64?>("modifyDate")
    private static let colorHEX = Expression<String>("colorHEX")
    private static let last_updated_by = Expression<String>("last_updated_by")
    
    
    static func checkOldDataBaseAndCreateNew() -> Connection? {
        
        var db = try? Connection()
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dbPath = documentsUrl.appendingPathComponent(nameDB).path
        
        if fileManager.fileExists(atPath: dbPath) {
            
            do {
                db = try Connection("\(documentsUrl.absoluteString)/\(nameDB)")
                
            } catch {
                print("db can't read")
            }
            return db
            
        } else {
            
            do {
                db = try Connection("\(documentsUrl.absoluteString )/\(nameDB)")
            } catch {
                print("db can't write")
            }
            
            do {
                try db?.run(todo.create { t in
                    t.column(id, primaryKey: true)
                    t.column(text)
                    t.column(priority, defaultValue: "basic")
                    t.column(deadline)
                    t.column(isDone, defaultValue: false)
                    t.column(creationDate)
                    t.column(modifyDate)
                    t.column(colorHEX)
                    t.column(last_updated_by)
                })
            } catch {
                print("db can't create table")
            }
        }
        return db
    }
    
    static func insertOrReplaceOneTodoForSqlite(db: Connection?, todoItem: ToDoItem) {
        
        guard let db = db else {
            print("db is nil")
            return
        }
        let deadlineTmp = todoItem.deadline?.timeIntervalSince1970
        let modifyDateTmp = todoItem.modifyDate?.timeIntervalSince1970
        
        let rowId = try? db.run(todo.insert(or: .replace,
                                            id <- todoItem.id,
                                            text <- todoItem.text,
                                            priority <- todoItem.priority.rawValue,
                                            deadline <- (deadlineTmp != nil ? Int64(deadlineTmp ?? 0) : nil),
                                            isDone <- todoItem.isDone,
                                            creationDate <- Int64(todoItem.creationDate.timeIntervalSince1970),
                                            modifyDate <- (modifyDateTmp != nil ? Int64(modifyDateTmp ?? 0) : nil),
                                            colorHEX <- todoItem.colorHEX,
                                            last_updated_by <- todoItem.last_updated_by))
        
    }
    
    static  func deleteTodoFromSqlite(db: Connection?, todoItem: ToDoItem) {
        
        guard let db = db else {
            print("db is nil")
            return
        }
        let alice = todo.filter(id == todoItem.id)
        do {
            try db.run(alice.delete())
        } catch {
            print("delete todo from sql error")
        }
    }
    
    static func createTodoItemArrayFromSQLiteDB(db: Connection?) -> [ToDoItem] {
        
        guard let db = db else { return [ToDoItem]()}
        var todoArray = [ToDoItem]()
        do {
            let tmpDb = try db.prepare(todo)

            for todo in tmpDb {
                
                var deadlineTmp: Date?
                var modifyDateTmp: Date?
                
                if let deadlineValue = todo[deadline] {
                    deadlineTmp = Date(timeIntervalSince1970: TimeInterval(deadlineValue))
                }
                if let modifyDateValue = todo[modifyDate] {
                    modifyDateTmp = Date(timeIntervalSince1970: TimeInterval(modifyDateValue))
                }

                let todoItem = ToDoItem(id: todo[id],
                                        text: todo[text],
                                        priority: ToDoItem.Priority(rawValue: todo[priority]) ?? .normal,
                                        deadline: deadlineTmp,
                                        isDone: todo[isDone],
                                        creationDate: Date(timeIntervalSince1970: TimeInterval(todo[creationDate])),
                                        modifyDate: modifyDateTmp,
                                        colorHEX: todo[colorHEX],
                                        last_updated_by: todo[last_updated_by])
                todoArray.append(todoItem)
            }
        } catch {
            print("create todoArray from sql error")
        }
        return todoArray
    }
}
