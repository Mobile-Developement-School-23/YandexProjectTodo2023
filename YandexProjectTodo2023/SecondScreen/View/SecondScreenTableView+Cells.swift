import Foundation
import UIKit

// MARK: Setting cells for secondVC

class SecondScreenTableViewCells: UITableViewCell, UITextViewDelegate {
    
    lazy var textView = UITextView()
    
    lazy var labelPriority = UILabel()
    lazy var labelDeadLine = UILabel()
    lazy var items = ["First", "Нет", "Third"]
    lazy var stackView = UIStackView()
    lazy var deadLineDateButton = UIButton()
    lazy var segmentedControl = UISegmentedControl()
    lazy var switcher = UISwitch()
    lazy var calendar = UICalendarView()
    lazy var colorPickerLabel = UILabel()
    lazy var colorPickerView = UIView()
   
}

extension SecondScreenViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            closeVCAndDelete()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 2 {
            return 1
        } else {
            return dictTable.count
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SecondScreenTableViewCells()
        
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            
            return settingsCellFor0Section(cell)
            
        }
        
        if indexPath.section == 2 {

            return settingsCellFor2Section(cell)
            
        }
        
        if dictTable[indexPath.row] == "colorPicker" {
            
            return settingsCellForColorPicker(cell)
        }
        
        if dictTable[indexPath.row] == "priority" {
            
            return settingsCellForPriority(cell)
        }
        
        if dictTable[indexPath.row] == "deadline" {
            
            return settingsCellForDeadline(cell)
        }
        
        if dictTable[3] == "calendar" {
            
            return settingsCellForCalendar(cell)
        }
        
        return cell
    }
    
    fileprivate func settingsCellFor0Section(_ cell: SecondScreenTableViewCells) -> UITableViewCell {
        
        cell.contentView.addSubview(cell.textView)

        cell.textView.text = toDo.text
        if cell.textView.text == "" || cell.textView.text == defaultPhraseForTextView {
            cell.textView.textColor = UIColor.lightGray
            cell.textView.text = defaultPhraseForTextView
        }
        
        cell.textView.font = UIFont.systemFont(ofSize: 17)
        cell.textView.delegate = self
        cell.textView.isScrollEnabled = false
        
        cell.textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.textView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 8),
            cell.textView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8),
            cell.textView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            cell.textView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8)
        ])
        let constraintHeight = cell.textView.heightAnchor.constraint(equalToConstant: 120)
        constraintHeight.priority = .dragThatCanResizeScene
        constraintHeight.isActive = true
        
        cell.textView.text = toDo.text
        return cell
    }
    
    fileprivate func settingsCellForPriority(_ cell: SecondScreenTableViewCells) -> UITableViewCell {

        cell.segmentedControl = UISegmentedControl(items: cell.items)
        cell.contentView.addSubview(cell.segmentedControl)
        cell.contentView.addSubview(cell.labelPriority)

        cell.labelPriority.frame = CGRect()
        cell.labelPriority.text = "Важность"
        
        cell.labelPriority.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            cell.labelPriority.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 18),
            cell.labelPriority.widthAnchor.constraint(equalToConstant: 100),
            cell.labelPriority.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20),
            cell.labelPriority.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -20)
        ])
        
        cell.segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        cell.segmentedControl.frame = CGRect()
        var segmentedControlIndex = 1
        switch toDo.priority {
        case .low:
            segmentedControlIndex = 0
        case .normal:
            segmentedControlIndex = 1
        case .high:
            segmentedControlIndex = 2
        }
        cell.segmentedControl.selectedSegmentIndex = segmentedControlIndex
        cell.segmentedControl.setImage(exclamationmarkImage, forSegmentAt: 2)
        cell.segmentedControl.setImage(arrowDownImage, forSegmentAt: 0)

        cell.segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            cell.segmentedControl.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -18),
            
            cell.segmentedControl.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20),
            cell.segmentedControl.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -20)
        ])
        
        return cell
    }
    
    fileprivate func settingsCellForDeadline(_ cell: SecondScreenTableViewCells) -> UITableViewCell {

        cell.contentView.addSubview(cell.stackView)
        cell.contentView.addSubview(cell.deadLineDateButton)
        cell.stackView.addArrangedSubview(cell.labelDeadLine)
        cell.stackView.addArrangedSubview(cell.deadLineDateButton)
        
        cell.stackView.axis = .vertical
        cell.stackView.spacing = -5
        cell.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.deadLineDateButton.isHidden = !(dictTable[0] == "priority")
        
        if toDo.deadline != nil {
            cell.switcher.isOn = true
        }
     
        if toDo.deadline != nil {
            dateFormatter.dateFormat = "dd MMMM YYYY"
            cell.deadLineDateButton.setTitle(dateFormatter.string(from: toDo.deadline ?? Date()), for: .normal)
            cell.stackView.addArrangedSubview(cell.deadLineDateButton)
        } else {
            
            cell.deadLineDateButton.isHidden = true
            cell.stackView.removeArrangedSubview(cell.deadLineDateButton)
        }
        
        cell.deadLineDateButton.setTitleColor(.systemBlue, for: .normal)
        cell.deadLineDateButton.addTarget(self, action: #selector(showCalendar), for: .touchUpInside)
        
        cell.deadLineDateButton.translatesAutoresizingMaskIntoConstraints = false

        cell.labelDeadLine.text = "Сделать до"
        
        cell.labelDeadLine.translatesAutoresizingMaskIntoConstraints = false
  
        NSLayoutConstraint.activate([
            
            cell.stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 18),
            cell.stackView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])
     
        cell.switcher.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(cell.switcher)
        NSLayoutConstraint.activate([
            
            cell.switcher.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -18),
            cell.switcher.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -20),
            cell.switcher.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20)
        ])
        
        cell.switcher.addTarget(self, action: #selector(didTapOnSwitcher), for: .valueChanged)
             
        return cell
    }
    
    fileprivate func settingsCellForCalendar(_ cell: SecondScreenTableViewCells) -> UITableViewCell {

        cell.contentView.addSubview(cell.calendar)
        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        cell.calendar.selectionBehavior = selection
        
        selection.selectedDate = Calendar.current.dateComponents(in: .current, from: toDo.deadline ?? Date.now)
        
        cell.calendar.selectionBehavior = selection
        cell.calendar.delegate = self
        cell.calendar.visibleDateComponents = DateComponents(calendar: .current, year: cell.calendar.visibleDateComponents.year, month: cell.calendar.visibleDateComponents.month)
        cell.calendar.fontDesign = .rounded
        cell.calendar.availableDateRange = DateInterval(start: .now, end: .distantFuture)
        
        cell.calendar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cell.calendar.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 8),
            cell.calendar.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8),
            
            cell.calendar.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            cell.calendar.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8)
        ])

        return cell
    }
    
    fileprivate func settingsCellFor2Section(_ cell: SecondScreenTableViewCells) -> UITableViewCell {

        cell.contentView.addSubview(buttonDelete)

        buttonDelete.setTitleColor(.systemRed, for: .normal)
        buttonDelete.setTitleColor(.systemGray, for: .disabled)

        cell.contentView.addSubview(buttonDelete)
        buttonDelete.isUserInteractionEnabled = false
        buttonDelete.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        buttonDelete.setTitle("Удалить", for: .normal)
        buttonDelete.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonDelete.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 17),
            buttonDelete.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            buttonDelete.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            buttonDelete.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -17)
        ])

        return cell
    }
    fileprivate func settingsCellForColorPicker(_ cell: SecondScreenTableViewCells) -> UITableViewCell {

        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(openColorPicker))
        
        cell.contentView.addSubview(cell.colorPickerLabel)
        cell.contentView.addSubview(cell.colorPickerView)
        
        cell.colorPickerView.layer.cornerRadius = 15
        cell.colorPickerView.backgroundColor = UIColor(hex: toDo.colorHEX)
        cell.colorPickerView.addGestureRecognizer(tapGesture)
        cell.colorPickerLabel.text = "Цвет шрифта / Color picker"
        
        cell.colorPickerLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.colorPickerView.translatesAutoresizingMaskIntoConstraints = false
  
        NSLayoutConstraint.activate([
            
            cell.colorPickerLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 18),
            cell.colorPickerLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20),
            cell.colorPickerLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            
            cell.colorPickerView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            cell.colorPickerView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -18),
            cell.colorPickerView.heightAnchor.constraint(equalToConstant: 30),
            cell.colorPickerView.widthAnchor.constraint(equalToConstant: 30)
        ])
        return cell
    }
}
