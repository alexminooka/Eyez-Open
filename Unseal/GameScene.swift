//
//  GameScene.swift
//  Unseal
//
//  Created by synaptics on 7/12/16.
//  Copyright (c) 2016 Amino. All rights reserved.
//

import SpriteKit
import SceneKit

class GameScene: SKScene {
    
    var score : SKLabelNode!
    var gesture : SKLabelNode!
    
    var currentScore = 0
    
    //spell buttons w:60 h:24
    var spell1 : MSButtonNode!
    var spell2 : MSButtonNode!
    var spell3 : MSButtonNode!
    
    var gestureNum = 1
    var remainingGestures = 1
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        score = childNodeWithName("score") as! SKLabelNode
        gesture = childNodeWithName("gesture") as! SKLabelNode
        
        //spells
        spell1 = childNodeWithName("spell1") as! MSButtonNode
        spell1.selectedHandler = {
            if self.gestureNum == 1 {return}
            print("1")
            self.gestureNum = 1
            self.remainingGestures = 1
            self.gesture.text = "\(self.remainingGestures)"
        }
        spell2 = childNodeWithName("spell2") as! MSButtonNode
        spell2.selectedHandler = {
            if self.gestureNum == 2 {return}
            print("2")
            self.gestureNum = 2
            self.remainingGestures = 2
            self.gesture.text = "\(self.remainingGestures)"
        }
        spell3 = childNodeWithName("spell3") as! MSButtonNode
        spell3.selectedHandler = {
            if self.gestureNum == 3 {return}
            print("3")
            self.gestureNum = 3
            self.remainingGestures = 3
            self.gesture.text = "\(self.remainingGestures)"
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
    }
    
    func decrementGesture(){
        remainingGestures -= 1
        if remainingGestures == 0{
            //show spell here
            print("cast spell")
            remainingGestures = gestureNum
        }
        gesture.text = "\(remainingGestures)"
    }
    
    func incramentScore(){
        currentScore += 1
        score.text = "\(currentScore)"
    }
    
    
    func hideImage(shape : String){
        childNodeWithName(shape)?.zPosition = -2
    }
    
    func showImage(shape: String){
        childNodeWithName(shape)?.zPosition = 2
    }
   
    override func update(currentTime: CFTimeInterval) {
       
    }
}
