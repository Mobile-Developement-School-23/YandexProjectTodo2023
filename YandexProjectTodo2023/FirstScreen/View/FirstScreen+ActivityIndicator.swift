import Foundation
import UIKit

// MARK: UI in viewForHeaderInSection

extension FirstScreenViewController {

    @objc func activeRequestsChanged() {
        
        DispatchQueue.main.async { [weak self] in

            if self?.networkingService.activeRequests ?? 0 > 0 {
                self?.refreshControl.startAnimating()
            } else {
                self?.refreshControl.stopAnimating()
            }
        }
    }
}
extension NSNotification.Name {
    static let activeRequestsChanged = NSNotification.Name("activeRequestsChanged")
}
