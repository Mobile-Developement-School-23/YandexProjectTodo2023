import Foundation
import UIKit

// MARK: Transition Animation

extension SecondScreenViewController: UIViewControllerTransitioningDelegate {
    
   convenience init(cellFrame: CGRect) {
        self.init(nibName: nil, bundle: nil)
        self.cellFrame = cellFrame
        self.modalPresentationStyle = .formSheet
        self.transitioningDelegate = self
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyAnimationController(isPresenting: true, originFrame: cellFrame ?? CGRect())
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyAnimationController(isPresenting: false, originFrame: cellFrame ?? CGRect())
    }
}


