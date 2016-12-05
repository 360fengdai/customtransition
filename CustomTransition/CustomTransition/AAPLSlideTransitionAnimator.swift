//
//  AAPLSlideTransitionAnimator.swift
//  SwiftClient
//
//  Created by vvsvip on 2016/11/24.
//  Copyright © 2016年 liuchong. All rights reserved.
//

import UIKit

class AAPLSlideTransitionAnimator: NSObject,UIViewControllerAnimatedTransitioning {

    var targetEdge:UIRectEdge = UIRectEdge()
    
    init(targetEdge:UIRectEdge) {
        print("targetEdge2")
        super.init()
        
        self.targetEdge = targetEdge
    }
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        print("animateTransition2")
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        let containerView = transitionContext.containerView

        var fromView:UIView? = nil
        var toView:UIView? = nil
        
        if transitionContext.responds(to: #selector(UIViewControllerTransitionCoordinatorContext.view(forKey:))){
            fromView = transitionContext.view(forKey: .from)!
            toView = transitionContext.view(forKey: .to)!
            
        }else{
            fromView = (fromViewController?.view)!
            toView = (toViewController?.view)!
        }
        
        let fromFrame = transitionContext.initialFrame(for: fromViewController!)
        let toFrame = transitionContext.finalFrame(for: toViewController!)
        
//        let offset:CGVector = CGVector(dx: -1, dy: 0)
        
        var offset:CGVector = CGVector()
        
        if self.targetEdge == .left {
            offset = CGVector(dx: -1, dy: 0)
        }else if(self.targetEdge == .right){
            offset = CGVector(dx: 1, dy: 0)
        }else{
    
        }
        
        fromView?.frame = fromFrame;
        
        toView?.frame = toFrame.offsetBy(dx: toFrame.size.width * offset.dx * -1,
                                        dy: toFrame.size.height * offset.dy * -1)
        containerView.addSubview(toView!)
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        print("transitionDuration:\(transitionDuration)")
        
        UIView.animate(withDuration: transitionDuration, animations: {
            
            fromView?.frame = fromFrame.offsetBy(dx: fromFrame.size.width * offset.dx,
                                                dy: fromFrame.size.height * offset.dy);
            toView?.frame = toFrame;
        }, completion: {
            isFinish in
            
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        print("transitionDuration2")
        return 0.35
    }
}
