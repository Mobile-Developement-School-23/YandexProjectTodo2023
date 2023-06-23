import Foundation
import UIKit

class FirstScreenViewController: UIViewController {
    
    lazy var cacheToDo = FileCache()
    public lazy var collectionToDo = [ToDoItem]()
    lazy var collectionToDoComplete = [ToDoItem]()
    lazy var tableView: UITableView = .init(frame: CGRect(), style: .insetGrouped)
    lazy var isCellVisible = false
    lazy var buttonHeaderRight = UIButton()
    lazy var button = UIButton()
    lazy var buttonCenter = CGPoint()
    lazy var emitter = CAEmitterLayer()
    lazy var feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: Last grey cell
    
    private let todoLast = ToDoItem(text: "Новое", priority: .normal, creationDate: Date.distantFuture)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cacheToDo = FileCache.readFromFile(fileName: "fileCacheForTests", fileType: .json) ?? FileCache()
        
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
