import Foundation
import CoreData

class CoreDataManager {
    
   private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FileCacheCoreDataModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
   private lazy var viewContext = persistentContainer.viewContext
    
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
   private func convertTodoItemToEntity(todo: ToDoItem) -> TodoItemEntity {
        
        let todoEntity = TodoItemEntity(context: viewContext)
        todoEntity.id = todo.id
        todoEntity.text = todo.text
        todoEntity.priority = todo.priority.rawValue
        todoEntity.deadline = todo.deadline
        todoEntity.isDone = todo.isDone
        todoEntity.creationDate = todo.creationDate
        todoEntity.modifyDate = todo.modifyDate
        todoEntity.colorHEX = todo.colorHEX
        todoEntity.last_updated_by = todo.last_updated_by

        return todoEntity
    }
    
   private func convertEntityToTodoItem(entity: TodoItemEntity) -> ToDoItem {
        
        let todo = ToDoItem(id: entity.id ?? "",
                            text: entity.text ?? "",
                            priority: ToDoItem.Priority(rawValue: entity.priority ?? "") ?? .normal,
                            deadline: entity.deadline,
                            isDone: entity.isDone,
                            creationDate: entity.creationDate ?? .now,
                            modifyDate: entity.modifyDate,
                            colorHEX: entity.colorHEX ?? "",
                            last_updated_by: entity.last_updated_by ?? "")
        
        return todo
    }
    
    func saveCollectionTodoToCoreData(todoArray: [ToDoItem]) {
        for i in todoArray {
           saveTodoToCoreData(todo: i)
        }
    }
    
    func saveTodoToCoreData(todo: ToDoItem) {
        _ = convertTodoItemToEntity(todo: todo)
        saveContext()
    }
    
    func updateTodoFromCoreData(todo: ToDoItem) {
        let fetchRequest = TodoItemEntity.fetchRequest()
        let uuidString = todo.id
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuidString)
        
        do {
                let objects = try viewContext.fetch(fetchRequest)
                for object in objects {
                    object.text = todo.text
                    object.colorHEX = todo.colorHEX
                    object.creationDate = todo.creationDate
                    object.deadline = todo.deadline
                    object.isDone = todo.isDone
                    object.last_updated_by = todo.last_updated_by
                    object.priority = todo.priority.rawValue
                    object.modifyDate = todo.modifyDate
                }
                try viewContext.save()
            } catch let error {
                print("ERROR: \(error)")
            }
    }
    
    func deleteTodoFromCoreData(todo: ToDoItem) {
        let fetchRequest = TodoItemEntity.fetchRequest()
        let uuidString = todo.id
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuidString)
                
        do {
            let objects = try viewContext.fetch(fetchRequest)
            for object in objects {
                viewContext.delete(object)
            }
            try viewContext.save()
        } catch let error {
            print("ERROR: \(error)")
        }
    }
    
    func getCollectionTodoFromCoreData() -> [ToDoItem] {
        
        var resultArray = [ToDoItem]()
        let fetchRequest = TodoItemEntity.fetchRequest()
        
        do {
            let objects = try viewContext.fetch(fetchRequest)
            for object in objects {
                resultArray.append(convertEntityToTodoItem(entity: object))
            }
        } catch let error {
            print("ERROR: \(error)")
        }
        
       return resultArray
    }
}
