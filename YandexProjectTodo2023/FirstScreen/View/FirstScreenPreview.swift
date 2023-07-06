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
            vc.dataCompletionHandler = { data in
                
                if data.creationDate == Date.distantPast {
                    
                    // DELETE todo from network
                    let networkService = DefaultNetworkingService()
                    networkService.deleteTodoItem(todoItem: self.collectionToDo[indexPath.row], revision: self.networkCache.revision!) { result in
                        print(result)
                    }
                    
                    self.collectionToDo.remove(at: indexPath.row)
                    self.collectionToDo.sort { $0.creationDate < $1.creationDate }
                    self.tableView.reloadData()
                    
                    // DELETE todo from file
                    FileCachePackage.FileCache.saveToDefaultFileAsync(collectionToDo: self.collectionToDo, collectionToDoComplete: self.collectionToDoComplete)
                    
                    return
                }
                
                self.collectionToDo[indexPath.row] = data
                self.collectionToDo.sort { $0.creationDate < $1.creationDate }
                self.tableView.reloadData()
                
                FileCachePackage.FileCache.saveToDefaultFileAsync(collectionToDo: self.collectionToDo, collectionToDoComplete: self.collectionToDoComplete)
                    
                // PUT todo from network
                let networkService = DefaultNetworkingService()
                networkService.putTodoItem(todoItem: self.collectionToDo[indexPath.row], revision: self.networkCache.revision!) { result in
                    print(result)
                }
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
