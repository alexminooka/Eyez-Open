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
    
    //labels
    var score : SKLabelNode!
    var gesture : SKLabelNode!
    var health : SKLabelNode!
    
    //current score
    var currentScore = 0
    
    //reference and information of monsters in 2 arrays
    var entities = [SKReferenceNode]()
    var monsters = [Monster]()
    
    
    //restart button
    var restart : MSButtonNode!
    
    //spell buttons w:60 h:24
    var spell1 : MSButtonNode!
    var spell2 : MSButtonNode!
    var spell3 : MSButtonNode!
    var spell4 : MSButtonNode!
    var spell5 : MSButtonNode!
    
    //total gestures in current spell
    var gestureNum = 1
    
    //remaing gesture to draw until cast
    var remainingGestures = 1
    
    //damage of spell
    var damage : Int = 1
    
    //player hp
    var playerHealth : Int = 3
    var gameOver = false
    
    //delta
    
    let fixedDelta : CFTimeInterval = 1.0/60.0
    var spawnTimer : CFTimeInterval = 0
    
    
    //reference path for mobs
    let flowerReference = NSBundle.mainBundle().pathForResource( "Flower", ofType: "sks")
    let sproutReference = NSBundle.mainBundle().pathForResource( "Sprout", ofType: "sks")
    let mushroomReference = NSBundle.mainBundle().pathForResource( "Mushroom", ofType: "sks")
    let froguanaReference = NSBundle.mainBundle().pathForResource( "Froguana", ofType: "sks")
    
    //dissappear
    let disappear = SKAction.fadeAlphaTo(1.0, duration: 0.1)
    


    //more or less init stuff
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        score = childNodeWithName("score") as! SKLabelNode
        gesture = childNodeWithName("gesture") as! SKLabelNode
        health = childNodeWithName("health") as! SKLabelNode
        
        //spells
        spell1 = childNodeWithName("spell1") as! MSButtonNode
        spell1.selectedHandler = {
            if self.gestureNum == 1 {return}
            
            self.buttonDown()
            self.gestureNum = 1
            self.remainingGestures = 1
            self.gesture.text = "\(self.remainingGestures)"
            self.buttonUp()
            
            self.damage = 1
            
        }
        spell2 = childNodeWithName("spell2") as! MSButtonNode
        spell2.selectedHandler = {
            if self.gestureNum == 2 {return}
            
            self.buttonDown()
            self.gestureNum = 2
            self.remainingGestures = 2
            self.gesture.text = "\(self.remainingGestures)"
            self.buttonUp()
            
            self.damage = 3
            
        }
        spell3 = childNodeWithName("spell3") as! MSButtonNode
        spell3.selectedHandler = {
            if self.gestureNum == 3 {return}
            self.buttonDown()

            self.gestureNum = 3
            self.remainingGestures = 3
            self.gesture.text = "\(self.remainingGestures)"
            self.buttonUp()
            
            self.damage = 4
        }
        
        spell4 = childNodeWithName("spell4") as! MSButtonNode
        spell4.selectedHandler = {
            if self.gestureNum == 4 {return}
            self.buttonDown()
            
            self.gestureNum = 4
            self.remainingGestures = 4
            self.gesture.text = "\(self.remainingGestures)"
            self.buttonUp()
            
            self.damage = 7
        }
        
        spell5 = childNodeWithName("spell5") as! MSButtonNode
        spell5.selectedHandler = {
            if self.gestureNum == 5 {return}
            self.buttonDown()
            
            self.gestureNum = 5
            self.remainingGestures = 5
            self.gesture.text = "\(self.remainingGestures)"
            self.buttonUp()
            
            self.damage = 9
        }
        restart = childNodeWithName("restart") as! MSButtonNode
        restart.selectedHandler = {
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill
            
            /* Restart game scene */
            skView.presentScene(scene)
        }
        restart.state = .Hidden
        randomizeSpawn()
        
    }
    
    //tab up
    func buttonDown(){
        let button = self.childNodeWithName("spell\(self.gestureNum)")?.position
        self.childNodeWithName("spell\(self.gestureNum)")?.position.y = button!.y - 5
    }
    
    //tabs down
    func buttonUp(){
        let button = self.childNodeWithName("spell\(self.gestureNum)")?.position
        self.childNodeWithName("spell\(self.gestureNum)")?.position.y = button!.y + 5
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
    }
    
    //reduce remaining gestures, if 0 gestures cast a spell and deal damage
    func decrementGesture(){
        remainingGestures -= 1
        if remainingGestures == 0{
            if monsters.count > 0 && entities.count > 0{
                spell()
                dealDamage()
            }
        }
        gesture.text = "\(remainingGestures)"
    }
    
    //displays a spell
    func spell(){
        let spellReference = NSBundle.mainBundle().pathForResource( "Spell\(gestureNum)", ofType: "sks")
        let spell = SKReferenceNode(URL: NSURL (fileURLWithPath: spellReference!))
        
        let entity = entities[0]
        
        spell.position = CGPoint(x: entity.position.x - 35, y: entity.position.y - 35 )
        spell.zPosition = 4
        
        spell.xScale = entity.xScale
        spell.yScale = entity.yScale
        addChild(spell)
        let action = SKAction(named: "Spell\(gestureNum)")
        spell.runAction(action!){
            self.childNodeWithName("spell")?.removeFromParent()
        }
    }
    
    func playerDamage(){
        playerHealth -= 1
        health.text = "\(playerHealth)"
    }
    
    //deals damage to the monsters
    func dealDamage(){
        monsters[0].decrementHealth(damage)
    }
    
    //resets the gesture count
    func resetGestures(){
        remainingGestures = gestureNum
        gesture.text = "\(remainingGestures)"
    }
    
    //increase score by one
    func incramentScore(){
        currentScore += 1
        score.text = "\(currentScore)"
    }
    
    //hides gesture image
    func hideImage(shape : String){
        childNodeWithName(shape)?.zPosition = -2
    }
    
    //shows the gesture image
    func showImage(shape: String){
        childNodeWithName(shape)?.zPosition = 2
    }
    
    //spawning functions
    
    func spawnSprout(){
        let sprout = SKReferenceNode(URL: NSURL (fileURLWithPath: sproutReference!))
        sprout.position.x = 100
        sprout.position.y = 290
        sprout.xScale = 0.5
        sprout.yScale = 0.5
        sprout.zPosition = 0
        
        entities.append(sprout)
        monsters.append(Sprout(health: 1))
        
        addChild(sprout)
    }
    
    func spawnFlower(){
        let flower = SKReferenceNode(URL: NSURL (fileURLWithPath: flowerReference!))
        flower.position.x = 100
        flower.position.y = 290
        flower.xScale = 0.5
        flower.yScale = 0.5
        flower.zPosition = 0
                
        entities.append(flower)
        monsters.append(Flower(health: 2))
        
        addChild(flower)
    }
    
    func spawnMushroom(){
        let mushroom = SKReferenceNode(URL: NSURL (fileURLWithPath: mushroomReference!))
        mushroom.position.x = 100
        mushroom.position.y = 290
        mushroom.xScale = 0.5
        mushroom.yScale = 0.5
        mushroom.zPosition = 0
        
        entities.append(mushroom)
        monsters.append(Mushroom(health: 4))
        
        addChild(mushroom)
    }
    
    func spawnFroguana(){
        let froguana = SKReferenceNode(URL: NSURL (fileURLWithPath: froguanaReference!))
        froguana.position.x = 100
        froguana.position.y = 290
        froguana.xScale = 0.5
        froguana.yScale = 0.5
        froguana.zPosition = 0
        
        entities.append(froguana)
        monsters.append(Froguana(health: 6))
        
        addChild(froguana)
    }
    
    func randomizeSpawn(){
        let random = arc4random_uniform(100)
        if random < 50 { spawnSprout() }
        else if random < 80 { spawnFlower() }
        else if random < 95 { spawnMushroom() }
        else { spawnFroguana() }
    }
   
    override func update(currentTime: CFTimeInterval) {
        if gameOver { return }
        
        var count = 0
        if monsters.count > 0{
            for entity in entities{
            
                //if monster health 0 remove from lists and incrament score
                if !monsters[count].isAlive(){
                    entities.removeAtIndex(count)
                    monsters.removeAtIndex(count)
                    entity.runAction(disappear){
                        entity.removeFromParent()
                    }
                    incramentScore()
                    continue
                }
            
                // some bs limits
                if entity.position.y > 40{
                    entity.position.y -= monsters[count].vy
                }
                else{
                    monsters[count].tickAttack(fixedDelta)
                    if monsters[count].attackTimer >= 1.5{
                        playerDamage()
                        monsters[count].attackTimer = 0
                        if playerHealth <= 0{
                            gameOver = true
                            restart.state = .Active
                        }
                    }
                }
            
                if entity.position.x > 40 {
                    entity.position.x -= monsters[count].vx
                }
                if entity.xScale < 1{
                    entity.xScale += monsters[count].scale
                    entity.yScale += monsters[count].scale
                }
                count += 1
            }
        }
        
        spawnTimer += fixedDelta
        
        if spawnTimer >= 3.5{
            randomizeSpawn()
            spawnTimer = 0
        }
    }
}






