import XCTest

@testable import YandexProjectTodo2023

final class YandexToDo2022Tests: XCTestCase {

    var toDoItem1: ToDoItem?
    var toDoItem2: ToDoItem?
    var toDoItem3: ToDoItem?
    var toDoItem4: ToDoItem?
    var fileCache: FileCacheJSON?
    var json: Any?
    var csv: Any?

    override func setUpWithError() throws {

        fileCache = FileCacheJSON()

        toDoItem1 = ToDoItem(id: "testID1", text: "testText1", priority: .low, deadline: Date.now.addingTimeInterval(1600),
isDone: false, creationDate: .now, modifyDate: Date.now.addingTimeInterval(4200))
        toDoItem2 = ToDoItem(id: "testID2", text: "testText2", priority: .low, isDone: false, creationDate: .now, modifyDate: Date.now.addingTimeInterval(3200))
        toDoItem3 = ToDoItem(id: "testID3", text: "testText3", priority: .low, deadline: Date.now.addingTimeInterval(3600), isDone: false, modifyDate: Date.now.addingTimeInterval(2200))
        toDoItem4 = ToDoItem(id: "testID4", text: "testText4", priority: .low, deadline: Date.now.addingTimeInterval(4600), isDone: false, creationDate: .now)

        try fileCache?.addNewToDo(toDoItem1!)
        try fileCache?.addNewToDo(toDoItem2!)
        try fileCache?.addNewToDo(toDoItem3!)
        try fileCache?.addNewToDo(toDoItem4!)

    }

    override func tearDownWithError() throws {
        toDoItem1 = nil
        toDoItem2 = nil
        toDoItem3 = nil
        toDoItem4 = nil
        fileCache = nil
        json = nil
        csv = nil
    }

    func testToDoNotNil() {
        XCTAssertNotNil(toDoItem1)
    }
    func testToDoJsonNotNil() {
        json = toDoItem1?.json
        XCTAssertNotNil(json)
    }
    func testToDoCsvNotNil() {
        csv = toDoItem1?.csv
        XCTAssertNotNil(csv)
    }

    func testParseJson() {
        json = toDoItem1?.json
        let jsonToDo = ToDoItem.parseJson(json: json as Any)!

        equalTodoItem(todo1: jsonToDo, todo2: toDoItem1!)

    }
    func testParseCsv() {

        csv = toDoItem1?.csv
        let csvToDo = ToDoItem.parseCSV(csv: csv as Any)!

        equalTodoItem(todo1: csvToDo, todo2: toDoItem1!)
    }

    func equalTodoItem(todo1: ToDoItem, todo2: ToDoItem) {

        XCTAssertEqual(todo1.id, todo2.id)
        XCTAssertEqual(todo1.text, todo2.text)
        XCTAssertEqual(todo1.priority, todo2.priority)
        XCTAssertEqual(floor(todo1.deadline?.timeIntervalSince1970 ?? 0), floor(todo2.deadline?.timeIntervalSince1970 ?? 1))
        XCTAssertEqual(todo1.isDone, todo2.isDone)
        XCTAssertEqual(floor(todo1.creationDate.timeIntervalSince1970), floor(todo2.creationDate.timeIntervalSince1970))
        XCTAssertEqual(floor(todo1.modifyDate?.timeIntervalSince1970 ?? 0), floor(todo2.modifyDate?.timeIntervalSince1970 ?? 1))

    }

    func testSaveLoadCsv() {
        let collectionTodo = fileCache?.getCollectionToDo()

        fileCache?.saveToFile(fileName: "testSaveCsv", fileType: .csv)

        let cacheFromFile = FileCacheJSON.readFromFile(fileName: "testSaveCsv", fileType: .csv)

        let collectionTodoFromFile = cacheFromFile?.getCollectionToDo()

        let countInCollection = collectionTodo?.count == collectionTodoFromFile?.count

        XCTAssertTrue(countInCollection)

    }

    func testSaveLoadJson() {
        let collectionTodo = fileCache?.getCollectionToDo()

        fileCache?.saveToFile(fileName: "testSaveJson", fileType: .json)

        let cacheFromFile = FileCacheJSON.readFromFile(fileName: "testSaveJson", fileType: .json)

        let collectionTodoFromFile = cacheFromFile?.getCollectionToDo()

        let countInCollection = collectionTodo?.count == collectionTodoFromFile?.count

        XCTAssertTrue(countInCollection)
    }

    func testCreateTodoWithOneIdTwice() {

        XCTAssertThrowsError(try fileCache?.addNewToDo(toDoItem1!))
        XCTAssertThrowsError(try fileCache?.addNewToDo(toDoItem1!))
    }

    func testParseCsvWithWrongData() {
        XCTAssertNil(ToDoItem.parseCSV(csv: toDoItem1 as Any))
    }
    func testParseJsonWithWrongData() {
        XCTAssertNil(ToDoItem.parseJson(json: toDoItem1 as Any))
    }
    func testDeleteTodo() {
        let countBefore = fileCache?.getCollectionToDo().count
        fileCache?.deleteToDo("testID1")
        let countAfter = (fileCache?.getCollectionToDo().count)! + 1

        XCTAssertEqual(countBefore, countAfter)
    }

    func testReadWrongPath() {
        XCTAssertNil(FileCacheJSON.readFromFile(fileName: "foo", fileType: .csv))
        XCTAssertNil(FileCacheJSON.readFromFile(fileName: "foo", fileType: .json))
    }

    func testReadFromWrongData() {

        let fileName = "foo"
        let fullPath = FileCacheJSON.getDocumentsDirectory().appendingPathComponent(fileName )
        let strFrom = "efdwrged, sdv sd d \n fgfsd, sdf adf \n sdf, sfsdf  \n"

        do {
            try strFrom.write(to: fullPath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print( "failed to write file")
        }

        XCTAssertNil(FileCacheJSON.readFromFile(fileName: "foo", fileType: .csv))
        XCTAssertNil(FileCacheJSON.readFromFile(fileName: "foo", fileType: .json))

    }

}
