import UIKit

class SecondScreenViewController: UIViewController, UITextViewDelegate {

    // MARK: complitionHandler & data
    
    public var dataCompletionHandler: ((ToDoItem) -> Void)?
    lazy var toDo = ToDoItem(text: "", priority: .normal)
    private lazy var items = ["First", "Нет", "Third"]
    lazy var exclamationmarkImage = UIImage(systemName: "exclamationmark.2")?.withTintColor(.red, renderingMode: .alwaysOriginal)
    lazy var arrowDownImage = UIImage(systemName: "arrow.down")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    lazy var dictTable = [0: "priority", 1: "colorPicker", 2: "deadline"]
    
    var tableView: UITableView = .init(frame: CGRect(), style: .insetGrouped)
    
    lazy var tapGestureEndEditing = UITapGestureRecognizer(target: self, action: #selector(didTapView))
    
    lazy var topLabel = UILabel()
    
    lazy var buttonClose = UIButton()
    lazy var buttonSave = UIButton()
    lazy var buttonDelete = UIButton()
    
    var dateFormatter = DateFormatter()
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    let defaultPhraseForTextView = "Что надо сделать?"
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        prepareUIforVC()
        settingTopLabel()
        settingSaveButton()
        settingCloseButton()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableViewFrame()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
