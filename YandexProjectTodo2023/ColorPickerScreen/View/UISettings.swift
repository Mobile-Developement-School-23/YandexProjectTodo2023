import Foundation
import UIKit

// MARK: UI Setting color picker's

extension ColorPickerViewController {
    
     func settingUI() {
         
         view.backgroundColor = .systemGroupedBackground
         scrollView.backgroundColor = .systemGroupedBackground
         scrollView.alwaysBounceHorizontal = false
         scrollView.showsHorizontalScrollIndicator = false
         
         view.addSubview(scrollView)
         scrollView.addSubview(containerView)
         containerView.addSubview(backgroundSecondView)
         containerView.addSubview(backgroundView)
         containerView.addSubview(colorView)
         containerView.addSubview(colorBrightSlider)
         containerView.addSubview(colorButton)
         containerView.addSubview(colorPickerView)
         containerView.addSubview(brightLabel)
         containerView.addSubview(setColorButton)
         containerView.addSubview(resetColorButton)
         view.addSubview(topLabel)
         view.addSubview(buttonClose)
        
        let customConfig = UIImage.SymbolConfiguration(pointSize: 26)
        let imageReset = UIImage(systemName: "arrow.counterclockwise", withConfiguration: customConfig)
        
        resetColorButton.setImage(imageReset, for: .normal)
        resetColorButton.tintColor = .label
        resetColorButton.addTarget(self, action: #selector(setDefaultColor), for: .touchUpInside)
        
        setColorButton.addTarget(self, action: #selector(setColor), for: .touchUpInside)
        setColorButton.setTitle("Установить", for: .normal)
        setColorButton.setTitleColor(UIColor(hex: todo.colorHEX), for: .normal)
        setColorButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        setColorButton.backgroundColor = .secondarySystemGroupedBackground
        setColorButton.layer.cornerRadius = 10
        
        colorButton.setTitleColor(.label, for: .normal)
        colorButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        
        brightLabel.text = "Яркость:"
        brightLabel.textColor = .label
        brightLabel.font = UIFont.systemFont(ofSize: 22)
        
        colorView.layer.cornerRadius = 10
        colorView.layer.borderWidth = 2
        colorView.layer.borderColor = UIColor.label.cgColor
            
        colorBrightSlider.addTarget(self, action: #selector(changeBright), for: .valueChanged)

        colorPickerView.layer.cornerRadius = 15
        backgroundView.backgroundColor = .secondarySystemGroupedBackground
        backgroundView.layer.cornerRadius = 15
        backgroundSecondView.layer.cornerRadius = 15
        backgroundSecondView.backgroundColor = .secondarySystemGroupedBackground

        constraintsForAll()
        
    }
}

// MARK: Action for Tap

extension ColorPickerViewController {
    
    @objc func setColor() {
        
        if let complition = dataCompletionHandler {
            complition(todo)
        }
        dismiss(animated: true)
    }
     func currentColor() {
        
        let color: UIColor = UIColor(hex: todo.colorHEX)
        colorBrightSlider.setValue(Float(color.alpha), animated: true)
        colorView.backgroundColor = color
        colorButton.setTitle(color.hexString, for: .normal)
        setColorButton.setTitleColor(color, for: .normal)
        
    }
    
    // reset picker color to black/white
    @objc func setDefaultColor() {
        
        DispatchQueue.main.async {
            let color: UIColor = .label
            self.colorBrightSlider.value = 1
            self.colorView.backgroundColor = color
            self.colorButton.setTitle(color.hexString, for: .normal)
            self.setColorButton.setTitleColor(color, for: .normal)
            self.todo.colorHEX = color.hexString ?? "000000FF"
        }
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true)
    }
    
    // brightness slider
    @objc func changeBright(_ sender: UISlider) {
        
        let color = colorView.backgroundColor?.withAlphaComponent(CGFloat(sender.value))
        colorView.backgroundColor = color
        colorButton.setTitle(color?.hexString, for: .normal)
        setColorButton.setTitleColor(color, for: .normal)
        todo.colorHEX = color?.hexString ?? "000000FF"
    }
    // Copy HEX color from tap on number & show Alert
    @objc func colorButtonTapped() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = colorButton.titleLabel?.text
        
        let alertController = UIAlertController(title: nil, message: "Скопировано", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        let deadline = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
}
