import Foundation
import CoreData

extension TodoItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItemEntity> {
        return NSFetchRequest<TodoItemEntity>(entityName: "TodoItemEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var text: String?
    @NSManaged public var priority: NSObject?
    @NSManaged public var deadline: Date?
    @NSManaged public var isDone: Bool
    @NSManaged public var creationDate: Date?
    @NSManaged public var modifyDate: Date?
    @NSManaged public var colorHEX: String?
    @NSManaged public var last_updated_by: String?

}
