import UIKit
import FileCachePackage

class ColorPickerViewController: UIViewController {
    
    var colorPickerView = ColorPickerView()
    public var dataCompletionHandler: ((ToDoItem) -> Void)?
    lazy var todo = ToDoItem(text: "", priority: .normal)
    lazy var colorView = UIView()
    lazy var backgroundView = UIView()
    lazy var backgroundSecondView = UIView()
    
    lazy var colorBrightSlider = UISlider()
    lazy var colorButton = UIButton()
    lazy var setColorButton = UIButton()
    lazy var resetColorButton = UIButton()
    lazy var buttonClose = UIButton()
    
    lazy var brightLabel = UILabel()
    lazy var topLabel = UILabel()
    lazy var scrollView = UIScrollView()
    lazy var containerView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // recieve color from palette & set it in todo
        colorPickerView.onColorDidChange = { [weak self] color in
            DispatchQueue.main.async {
                
                self?.todo.colorHEX = color.hexString ?? "000000FF"
                self?.colorBrightSlider.value = Float(color.alpha)
                self?.colorView.backgroundColor = color
                self?.colorButton.setTitle(self?.todo.colorHEX, for: .normal)
                self?.setColorButton.setTitleColor(color, for: .normal)
                
            }
        }
        
        currentColor()
        settingUI()
        settingCloseButton()
        settingTopLabel()
    }
}
