import Foundation
import UIKit
import FileCachePackage

class FirstScreenViewController: UIViewController {
    
    lazy var cacheToDo = FileCachePackage.FileCache()
    public lazy var collectionToDo = [FileCachePackage.ToDoItem]()
    lazy var collectionToDoComplete = [FileCachePackage.ToDoItem]()
    
    lazy var networkCache = FileCachePackage.TodoList(status: "ok") {
        
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
    lazy var activityIndicator = UIActivityIndicatorView()
    
    // MARK: Last grey cell
    
    private let todoLast = FileCachePackage.ToDoItem(text: "Новое", priority: .normal, creationDate: Date.distantFuture, modifyDate: .distantFuture)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        cacheToDo = FileCachePackage.FileCache.readFromFile(fileName: "fileCacheForTests", fileType: .json) ?? FileCachePackage.FileCache()
        
        collectionToDo = cacheToDo.getCollectionToDo()
        collectionToDo.sort { $0.creationDate < $1.creationDate }
        
        checkLastCell()
     
        let network = DefaultNetworkingService()
        
        network.fetchData { result in
            switch result {
            case .success(let networkCache):
                DispatchQueue.main.async {
                    self.networkCache = networkCache
//                    print(self.networkCache)
//                    print(self.collectionToDo)
                }
            case .failure(let error): 
                // Handle error
                print(error)
            }
        }
        
        
        removeCompleteToDoFromArray()
  
//        network.getTodoItemFromId(todoId: "8A5FEE9E-287B-478A-AA3C-FCC5D4B803DC") { result in
//        print(result)
//            switch result {
//            case .success(let todoList):
//
////                print(Thread.current)
//                print(todoList)
//            case .failure(let error):
//                // Handle error
//                print(error)
//            }
//        }
        
//        network.postTodoItem(todoItem: FileCachePackage.ToDoItem(id: "34234", text: "test", priority: .normal, deadline: .now, isDone: false, creationDate: .now, modifyDate: .now, last_updated_by: ""), revision: networkCache.revision ?? 0) { result in
//                        switch result {
//        print(result)
//                        case .success(let todoItem):
//
//                            print(Thread.current)
//                            print(todoItem)
//                        case .failure(let error):
//                            // Handle error
//                            print(error)
//                        }
//        }
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
        settingAcitvityIndicator()
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
        
         var comleteToDo = [FileCachePackage.ToDoItem]()
         var resultArrayToDo = [FileCachePackage.ToDoItem]()
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
         collectionToDoComplete = [FileCachePackage.ToDoItem]()
    }
}
