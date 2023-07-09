import UIKit
import SQLite
import Foundation


// MARK: SQLite

class FileCacheSQLite {
    
    static func checkOldDataBaseAndCreateNew() -> Connection? {
        
        var nameDB = "SQLiteTodoDB.sqlite3"
        var db = try? Connection()
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dbPath = documentsUrl.appendingPathComponent(nameDB).path
        
        if fileManager.fileExists(atPath: dbPath) {
            
            print("База данных существует")
            do {
                db = try Connection("\(documentsUrl.absoluteString)/\(nameDB)")
                
            } catch {
                print("db can't read")
            }
            return db
            
        } else {
            
            print("База данных НЕ существует")
            
            // База данных не существует
            let todo = Table("todo")
            
            let id = Expression<String>("id")
            let text = Expression<String>("text")
            let priority = Expression<String>("priority")
            let deadline = Expression<Int64?>("deadline")
            let isDone = Expression<Bool>("isDone")
            let creationDate = Expression<Int64>("creationDate")
            let modifyDate = Expression<Int64?>("modifyDate")
            let colorHEX = Expression<String>("colorHEX")
            let last_updated_by = Expression<String>("last_updated_by")
            
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
    
    
    
  static  func insertOrReplaceOneTodoForSqlite(db: Connection, todoItem: ToDoItem) {
        
        let todo = Table("todo")
        
        var id = Expression<String>("id")
        var text = Expression<String>("text")
        var priority = Expression<String>("priority")
        var deadline = Expression<Int64?>("deadline")
        var isDone = Expression<Bool>("isDone")
        var creationDate = Expression<Int64>("creationDate")
        var modifyDate = Expression<Int64?>("modifyDate")
        var colorHEX = Expression<String>("colorHEX")
        var last_updated_by = Expression<String>("last_updated_by")
        
        
        let rowId = try? db.run(todo.insert(or: .replace, id <- todoItem.id, text <- todoItem.text, priority <- todoItem.priority.rawValue, deadline <- Int64(todoItem.deadline?.timeIntervalSince1970 ?? 0), isDone <- todoItem.isDone, creationDate <- Int64(todoItem.creationDate.timeIntervalSince1970), modifyDate <- Int64(todoItem.modifyDate?.timeIntervalSince1970 ?? 0), colorHEX <- todoItem.colorHEX, last_updated_by <- todoItem.last_updated_by))
        
        print(rowId)
        
        
        
        func getTodoFromSQLite(db: Connection) {
            
            let todos = Table("todo")
            
            do {
                let todo = todos.filter(id == "rowId")
                let first = try? db.pluck(todo)
                if let first = first {
                    print("id: \(first[id]), text: \(first[text])")
                } else {
                    print("Todo not found")
                }
            } catch {
                // обработка ошибок
            }
        }
    }
    
   static func createTodoItemArrayFromSQLiteDB(db: Connection) -> [ToDoItem] {
        
        var todoArray = [ToDoItem]()
        let todos = Table("todo")
        
        let id = Expression<String>("id")
        let text = Expression<String>("text")
        let priority = Expression<String>("priority")
        let deadline = Expression<Int64?>("deadline")
        let isDone = Expression<Bool>("isDone")
        let creationDate = Expression<Int64>("creationDate")
        let modifyDate = Expression<Int64?>("modifyDate")
        let colorHEX = Expression<String>("colorHEX")
        let last_updated_by = Expression<String>("last_updated_by")
        
        
        for todo in try! db.prepare(todos) {

            var todoItem = ToDoItem(id: todo[id],
                                    text: todo[text],
                                    priority: ToDoItem.Priority(rawValue: todo[priority]) ?? .normal,
                                    deadline: Date(timeIntervalSince1970: TimeInterval(todo[deadline] ?? 0)),
                                    isDone: todo[isDone],
                                    creationDate: Date(timeIntervalSince1970: TimeInterval(todo[creationDate])),
                                    modifyDate: Date(timeIntervalSince1970: TimeInterval(todo[modifyDate] ?? 0)),
                                    colorHEX: todo[colorHEX],
                                    last_updated_by: todo[last_updated_by])
            todoArray.append(todoItem)
        }
        
        return todoArray
    }
}
