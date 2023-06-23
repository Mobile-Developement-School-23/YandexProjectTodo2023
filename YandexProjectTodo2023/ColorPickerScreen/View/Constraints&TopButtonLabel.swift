import Foundation
import UIKit

// MARK: Constraints & Top Button+Label

extension ColorPickerViewController {
    
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
    
     func settingTopLabel() {
        topLabel.text = "Color Picker"
        topLabel.font = UIFont.boldSystemFont(ofSize: 19)
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topLabel.centerYAnchor.constraint(equalTo: buttonClose.centerYAnchor)
        ])
    }
}

extension ColorPickerViewController {
    
     func constraintsForAll() {
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        colorPickerView.translatesAutoresizingMaskIntoConstraints = false
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorBrightSlider.translatesAutoresizingMaskIntoConstraints = false
        resetColorButton.translatesAutoresizingMaskIntoConstraints = false
        brightLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundSecondView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        setColorButton.translatesAutoresizingMaskIntoConstraints = false
        colorButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            colorView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 86),
            colorView.heightAnchor.constraint(equalToConstant: 100),
            colorView.widthAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            colorButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            colorButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 6),
            colorButton.heightAnchor.constraint(equalToConstant: 26),
            colorButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            colorBrightSlider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            colorBrightSlider.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 6),
            colorBrightSlider.heightAnchor.constraint(equalToConstant: 26),
            colorBrightSlider.widthAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            brightLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            brightLabel.bottomAnchor.constraint(equalTo: colorButton.topAnchor, constant: -6),
            brightLabel.heightAnchor.constraint(equalToConstant: 26),
            brightLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            resetColorButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            resetColorButton.topAnchor.constraint(equalTo: colorView.topAnchor),
            resetColorButton.heightAnchor.constraint(equalToConstant: 55),
            resetColorButton.widthAnchor.constraint(equalToConstant: 55)
        ])
        NSLayoutConstraint.activate([
            backgroundSecondView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 26),
            backgroundSecondView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            backgroundSecondView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: -26),
            backgroundSecondView.heightAnchor.constraint(equalToConstant: 180)
        ])
        NSLayoutConstraint.activate([
            colorPickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            colorPickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            colorPickerView.heightAnchor.constraint(equalToConstant: 300),
            colorPickerView.topAnchor.constraint(equalTo: backgroundSecondView.bottomAnchor, constant: 60)
        ])
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 26),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            backgroundView.topAnchor.constraint(equalTo: colorPickerView.topAnchor, constant: -20),
            backgroundView.heightAnchor.constraint(equalTo: colorPickerView.heightAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            setColorButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 26),
            setColorButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            setColorButton.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 40),
            setColorButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            setColorButton.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
}
