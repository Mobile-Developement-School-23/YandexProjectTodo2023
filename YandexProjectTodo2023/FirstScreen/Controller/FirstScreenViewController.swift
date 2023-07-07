import Foundation
import UIKit
import FileCachePackage

class FirstScreenViewController: UIViewController {
    
    lazy var refreshControl = UIActivityIndicatorView()
    
    lazy var cacheToDo = FileCachePackage.FileCache()
    public lazy var collectionToDo = [FileCachePackage.ToDoItem]()
    lazy var collectionToDoComplete = [FileCachePackage.ToDoItem]()
    
    lazy var networkingService = DefaultNetworkingService()
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
    lazy var loadingIndicator = UIActivityIndicatorView()
    
    // MARK: Last grey cell
    
    private let todoLast = FileCachePackage.ToDoItem(text: "Новое", priority: .normal, creationDate: Date.distantFuture, modifyDate: .distantFuture)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cacheToDo = FileCachePackage.FileCache.readFromFile(fileName: "fileCacheForTests", fileType: .json) ?? FileCachePackage.FileCache()
        
        collectionToDo = cacheToDo.getCollectionToDo()
        collectionToDo.sort { $0.creationDate < $1.creationDate }
        
        checkLastCell()
        
        // MARK: Homework 5 - URLSession
        
        func testURLSession() {
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
            let urlSession = URLSession.shared
            let request = URLRequest(url: url)
            let task = Task {
                await print( try? urlSession.dataTask(for: request))
            }
            //            task.cancel() // Для отмены запроса
        }
        //        testURLSession() // Старт
        
        // MARK: Homework 6 - Update from server
        
        // activityIndicatorObserver
        NotificationCenter.default.addObserver(self, selector: #selector(activeRequestsChanged), name: .activeRequestsChanged, object: nil)
        
        // обновляет таблицу
                networkingService.fetchData { result in
                    Task {
                        await self.resultProcessing(result: result)
                    }
                }
        
        removeCompleteToDoFromArray()
        
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
