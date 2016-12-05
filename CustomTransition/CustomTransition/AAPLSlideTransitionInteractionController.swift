//
//  AAPLSlideTransitionInteractionController.swift
//  SwiftClient
//
//  Created by vvsvip on 2016/11/24.
//  Copyright © 2016年 liuchong. All rights reserved.
//

import UIKit

class AAPLSlideTransitionInteractionController: UIPercentDrivenInteractiveTransition {
    
    var gestureRecognizer = UIPanGestureRecognizer()
    var initialLocationInContainerView = CGPoint()
    var initialTranslationInContainerView = CGPoint()

    var transitionContext:AnyObject? = nil
    
    
    init(gestureRecognizer:UIPanGestureRecognizer) {
        super.init()
        print("gestureRecognizer3")
        self.gestureRecognizer = gestureRecognizer
        self.gestureRecognizer.addTarget(self, action: #selector(self.gestureRecognizeDidUpdate(gestureRecognizer:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        print("startInteractiveTransition3")
        self.transitionContext = transitionContext
        super.startInteractiveTransition(transitionContext)
    }
    
    
    
    func percentForGesture(gesture: UIScreenEdgePanGestureRecognizer) -> CGFloat {
        print("percentForGesture3")
        
        
//      Answer/Suggestions from StackOverFlow  ▼▼▼
        guard let transitionContainerView = self.transitionContext?.containerView else {
            print("the containerView of transitionContext is nil. Find out why.")
            return 0.0
        }
        
//      myself ▼▼▼
        /*guard transitionContainerView != nil else {
            print("-----------逮住你了！！！")
            return 0.0
        }*/
        
        //崩溃
        //fatal error: unexpectedly found nil while unwrapping an Optional value
        
        let translationInContainerView = gesture.translation(in: transitionContainerView!)
        
        if ( translationInContainerView.x > 0 && self.initialTranslationInContainerView.x < 0 ) && (translationInContainerView.x < 0 && self.initialTranslationInContainerView.x > 0) {
            return -1
        }
       
        return fabs(translationInContainerView.x/(transitionContainerView!.bounds.width))
        
        
        
    }
    
    @IBAction func gestureRecognizeDidUpdate(gestureRecognizer:UIScreenEdgePanGestureRecognizer){
        print("gestureRecognizeDidUpdate3")
        switch gestureRecognizer.state {
            
        case .began:
            print(".began --- break")

            break
        case .changed:
            
            if self.percentForGesture(gesture: gestureRecognizer) < 0{
                self.cancel()
                print(".change ---- < 0")
                self.gestureRecognizer.removeTarget(self, action:#selector(AAPLSlideTransitionInteractionController.gestureRecognizeDidUpdate(gestureRecognizer:)))
            }else{
                print(".change ---- else")
                self.update(self.percentForGesture(gesture: gestureRecognizer))
            }
        
        case .ended:
            
            if self.percentForGesture(gesture: gestureRecognizer) >= 0.4 {
                print(".end ---- > = 0.4")
                self.finish()
            }else{
                print(".end ---- else")
                self.cancel()
            }
        default:
            print(".default --- cancel")
            self.cancel()
        }
    }
    
    
}
