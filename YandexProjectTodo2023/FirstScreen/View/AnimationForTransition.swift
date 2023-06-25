import Foundation
import UIKit

class MyAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let isPresenting: Bool
    let originFrame: CGRect
    
    init(isPresenting: Bool, originFrame: CGRect) {
        self.isPresenting = isPresenting
        self.originFrame = originFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView


        
        if isPresenting {
            let toView = transitionContext.view(forKey: .to)!
            containerView.addSubview(toView)
            toView.frame = originFrame
            toView.alpha = 0.7
            toView.layoutIfNeeded()
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView.frame = containerView.bounds
                toView.alpha = 1
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else {
            let fromView = transitionContext.view(forKey: .from)!
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView.frame = self.originFrame
                fromView.alpha = 0.5
                fromView.layoutIfNeeded()
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
        
    }
}

