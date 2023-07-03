import Foundation
import UIKit


extension FirstScreenViewController {
    
    func settingAcitvityIndicator() {
        
//        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        
        navigationController?.navigationBar.addSubview(activityIndicator)
        activityIndicator.widthAnchor.constraint(equalToConstant: 100).isActive = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            activityIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -26),


            
        ])
    }
}
