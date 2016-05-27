//
//  SFFullscreenImageDetailViewController.swift
//  Databox
//
//  Created by Jan Haložan on 12/08/15.
//  Copyright (c) 2015 Jan Haložan. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore

final class SFFullscreenImageDetailViewController: UIViewController, UIScrollViewDelegate {
    let image: UIImage
    let originFrame: CGRect
    var originalView: UIImageView!
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.layer.masksToBounds = false
        view.minimumZoomScale = 1
        view.maximumZoomScale = 1.5
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "close_button"), forState: .Normal)
        
        return button
    }()
    
    var tintColor = UIColor.blackColor()
    var retainHolder: SFFullscreenImageDetailViewController!
    let animator = UIDynamicAnimator()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.userInteractionEnabled = true
        
        return view
    }()
    
    
    init (imageView view: UIImageView) {
        self.originalView = view
        var calculationView: UIView = view
        var visibleRect = view.bounds
        
        while true {
            guard let superview = calculationView.superview else {
                break
            }
            
            visibleRect = superview.convertRect(visibleRect, fromView: calculationView)
            visibleRect = CGRectIntersection(visibleRect, superview.bounds)
            calculationView = superview
        }
        
        self.originFrame = visibleRect
        self.imageView.contentMode = view.contentMode
        self.image = view.image!.copy() as! UIImage
        
        super.init(nibName: nil, bundle: nil)
        
        self.closeButton.addTarget(self, action: #selector(self.closeTapped(_:)), forControlEvents: .TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.image = aDecoder.decodeObjectForKey("image") as! UIImage
        self.originFrame = aDecoder.decodeCGRectForKey("originFrame")
        
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        let window = UIApplication.sharedApplication().keyWindow!
        let view = UIView(frame: window.bounds)
        window.addSubview(view)
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Additional setup
        self.scrollView.frame = CGRectMake(15, 60, self.view.bounds.width - 30, self.view.bounds.height - 80)
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        
        self.closeButton.frame = CGRectMake(15, 25, 20, 20)
        self.view.addSubview(self.closeButton)
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureCallback(_:)))
        self.imageView.addGestureRecognizer(recognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap(_:)))
        tapRecognizer.numberOfTapsRequired = 2
        self.imageView.addGestureRecognizer(tapRecognizer)
    }
    
    func presentInCurrentKeyWindow() {
        self.view.layer.backgroundColor = UIColor.clearColor().CGColor
        
        self.retainHolder = self
        self.originalView.hidden = true
        
        self.imageView.frame = CGRectOffset(self.originFrame, -self.scrollView.frame.origin.x, -self.scrollView.frame.origin.y)
        self.imageView.image = self.image
        self.scrollView.addSubview(imageView)
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 5, options: .CurveEaseOut, animations: {
            self.imageView.frame = self.scrollView.bounds
            self.imageView.center = CGPointMake(self.scrollView.bounds.midX, self.scrollView.bounds.midY)
            self.view.layer.backgroundColor = self.tintColor.CGColor
            self.imageView.layer.cornerRadius = 5
        }, completion: nil)
    }
    
    func doubleTap(sender: UITapGestureRecognizer) {
        let location = sender.locationInView(self.imageView)
        if self.imageView.pointInside(location, withEvent: nil) {
            if self.scrollView.zoomScale == 1 {
                self.scrollView.setZoomScale(1.5, animated: true)
            } else {
                self.scrollView.setZoomScale(1, animated: true)
            }
        }
    }
    
    func panGestureCallback(sender: UIPanGestureRecognizer) {
        if self.scrollView.zoomScale != 1 {
            return
        }
        
        let view = sender.view!
        let translation = sender.translationInView(view)
        sender.setTranslation(CGPointZero, inView: view)
        
        switch sender.state {
        case .Began:
            self.animator.removeAllBehaviors()
        case .Changed:
            var center = view.center
            center.x += translation.x
            center.y += translation.y
            view.center = center
            
            let viewCenterDistanceFromEdge = self.view.center.y * self.view.center.y + self.view.center.x * self.view.center.x
            let diffY = self.view.center.y - view.center.y
            let diffX = self.view.center.x - view.center.x
            let imageCenterDistanceFromCenter = diffY * diffY + diffX * diffX
            let percent = 1 - imageCenterDistanceFromCenter / (viewCenterDistanceFromEdge * 0.25)
            self.view.layer.backgroundColor = self.tintColor.colorWithAlphaComponent(percent).CGColor
            self.closeButton.alpha = percent * 0.5
        case .Ended:
            let originalBoundsSize = self.originFrame.size
            let sizingBounds = CGSizeMake(view.bounds.size.width - originalBoundsSize.width, view.bounds.size.height - originalBoundsSize.height)
            let originalCenter = CGPointMake(CGRectGetMidX(self.originFrame) - self.scrollView.frame.origin.x, CGRectGetMidY(self.originFrame) - self.scrollView.frame.origin.y)
            let dropCenter = self.view.convertPoint(CGPointMake(CGRectGetMidX(view.frame), CGRectGetMidY(view.frame)), fromView: self.scrollView)
            let diffX = originalCenter.x - dropCenter.x, diffY = originalCenter.y - dropCenter.y
            let totalDistance = diffX * diffX + diffY * diffY
            
            if totalDistance > 12600 {
                self.view.userInteractionEnabled = false
                
                weak var instance = view
                weak var weakSelf = self
                let snapBehaviour = UISnapBehavior(item: view, snapToPoint: originalCenter)
                snapBehaviour.damping = 0.75
                snapBehaviour.action = {
                    let movingCenter = instance!.center
                    let diffX = originalCenter.x - movingCenter.x, diffY = originalCenter.y - movingCenter.y
                    let toTravelDistance = diffX * diffX + diffY * diffY
                    let progress = toTravelDistance / totalDistance
                    var frame = instance!.frame
                    frame.size.width = originalBoundsSize.width + sizingBounds.width * progress
                    frame.size.height = originalBoundsSize.height + sizingBounds.height * progress
                    instance!.frame = frame
                    instance!.center = movingCenter
                    
                    if progress == 0.0 {
                        dispatch_async(dispatch_get_main_queue()) {
                            weakSelf!.animator.removeAllBehaviors()
                            weakSelf!.cleanUpAndDismiss()
                        }
                    }
                }
                
                self.animator.addBehavior(snapBehaviour)
                
                let velocity = sender.velocityInView(view)
                let pushBehaviour = UIPushBehavior(items: [view], mode: .Instantaneous)
                pushBehaviour.pushDirection = CGVectorMake(velocity.x * 0.2, velocity.y * 0.2)
                
                self.animator.addBehavior(pushBehaviour)
                
                UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseInOut, animations: {
                    self.view.layer.backgroundColor = UIColor.clearColor().CGColor
                    self.imageView.layer.cornerRadius = self.originalView.layer.cornerRadius
                    self.closeButton.alpha = 0
                }, completion: nil)
            } else {
                let behaviour = UISnapBehavior(item: self.imageView, snapToPoint: CGPointMake(CGRectGetMidX(self.scrollView.bounds), CGRectGetMidY(self.scrollView.bounds)))
                self.animator.addBehavior(behaviour)
                
                UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseInOut, animations: {
                    self.view.layer.backgroundColor = self.tintColor.CGColor
                    self.closeButton.alpha = 1
                    
                }, completion: nil)
            }
        default:
            break
        }
    }
    
    func cleanUpAndDismiss() {
        self.originalView.hidden = false
        self.imageView.removeFromSuperview()
        self.closeButton.removeFromSuperview()
        self.view.removeFromSuperview()
        self.retainHolder = nil
    }
    
    func closeTapped(sender: UIButton) {
        let originalCenter = CGPointMake(CGRectGetMidX(self.originFrame) - self.scrollView.frame.origin.x, CGRectGetMidY(self.originFrame) - self.scrollView.frame.origin.y)
        
        UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations: {
            self.imageView.frame = self.originFrame
            self.imageView.center = originalCenter
            self.view.layer.backgroundColor = UIColor.clearColor().CGColor
            self.closeButton.alpha = 0
        }, completion: { _ in
                self.animator.removeAllBehaviors()
                self.cleanUpAndDismiss()
        })
    }
    
    // MARK: UIScrollViewDelegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.closeButton.hidden != (self.scrollView.zoomScale > 1) {
            self.closeButton.hidden = !self.closeButton.hidden
        }
    }
    
    // MARK: NSCoding
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.image, forKey: "image")
        aCoder.encodeCGRect(self.originFrame, forKey: "originFrame")
        
        super.encodeWithCoder(aCoder)
    }
}
