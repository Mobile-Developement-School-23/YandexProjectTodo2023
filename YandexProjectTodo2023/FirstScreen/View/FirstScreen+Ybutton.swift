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
        vc.toDo = FileCachePackage.ToDoItem(text: vc.defaultPhraseForTextView, priority: FileCachePackage.ToDoItem.Priority.normal)
        
        vc.dataCompletionHandler = { data in

            if data.creationDate == Date.distantPast {
                return
            }
            self.collectionToDo.append(data)
            self.collectionToDo.sort { $0.creationDate < $1.creationDate }
            self.tableView.reloadData()
            
            FileCachePackage.FileCache.saveToDefaultFileAsync(collectionToDo: self.collectionToDo, collectionToDoComplete: self.collectionToDoComplete)
        }
        vc.modalTransitionStyle = .coverVertical
        navigationController?.present(vc, animated: true)
    }
}
