//  GameViewController.swift
//  Unseal
//
//  Created by synaptics on 7/12/16.
//  Copyright (c) 2016 Amino. All rights reserved.
//

import UIKit
import SpriteKit

let afterGuessTimeout: NSTimeInterval = 2 // seconds

class GameViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var handler : DrawingHandler!
    var drawView : DrawView!
    
    var scene : GameScene!
    
    var goToNextTimer: NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()

        handler = DrawingHandler(target: self, action: "shape:")
        view.addGestureRecognizer(handler)
        handler.delegate = self
        
        drawView = DrawView(frame: CGRectMake(0, 0, 320, 568))
        drawView.backgroundColor = UIColor.clearColor()
        view.addSubview(drawView)
        
        scene = GameScene(fileNamed:"GameScene")
        
        if  (scene != nil){
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene!.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
        
        goToNextTimer?.invalidate()
        
        drawView.clear()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if scene.gameOver {
            return false
        }
        let pos = touch.locationInView(drawView)
        return !(pos.y >= 542)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    func shape(c: DrawingHandler) {
        
        if c.state == .Began {
            drawView.clear()
            goToNextTimer?.invalidate()
            drawView.ended = false
        }
        if c.state == .Changed {
            drawView.updatePath(c.path)
        }
        if c.state == .Ended || c.state == .Failed || c.state == .Cancelled {
            drawView.updateFit(c.isShape)
            goToNextTimer = NSTimer.scheduledTimerWithTimeInterval(afterGuessTimeout, target: self, selector: "timerFired:", userInfo: nil, repeats: false)
            drawView.ended = true
            if c.isShape{
                
                scene.decrementGesture()
                scene.hideImage("\(c.currentShape)")
                handler.randomize()
                scene.showImage("\(c.currentShape)")
                if scene.remainingGestures <= 0{
                    goToNextTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "resetGesture:",       userInfo: nil, repeats:  false)
                }
                
            }
        }
    }
    func timerFired(timer: NSTimer) {
        drawView.clear()
    }

    func resetGesture(timer: NSTimer){
        scene.resetGestures()
    }
}
