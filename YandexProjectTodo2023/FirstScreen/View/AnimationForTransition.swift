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
            guard let toView = transitionContext.view(forKey: .to) else {return}
            containerView.addSubview(toView)
            toView.frame = originFrame
            toView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            toView.layoutIfNeeded()
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.8,
                           options: .curveEaseInOut,
                           animations: {
                                toView.frame = containerView.bounds
                                toView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                           }) { _ in
                                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                           }

        } else {
            guard let fromView = transitionContext.view(forKey: .from) else {return}
            fromView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                           delay: 0,
                           usingSpringWithDamping: 0.9,
                           initialSpringVelocity: 0.8,
                           options: .curveEaseIn,
                           animations: {
                                fromView.frame = self.originFrame
                                fromView.alpha = 0.1
                                fromView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                           }) { _ in
                                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                                fromView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                           }

        }
        
    }
}

