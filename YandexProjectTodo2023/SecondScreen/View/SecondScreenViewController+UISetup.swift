import Foundation
import UIKit

// MARK: Prepare for VC
extension SecondScreenViewController {
    
    func prepareUIforVC() {
       tableView.delegate = self
       tableView.dataSource = self
       tableView.translatesAutoresizingMaskIntoConstraints = false
       
       view.backgroundColor = .systemGroupedBackground
       view.addSubview(tableView)
       view.addSubview(topLabel)
       view.addSubview(buttonSave)
       view.addSubview(buttonClose)
       
       // disable save/delete buttons
       if toDo.text.isEmpty || toDo.text == defaultPhraseForTextView {
           buttonSave.isEnabled = false
           buttonDelete.isEnabled = false
       }

        // keyboard observer
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
   }
    
    func tableViewFrame() {
        
//        
//        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
//        tableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
//        tableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        
        let portraitFrame = CGRect(x: view.bounds.minX, y: view.bounds.minY + 50, width: view.bounds.width, height: view.bounds.height - 40)
        let landscapeFrame = CGRect(x: view.bounds.minX, y: view.bounds.minY, width: view.bounds.width, height: view.bounds.height - 40)

        let orientation = UIDevice.current.orientation
        switch orientation {
        case .portrait, .portraitUpsideDown:
            tableView.frame = portraitFrame
            topLabel.isHidden = false
            buttonSave.isHidden = false
            buttonClose.isHidden = false

        case .landscapeLeft, .landscapeRight:
            tableView.frame = landscapeFrame
            topLabel.isHidden = true
            buttonSave.isHidden = true
            buttonClose.isHidden = true
        default:
            tableView.frame = portraitFrame
        }
   }
}

// MARK: Functions in Second VC (button, segmentControl, calendar, animations for show/hide calendar)

extension SecondScreenViewController {
    
    @objc func openColorPicker() {
        
        self.view.endEditing(true)
        let vc = ColorPickerViewController()
        vc.todo = toDo
        present(vc, animated: true)
        
        vc.dataCompletionHandler = { data in
            self.toDo = data
            self.tableView.reloadData()
        }
    }
    
    @objc func didTapView() {
        self.view.endEditing(true)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        feedbackGenerator.impactOccurred()
        
        switch sender.selectedSegmentIndex {
        case 0:
            toDo.priority = .low
        case 1:
            toDo.priority = .normal
        case 2:
            toDo.priority = .high
        default:
            toDo.priority = .normal
        }
    }
    
    @objc func didTapOnSwitcher(_ sender: UISwitch) {
        
        self.view.endEditing(true)
        if sender.isOn && toDo.deadline == nil {
            dictTable[3] = "calendar"
        }
        
        if sender.isOn == false {
            toDo.deadline = nil
            dictTable[3] = nil
            animateReloadTableView()
        } else {
            toDo.deadline = Date.now.addingTimeInterval(86400)
        }
        
        animateReloadTableView()
    }
    
    @objc func showCalendar() {
        dictTable[3] == "calendar" ? (dictTable[3] = nil) : (dictTable[3] = "calendar")
        
        animateReloadTableView()
        
    }
    
    // animations for show/hide calendar
    
    func animateReloadTableView() {
        tableView.reloadData()
        UIView.transition(with: tableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
            self.tableView.reloadData()
        },
                          completion: nil)
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true)
    }
    
    @objc func closeVCAndSave() {
        
        self.view.endEditing(true)
        
        if let complition = dataCompletionHandler {
            complition(toDo)
        }
        self.dismiss(animated: true)
    }
    
    @objc func closeVCAndDelete() {
        
        self.view.endEditing(true)
        
        if let complition = dataCompletionHandler {
            toDo.creationDate = Date.distantPast
            complition(toDo)
        }

        self.dismiss(animated: true)
    }
}

// MARK: Setting top button & label

extension SecondScreenViewController {
    
     func settingCloseButton() {
        buttonClose.setTitle("Закрыть", for: .normal)
        buttonClose.setTitleColor(.systemBlue, for: .normal)
        buttonClose.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        buttonClose.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonClose.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonClose.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        ])
    }
    
     func settingSaveButton() {
        
        buttonSave.setTitle("Сохранить", for: .normal)
        buttonSave.setTitleColor(.systemGray, for: .disabled)
        buttonSave.setTitleColor(.systemBlue, for: .normal)
        buttonSave.addTarget(self, action: #selector(closeVCAndSave), for: .touchUpInside)
        
        buttonSave.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonSave.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            buttonSave.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        ])
    }
    
     func settingTopLabel() {
        topLabel.text = "Дело"
        topLabel.font = UIFont.boldSystemFont(ofSize: 19)
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14)
        ])
    }
}

extension SecondScreenViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
        // Taptic Engine when selecting a date in the calendar
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackGenerator.prepare()
        impactFeedbackGenerator.impactOccurred()
        toDo.deadline = dateComponents?.date
        tableView.reloadData()
    }
}

// Handle Orientation Device Change

extension SecondScreenViewController {
    
    @objc func handleDeviceOrientationChange() {
        let orientation = UIDevice.current.orientation

        switch orientation {
        case .portrait, .portraitUpsideDown:
            tableView.frame = CGRect(x: view.bounds.minX, y: view.bounds.minY + 50, width: view.bounds.width, height: view.bounds.height - 40)
            topLabel.isHidden = false
            buttonSave.isHidden = false
            buttonClose.isHidden = false
            
        case .landscapeLeft, .landscapeRight:
            tableView.frame = CGRect(x: view.bounds.minX, y: view.bounds.minY, width: view.bounds.width, height: view.bounds.height - 40)
            topLabel.isHidden = true
            buttonSave.isHidden = true
            buttonClose.isHidden = true

        default:
            break
        }
    }
}
