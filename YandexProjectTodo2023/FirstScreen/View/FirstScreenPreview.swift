import Foundation
import UIKit

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
