import Foundation
import UIKit
import FileCachePackage

// MARK: Button "Y" for New Todo

extension FirstScreenViewController {
    
    func createYButton() {
       button.frame = CGRect(x: view.bounds.midX - 25, y: view.bounds.maxY - 100, width: 50, height: 50)
   }
    
     func settingButtonPlus(button: UIButton) -> UIButton {

        let image = UIImage(named: "yandex")
  
        button.configuration = UIButton.Configuration.plain()
        button.setImage(image, for: .normal)
       
        button.backgroundColor = .clear
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.3
        
        button.addTarget(self, action: #selector(tapPlusButton), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUpOutside), for: .touchUpOutside)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragButton(_:)))
    
         button.addGestureRecognizer(panGesture)
    
        return button
    }
    
    @objc func tapPlusButton() {
        
        let vc = SecondScreenViewController(cellFrame: button.frame)
        vc.toDo = ToDoItem(text: vc.defaultPhraseForTextView, priority: ToDoItem.Priority.normal)
        vc.db = self.db
        vc.coreDataManager = self.coreDataManager
        
        vc.dataCompletionHandler = { [self] data in

            if data.creationDate == Date.distantPast {
                return
            }
            // MARK: Homework 7*
            
//            FileCacheSQLite.insertOrReplaceOneTodoForSqlite(db: db, todoItem: data)
            
            // MARK: Homework 7**
            coreDataManager.saveTodoToCoreData(todo: data)
            
            self.collectionToDo.append(data)
            self.collectionToDo.sort { $0.creationDate < $1.creationDate }
            self.tableView.reloadData()
            
            FileCacheJSON.saveToDefaultFileAsync(collectionToDo: self.collectionToDo, collectionToDoComplete: self.collectionToDoComplete)
            
            // MARK: Homework 6 - Update from server

//            networkingService.handleRequest(todoItem: data, method: .post, type: .post, revision: networkCache.revision ?? 0) { result in
//                Task {
//                    await self.resultProcessing(result: result)
//                }
//            }
          
        }
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true)
    }
}
