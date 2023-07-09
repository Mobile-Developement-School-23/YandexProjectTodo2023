import Foundation
import SQLite
import UIKit

class FirstScreenViewController: UIViewController {
   
    lazy var db = try? Connection()
    
    lazy var refreshControl = UIActivityIndicatorView()
    
    lazy var cacheToDo = FileCacheJSON()
    public lazy var collectionToDo = [ToDoItem]()
    lazy var collectionToDoComplete = [ToDoItem]()
    
    lazy var networkingService = DefaultNetworkingService()
    lazy var networkCache = TodoList() {
        
        willSet {
            guard let newCollectionTodo = newValue.list else { return }
            collectionToDo = newCollectionTodo
            collectionToDo.sort { $0.creationDate < $1.creationDate }
            checkLastCell()
            removeCompleteToDoFromArray()
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = .init(frame: CGRect(), style: .insetGrouped)
    lazy var isCellVisible = false
    lazy var buttonHeaderRight = UIButton()
    lazy var button = UIButton()
    lazy var buttonCenter = CGPoint()
    lazy var emitter = CAEmitterLayer()
    lazy var feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    lazy var loadingIndicator = UIActivityIndicatorView()
    
    // MARK: Last grey cell
    
    private let todoLast = ToDoItem(text: "Новое", priority: .normal, creationDate: Date.distantFuture, modifyDate: .distantFuture)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Homework 1-2 - JSON


//        cacheToDo = FileCacheJSON.readFromFile(fileName: "fileCacheForTests", fileType: .json) ?? FileCacheJSON()
        
//        collectionToDo = cacheToDo.getCollectionToDo()
//        collectionToDo.sort { $0.creationDate < $1.creationDate }
        
        
        // MARK: Homework 6 - Update from server
        
        // activityIndicator Observer
//        NotificationCenter.default.addObserver(self, selector: #selector(activeRequestsChanged), name: .activeRequestsChanged, object: nil)
        
        // update tableview from server
//        networkingService.handleRequest(todoList: TodoList(list: collectionToDo + collectionToDoComplete), method: .patch, type: .patch, revision: networkCache.revision ?? 0)
//        { result in
//                    Task {
//                        await self.resultProcessing(result: result)
//                    }
//                }
        
        
        //MARK: Homework 7 SQLite
        
        
        db = FileCacheSQLite.checkOldDataBaseAndCreateNew()

//        FileCache.insertOrReplaceOneTodoForSqlite(db: db!, todoItem: ToDoItem(id: "5", text: "text5", priority: .normal, deadline: .now, isDone: false, creationDate: .now, modifyDate: .now, colorHEX: "sdf", last_updated_by: "him56"))

        var arr = FileCacheSQLite.createTodoItemArrayFromSQLiteDB(db: db!)
        collectionToDo = arr

        
        removeCompleteToDoFromArray()
        checkLastCell()

        
    }
    
    override func loadView() {
        prepareTableView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        prepareTableEmitterButton()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        createYButton()
    }
    
    func checkLastCell() {
        if collectionToDo.last?.text != "Новое" {
            collectionToDo.append(todoLast)
        }
    }
    
}

// MARK: Array for TableView

extension FirstScreenViewController {
    
    func removeCompleteToDoFromArray() {
        
        var comleteToDo = [ToDoItem]()
        var resultArrayToDo = [ToDoItem]()
        for i in 0..<collectionToDo.count {
            if !collectionToDo[i].isDone {
                resultArrayToDo.append(collectionToDo[i])
            } else {
                comleteToDo.append(collectionToDo[i])
            }
        }
        collectionToDo = resultArrayToDo.sorted(by: { $0.creationDate < $1.creationDate })
        collectionToDoComplete = comleteToDo.sorted(by: { $0.creationDate < $1.creationDate })
    }
    
    func addDoneToDoForCollection() {
        
        var resultArrayToDo = collectionToDo
        for i in 0..<collectionToDoComplete.count {
            resultArrayToDo.append(collectionToDoComplete[i])
        }
        collectionToDo = resultArrayToDo.sorted(by: { $0.creationDate < $1.creationDate })
        collectionToDoComplete = [ToDoItem]()
    }
}
