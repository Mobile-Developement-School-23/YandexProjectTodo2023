import UIKit

// MARK: Drag & Drop "Y" button Animation (зажми и потащи кнопку)

extension FirstScreenViewController {

    @objc func dragButton(_ sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: view)

        if sender.state == .began {
            
            buttonCenter = button.center
            emitter.birthRate = 100
            
        } else if sender.state == .changed {
            
            button.center = location
            emitter.emitterPosition = location
        } else if sender.state == .ended || sender.state == .cancelled {
            UIView.animate(withDuration: 0.3) {
                self.button.center = self.buttonCenter
                self.emitter.emitterPosition = self.buttonCenter
                self.emitter.birthRate = 0
            }
            buttonTouchUpOutside(button)
        }
    }
    
    func createEmitter() -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .circle
        emitter.emitterPosition = button.center
        emitter.emitterSize = button.bounds.size
        
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "yandex")?.cgImage
        cell.birthRate = 0.2
        cell.lifetime = 4
        cell.velocity = 10
        cell.velocityRange = 5
        cell.emissionRange = .pi
        cell.yAcceleration = 150
        cell.scale = 0.1
        
        emitter.emitterCells = [cell]
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        emitter.birthRate = 0
                    }
        
        view.layer.addSublayer(emitter)
        
        return emitter
    }
    
}

// MARK: Up/Down Animation  "Y" button

extension UIViewController {
    
    private func pressButton (button: UIButton) {
        UIView.animate(withDuration: 0.07,
                       animations: {
            button.transform = CGAffineTransform(scaleX: 0.98, y: 0.95)
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.07) {
                button.transform = CGAffineTransform.identity
                
            }
        })
    }
}

extension UIView {
    
    func animateButtonDown() {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: nil)
    }
    
    func animateButtonUp() {
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

extension UIViewController {
    
    @objc func buttonTouchDown(_ sender: UIButton) {
        
        // taptic engine при нажатии Y кнопки
        
            let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedbackGenerator.prepare()
            impactFeedbackGenerator.impactOccurred()
        
            sender.animateButtonDown()
    
    }
    
    @objc func buttonTouchUpOutside(_ sender: UIButton) {
        
        sender.animateButtonUp()
    }
    @objc func buttonTouchUpInside(_ sender: UIButton) {
        
        sender.animateButtonUp()
        
    }
    
}
