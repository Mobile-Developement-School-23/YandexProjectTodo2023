import Foundation
import UIKit
import FileCachePackage

// MARK: Preview & context menu
extension FirstScreenViewController {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        if self.collectionToDo[indexPath.row].creationDate == .distantFuture {
            return nil
        }
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: { () -> UIViewController? in
            let vc = SecondScreenViewController()
            vc.buttonClose.isHidden = true
            vc.buttonSave.isHidden = true
            vc.toDo = self.collectionToDo[indexPath.row]
            vc.db = self.db
            vc.coreDataManager = self.coreDataManager
            vc.dataCompletionHandler = { data in
                
                if data.creationDate == Date.distantPast {
                    
                    // MARK: Homework 7*
                    
//                    FileCacheSQLite.deleteTodoFromSqlite(db: self.db, todoItem: self.collectionToDo[indexPath.row])
                    
                    // MARK: Homework 7**
                    self.coreDataManager.deleteTodoFromCoreData(todo: self.collectionToDo[indexPath.row])
                    
                    // MARK: Homework 6 - Update from server

                    // DELETE todo from network
//                    self.networkingService.handleRequest(todoItem: self.collectionToDo[indexPath.row], method: .delete, type: .delete, revision: self.networkCache.revision ?? 0) { result in
//                        Task {
//                            await self.resultProcessing(result: result)
//                        }
//                    }
      
                    self.collectionToDo.remove(at: indexPath.row)
                    self.collectionToDo.sort { $0.creationDate < $1.creationDate }
                    self.tableView.reloadData()
                    
                    // DELETE todo from file
                    FileCacheJSON.saveToDefaultFileAsync(collectionToDo: self.collectionToDo, collectionToDoComplete: self.collectionToDoComplete)
                    
                    return
                }
                
                self.collectionToDo[indexPath.row] = data
                self.collectionToDo.sort { $0.creationDate < $1.creationDate }
                self.tableView.reloadData()
                
                FileCacheJSON.saveToDefaultFileAsync(collectionToDo: self.collectionToDo, collectionToDoComplete: self.collectionToDoComplete)
                
                // MARK: Homework 6 - Update from server

                // PUT todo from network

//                self.networkingService.handleRequest(todoItem: self.collectionToDo[indexPath.row], method: .put, type: .put, revision: self.networkCache.revision ?? 0) { result in
//                    Task {
//                        await self.resultProcessing(result: result)
//                    }
//                }
                
                // MARK: Homework 7*
//                FileCacheSQLite.insertOrReplaceOneTodoForSqlite(db: self.db, todoItem: self.collectionToDo[indexPath.row])
                
                // MARK: Homework 7**
                self.coreDataManager.updateTodoFromCoreData(todo: self.collectionToDo[indexPath.row])
                
            }
            
            return vc
        },
                                                       actionProvider: { _ in
            let action1 = UIAction(title: "Завершено") { _ in
                self.doneUndone(indexPath)
            }
            if self.collectionToDo[indexPath.row].isDone {
                action1.title = "Не завершено"
            }
            let action2 = UIAction(title: "Удалить", attributes: .destructive) { _ in
                self.removeAndDeleteTodo(indexPath)
            }
            return UIMenu(title: "", children: [action1, action2])})
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView,
                   willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                   animator: UIContextMenuInteractionCommitAnimating) {
        guard let viewController = animator.previewViewController else { return }
        animator.addCompletion {
            let vc = viewController as? SecondScreenViewController
            vc?.buttonSave.isHidden = false
            vc?.buttonClose.isHidden = false
            vc?.dismiss(animated: false) {
                
                self.present(viewController, animated: true, completion: nil)
            }
        }
    }
}
