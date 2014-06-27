//
//  HelloScene.swift
//  HelloSpriteKit
//
//  Created by Nicolas Ameghino on 6/13/14.
//  Copyright (c) 2014 Nicolas Ameghino. All rights reserved.
//

import UIKit
import SpriteKit

class HelloScene: SKScene {
    
    var contentCreated = false
    
    func newHelloNode() -> SKLabelNode {
        let node = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
        node.name = "helloNode"
        node.text = "Hello, SpriteKit!"
        node.fontSize = 42.0
        node.position = CGPointMake(
            CGRectGetMidX(self.frame),
            CGRectGetMidY(self.frame)
        )
        return node
    }
    
    func createContent() {
        self.backgroundColor = SKColor.blueColor()
        self.scaleMode = SKSceneScaleMode.AspectFit
        self.addChild(self.newHelloNode())
        contentCreated = true
    }
    
    override func didMoveToView(view: SKView!) {
        if !contentCreated {
            self.createContent()
        }
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        if let node = self.childNodeWithName("helloNode") {
            node.name = nil
            
            let sequence = SKAction.sequence(
                [
                    SKAction.moveByX(0, y: 100, duration: 0.5),
                    SKAction.scaleTo(2.0, duration: 0.25),
                    SKAction.waitForDuration(0.5),
                    SKAction.fadeOutWithDuration(0.25),
                    SKAction.removeFromParent()
                ]
            )
            node.runAction(sequence,
                completion: {
                    let spaceshipScene = SpaceshipScene(size: self.size)
                    let doors = SKTransition.doorwayWithDuration(0.5)
                    self.view.presentScene(spaceshipScene, transition: doors)
                })
        }
        
    }
}
