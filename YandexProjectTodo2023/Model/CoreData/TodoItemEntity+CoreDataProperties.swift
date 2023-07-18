//
//  TodoItemEntity+CoreDataProperties.swift
//  
//
//  Created by Дмитрий Гусев on 10.07.2023.
//
//

import Foundation
import CoreData

extension TodoItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItemEntity> {
        return NSFetchRequest<TodoItemEntity>(entityName: "TodoItemEntity")
    }

    @NSManaged public var colorHEX: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var deadline: Date?
    @NSManaged public var id: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var last_updated_by: String?
    @NSManaged public var modifyDate: Date?
    @NSManaged public var priority: ToDoItem?
    @NSManaged public var text: String?

}
