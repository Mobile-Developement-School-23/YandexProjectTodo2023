import UIKit
import Foundation
import FileCachePackage

enum Constants {
    static let reuseId = "MyCell"
}
class FirstScreenTableViewCell: UITableViewCell {
    
    // MARK: Images, ImageViews, StackViews, Labels

    private static var circleImage = UIImage(systemName: "circle")
    private static var circleRedImage = UIImage(systemName: "circle")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    private static var circleGreenImage = UIImage(systemName: "checkmark.circle.fill")
    private static var circleFillImage = circleGreenImage?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)

    private lazy var circleToDoImageView = UIImageView(image: FirstScreenTableViewCell.circleImage)
    private lazy var calendarToDoImageView = UIImageView(image: UIImage(systemName: "calendar"))
    private lazy var exclamationmarkImabeView = UIImageView(image: UIImage(systemName: "exclamationmark.2")?.withTintColor(.red, renderingMode: .alwaysOriginal))
    private lazy var arrowDownImageView = UIImageView(image: UIImage(systemName: "arrow.down")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal))

    private lazy var chevronToDoImageView = UIImageView(image: UIImage(systemName: "chevron.compact.right"))
        
    private lazy var descriptionLabel = UILabel()
    private lazy var deadlineLabel = UILabel()
    
    private lazy var circleStackView = UIStackView()
    private lazy var bottomStackView = UIStackView()
    private lazy var resultStackView = UIStackView()

    // MARK: Constraints

    private lazy var constraintsToDefault = [
        
        resultStackView.leadingAnchor.constraint(equalTo: circleStackView.trailingAnchor, constant: 6),
        resultStackView.centerYAnchor.constraint(equalTo: circleStackView.centerYAnchor),
        resultStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -39),
        resultStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
        resultStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -17),
        
        circleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        circleStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

        circleToDoImageView.widthAnchor.constraint(equalToConstant: 24),
        circleToDoImageView.heightAnchor.constraint(equalToConstant: 24),
        
        chevronToDoImageView.centerYAnchor.constraint(equalTo: circleToDoImageView.centerYAnchor),
        chevronToDoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        chevronToDoImageView.widthAnchor.constraint(equalToConstant: 7),
        chevronToDoImageView.heightAnchor.constraint(equalToConstant: 12),
        
        exclamationmarkImabeView.widthAnchor.constraint(equalToConstant: 18),
        arrowDownImageView.widthAnchor.constraint(equalToConstant: 18),

        calendarToDoImageView.heightAnchor.constraint(equalToConstant: 15),
        calendarToDoImageView.widthAnchor.constraint(equalToConstant: 12)
    ]
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(chevronToDoImageView)
        contentView.addSubview(resultStackView)
        contentView.addSubview(circleStackView)
   
        circleStackView.addArrangedSubview(circleToDoImageView)
        circleStackView.addArrangedSubview(exclamationmarkImabeView)
        circleStackView.addArrangedSubview(arrowDownImageView)

        bottomStackView.addArrangedSubview(calendarToDoImageView)
        bottomStackView.addArrangedSubview(deadlineLabel)
        
        resultStackView.addArrangedSubview(descriptionLabel)
        resultStackView.addArrangedSubview(bottomStackView)
    
        NSLayoutConstraint.activate(constraintsToDefault)
  
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

// MARK: Cell's constructor

extension FirstScreenTableViewCell {
    
    public func settingCell(collectionToDo: [FileCachePackage.ToDoItem], indexPath: IndexPath) -> FirstScreenTableViewCell {
     
        checkPriority(cell: self, indexPath: indexPath, collectionToDo: collectionToDo)
        
        checkIsDone(cell: self, indexPath: indexPath, collectionToDo: collectionToDo)
           
        checkDeadline(cell: self, indexPath: indexPath, collectionToDo: collectionToDo)
        
        checkForFootherButton(cell: self, indexPath: indexPath, collectionToDo: collectionToDo)
        
        descriptionLabel.text = collectionToDo[indexPath.row].text
        descriptionLabel.font = UIFont.systemFont(ofSize: 17)
        deadlineLabel.font = UIFont.systemFont(ofSize: 15)
        descriptionLabel.numberOfLines = 3
        chevronToDoImageView.tintColor = .systemGray
        circleToDoImageView.tintColor = .systemGray
        selectionStyle = .none
        
        circleStackView.axis = .horizontal
        circleStackView.spacing = 5
        circleStackView.translatesAutoresizingMaskIntoConstraints = false

        bottomStackView.spacing = 2
        bottomStackView.axis = .horizontal
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false

        resultStackView.axis = .vertical
        resultStackView.translatesAutoresizingMaskIntoConstraints = false
        
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        calendarToDoImageView.translatesAutoresizingMaskIntoConstraints = false
        chevronToDoImageView.translatesAutoresizingMaskIntoConstraints = false
        exclamationmarkImabeView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        circleToDoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        if self.traitCollection.userInterfaceStyle == .dark {
            descriptionLabel.textColor = .label
        }
   
        return self
    }
    
    private func checkPriority(cell: FirstScreenTableViewCell, indexPath: IndexPath, collectionToDo: [FileCachePackage.ToDoItem]) {
        
        if collectionToDo[indexPath.row].priority == .high {
            
            cell.circleToDoImageView.image = FirstScreenTableViewCell.circleRedImage
            cell.circleToDoImageView.backgroundColor = .systemRed.withAlphaComponent(0.15)
            cell.circleToDoImageView.layer.cornerRadius = 12.5
            cell.exclamationmarkImabeView.isHidden = false
            cell.arrowDownImageView.isHidden = true

        } else if  collectionToDo[indexPath.row].priority == .low {
            
            cell.circleToDoImageView.image = FirstScreenTableViewCell.circleImage
            cell.circleToDoImageView.backgroundColor = .clear
            cell.circleToDoImageView.layer.cornerRadius = 0
            cell.exclamationmarkImabeView.isHidden = true
            cell.arrowDownImageView.isHidden = false

        } else {
            
            cell.circleToDoImageView.image = FirstScreenTableViewCell.circleImage
            cell.circleToDoImageView.backgroundColor = .clear
            cell.circleToDoImageView.layer.cornerRadius = 0
            cell.exclamationmarkImabeView.isHidden = true
            cell.arrowDownImageView.isHidden = true
        }
    }
    
    private func checkIsDone(cell: FirstScreenTableViewCell, indexPath: IndexPath, collectionToDo: [FileCachePackage.ToDoItem]) {
        
        let str = cell.descriptionLabel.text ?? " "
        
        if collectionToDo[indexPath.row].isDone {
            cell.circleToDoImageView.image = FirstScreenTableViewCell.circleFillImage
            let attr = [NSAttributedString.Key.strikethroughStyle: 2]
            let attributeString = NSAttributedString(string: str, attributes: attr)
            cell.descriptionLabel.textColor = .systemGray
            cell.descriptionLabel.attributedText = attributeString
            
        } else {
            cell.circleToDoImageView.image = FirstScreenTableViewCell.circleImage
            if collectionToDo[indexPath.row].priority == .high {
                cell.circleToDoImageView.image = FirstScreenTableViewCell.circleRedImage
            }
            let attr = [NSAttributedString.Key.strikethroughStyle: 0]
            let attributeString = NSAttributedString(string: str, attributes: attr)
            cell.descriptionLabel.textColor = .label
            cell.descriptionLabel.attributedText = attributeString
        }
    }
    
    private func checkDeadline(cell: FirstScreenTableViewCell, indexPath: IndexPath, collectionToDo: [FileCachePackage.ToDoItem]) {
        
        if collectionToDo[indexPath.row].deadline != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM"
            cell.deadlineLabel.text = dateFormatter.string(from: collectionToDo[indexPath.row].deadline ?? Date())
            cell.deadlineLabel.textColor = .systemGray
            cell.calendarToDoImageView.tintColor = .systemGray
            cell.deadlineLabel.isHidden = false
            cell.calendarToDoImageView.isHidden = false
                        
        } else {
            cell.deadlineLabel.isHidden = true
            cell.calendarToDoImageView.isHidden = true
        }
    }
    
    private func checkForFootherButton(cell: FirstScreenTableViewCell, indexPath: IndexPath, collectionToDo: [FileCachePackage.ToDoItem]) {
        if collectionToDo[indexPath.row].creationDate == Date.distantFuture {

            cell.descriptionLabel.textColor = .systemGray
            cell.circleToDoImageView.alpha = 0
            cell.chevronToDoImageView.isHidden = true

        } else {
            cell.circleToDoImageView.alpha = 1
            cell.descriptionLabel.textColor = UIColor(hex: collectionToDo[indexPath.row].colorHEX)
            if collectionToDo[indexPath.row].isDone {
                cell.descriptionLabel.textColor = .systemGray
            }
            cell.chevronToDoImageView.isHidden = false
        }
    }
}
