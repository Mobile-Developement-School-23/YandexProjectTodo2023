import Foundation
import UIKit

// MARK: TableView Settings + Emitter

extension FirstScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func prepareTableView() {
        self.view = UIView()
        tableView.register(FirstScreenTableViewCell.self, forCellReuseIdentifier: Constants.reuseId)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    func prepareTableEmitterButton() {
       tableView.frame = view.bounds
       view.addSubview(settingButtonPlus(button: button))
       emitter = createEmitter()
   }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return collectionToDo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseId, for: indexPath)
        guard let cell = cell as? FirstScreenTableViewCell else {
            return cell
        }
        
        return cell.settingCell(collectionToDo: collectionToDo, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if collectionToDo[indexPath.row].creationDate == .distantFuture {
            tapPlusButton()
        }
    }
}

// MARK: Leading & Trailing swipeAction in TableView

extension FirstScreenViewController {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.row == collectionToDo.count - 1 {
            return nil
        }
        
        let action = UIContextualAction(style: .normal, title: "", handler: {  ( _, _, _ ) in
            self.collectionToDo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
            FileCache.saveToDefaultFileAsync(collectionToDo: self.collectionToDo, collectionToDoComplete: self.collectionToDoComplete)
        })
        
        action.image = UIImage(systemName: "trash", withConfiguration: .none)
        action.backgroundColor = .red
        
        let actionTwo = UIContextualAction(style: .normal, title: "", handler: { _, _, completionHandler in
            
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            let frame = tableView.convert(cell.frame, to: tableView.superview)
            
            let vc = SecondScreenViewController(cellFrame: frame)
            vc.toDo = self.collectionToDo[indexPath.row]
            
            vc.dataCompletionHandler = { data in
                
                if data.creationDate == Date.distantPast {
                    
                    self.collectionToDo.remove(at: indexPath.row)
                    self.collectionToDo.sort { $0.creationDate < $1.creationDate }
                    self.tableView.reloadData()
                    return
                }
                
                self.collectionToDo[indexPath.row] = data
                self.collectionToDo.sort { $0.creationDate < $1.creationDate }
                self.tableView.reloadData()
                
                FileCache.saveToDefaultFileAsync(collectionToDo: self.collectionToDo, collectionToDoComplete: self.collectionToDoComplete)
                    
            }
//            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true)
            completionHandler(true)
            
        })
        actionTwo.image = UIImage(systemName: "info.circle.fill")
        actionTwo.backgroundColor = .systemGray4
        
        let configuration = UISwipeActionsConfiguration(actions: [action, actionTwo])
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row == collectionToDo.count - 1 {
            return nil
        }
        let action = UIContextualAction(style: .normal, title: "", handler: { _, _, _ in
            self.collectionToDo[indexPath.row].isDone = !self.collectionToDo[indexPath.row].isDone
            self.pressedButtonHeaderRight()
            self.pressedButtonHeaderRight()
            tableView.reloadData()
            
            FileCache.saveToDefaultFileAsync(collectionToDo: self.collectionToDo, collectionToDoComplete: self.collectionToDoComplete)
        })
        action.image = UIImage(systemName: "checkmark.circle.fill")
        action.backgroundColor = .systemGreen
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        
        return configuration
    }
}

// MARK: Header Button & Label

extension FirstScreenViewController {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let viewHeader = UIView()
        let labelHeaderLeft = UILabel(frame: CGRect(x: 20, y: 0, width: 150, height: 40))
        var counter = 0
        for i in collectionToDo where i.isDone {
            counter += 1
        }
        labelHeaderLeft.text = "Выполнено - \(counter + collectionToDoComplete.count)"
        labelHeaderLeft.textColor = .systemGray
        
        viewHeader.addSubview(buttonHeaderRight)
        viewHeader.addSubview(labelHeaderLeft)
        
        buttonHeaderRight.frame = CGRect(x: viewHeader.bounds.maxX - 100, y: 0, width: 150, height: 40)
        buttonHeaderRight.setTitle("Показать", for: .normal)
        buttonHeaderRight.setTitle("Скрыть", for: .selected)
        buttonHeaderRight.setTitleColor(.systemBlue, for: .normal)
        buttonHeaderRight.addTarget(self, action: #selector(pressedButtonHeaderRight), for: .touchUpInside)
        buttonHeaderRight.translatesAutoresizingMaskIntoConstraints = false
        buttonHeaderRight.centerYAnchor.constraint(equalTo: viewHeader.centerYAnchor).isActive = true
        buttonHeaderRight.trailingAnchor.constraint(equalTo: viewHeader.trailingAnchor, constant: -32).isActive = true
        
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    @objc func pressedButtonHeaderRight() {
        
        buttonHeaderRight.isSelected = !isCellVisible
        
        isCellVisible = !isCellVisible
        if isCellVisible {
            addDoneToDoForCollection()
            tableView.reloadData()
        } else {
            removeCompleteToDoFromArray()
            tableView.reloadData()
        }
        
    }
}
