import Foundation
import UIKit
import FileCachePackage

class FirstScreenViewController: UIViewController {
    
    lazy var cacheToDo = FileCachePackage.FileCache()
    public lazy var collectionToDo = [FileCachePackage.ToDoItem]()
    lazy var collectionToDoComplete = [FileCachePackage.ToDoItem]()
    lazy var tableView: UITableView = .init(frame: CGRect(), style: .insetGrouped)
    lazy var isCellVisible = false
    lazy var buttonHeaderRight = UIButton()
    lazy var button = UIButton()
    lazy var buttonCenter = CGPoint()
    lazy var emitter = CAEmitterLayer()
    lazy var feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: Last grey cell
    
    private let todoLast = FileCachePackage.ToDoItem(text: "Новое", priority: .normal, creationDate: Date.distantFuture)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Для проверки ДЗ 5
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let urlSession = URLSession.shared
        let urlRequest = URLRequest(url: url)

        let taskConcurrent = Task {
            let task = try await urlSession.dataTask(for: urlRequest)

            let json = try JSONSerialization.jsonObject(with: task.0)
            print(task.0)

        }
        let taskConcurrent2 = Task {
            let task = try await urlSession.dataTask(for: urlRequest)

            let json = try JSONSerialization.jsonObject(with: task.0)
            print(task.0)

        }
        let taskConcurrent3 = Task {
            let task = try await urlSession.dataTask(for: urlRequest)

            let json = try JSONSerialization.jsonObject(with: task.0)
            print(task.0)

        }
//          отмена таски
        taskConcurrent.cancel()
        
        cacheToDo = FileCachePackage.FileCache.readFromFile(fileName: "fileCacheForTests", fileType: .json) ?? FileCachePackage.FileCache()
        
        collectionToDo = cacheToDo.getCollectionToDo().sorted { $0.creationDate < $1.creationDate }
        
        collectionToDo.append(todoLast)
        
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
