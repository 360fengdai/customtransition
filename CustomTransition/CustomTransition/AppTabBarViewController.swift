//
//  AppTabBarViewController.swift
//  SwiftClient
//
//  Created by liuchong on 16/11/10.
//  Copyright © 2016年 liuchong. All rights reserved.
//


import UIKit

class AppTabBarViewController: UITabBarController,UITabBarControllerDelegate {
    let xxx:String = "1123"
    
    var panGestureRecongizer:UIPanGestureRecognizer? = nil

    let AAPLSlideTabBarControllerDelegateAssociationKey:String = "AAPLSlideTabBarControllerDelegateAssociation"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.delegate = self
        
        panGestureRecongizer = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognizerDidPan(sender:)))
        self.view.addGestureRecognizer(panGestureRecongizer!)
        
    }

//    ---------------------------------------
    
//    手势
    @IBAction func panGestureRecognizerDidPan(sender:UIPanGestureRecognizer){
        print("panGestureRecognizerDidPan1")
        //transitionCoordinator
        if ((self.transitionCoordinator) != nil) {return};
        //UIGestureRecognizerStateBegan
        //
        if (sender.state ==  .began || sender.state == .changed){
            
            self.beginInteractiveTransitionIfPossible(sender: sender)
        }
    }
    
    func beginInteractiveTransitionIfPossible(sender:UIPanGestureRecognizer) {
        print("beginInteractiveTransitionIfPossible1")
        let translation:CGPoint = sender.translation(in: self.view)
        if translation.x > 0 && self.selectedIndex > 0 {
            self.selectedIndex -= 1
            
        }else if(translation.x < 0 && self.selectedIndex + 1 < (self.viewControllers?.count)!){
            self.selectedIndex += 1
            
        }else{
            if (!translation.equalTo(CGPoint.zero)) {
                // There is not a view controller to transition to, force the
                // gesture recognizer to fail.
                
                sender.isEnabled = false;
                sender.isEnabled = true;
            }
        }
        //UIViewControllerTransitionCoordinatorContext
        self.transitionCoordinator?.animate(alongsideTransition: nil, completion: { (context:AnyObject) in
            
            //            let context1 = context as! UIViewControllerTransitionCoordinatorContext
            
            let res = context.isCancelled
            
            if (res! && sender.state == .changed){
                self.beginInteractiveTransitionIfPossible(sender: sender)
            }
            
        })
    }
    
    
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("animationControllerForTransitionFrom1")

        let viewControllers = tabBarController.viewControllers;
        let indexTo = viewControllers!.index(of: toVC)!
        let indexFrom = viewControllers!.index(of: fromVC)!
        
//        let a = view.reactive.
        
        return AAPLSlideTransitionAnimator(targetEdge: (indexTo > indexFrom) ? UIRectEdge.left : UIRectEdge.right)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        print("interactionControllerFor1")
        if (self.panGestureRecongizer?.state == .began || self.panGestureRecongizer?.state == .changed){
            return AAPLSlideTransitionInteractionController.init(gestureRecognizer: self.panGestureRecongizer!)
        }else{
            return nil
        }
    }
    
    
//    ---------------------------------------
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
