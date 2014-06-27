//
//  PlaygroundScene.swift
//  HelloSpriteKit
//
//  Created by Nicolas Ameghino on 6/16/14.
//  Copyright (c) 2014 Nicolas Ameghino. All rights reserved.
//

import UIKit
import SpriteKit

func randomColor() -> SKColor {
    return SKColor(hue: myRand(), saturation: 0.3 + myRand(), brightness: 0.6 + myRand(), alpha: 1.0)
}

class PlaygroundScene: SKScene {
    
    enum PlaygroundTool {
        case None
        case Creator
        case Eraser
    }
    
    var needsSetup = true
    var selectedTool = PlaygroundTool.None
    var joinBodies = false
    var lastNode: SKNode?
    
    func setup() {
        self.scaleMode = .AspectFit
        self.backgroundColor = SKColor.blackColor()
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        needsSetup = false
    }
    
    func createNode(point: CGPoint) -> SKNode {
        let node = SKSpriteNode(color: randomColor(), size: CGSizeMake(10, 10))
        node.name = "body"
        node.position = point
        node.physicsBody = SKPhysicsBody(rectangleOfSize: node.size)
        node.physicsBody.restitution = 0.4
        self.addChild(node)
        return node
    }
    
    override func didMoveToView(view: SKView!) {
        if needsSetup {
            self.setup()
        }
    }
    
    func extractTouchPoint(touches: NSSet!) -> CGPoint[] {
        var points: CGPoint[] = []
        let p = touches.allObjects as UITouch[]
        for touch in p {
            points.append(touch.locationInNode(self))
        }
        return points
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        for point in self.extractTouchPoint(touches) {
            let touchedNode = self.nodeAtPoint(point)
            let shouldCreateNode = touchedNode == nil || touchedNode == self
            if shouldCreateNode {
                selectedTool = .Creator
                joinBodies = true
                lastNode = self.createNode(point)
            } else {
                NSLog("touched node %@", touchedNode)
            }
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        if selectedTool == .Creator {
            for point in self.extractTouchPoint(touches) {
                let node = self.createNode(point)
                
                if joinBodies {
                    let midpoint = CGPoint(x: (node.position.x + lastNode!.position.x) / 2.0,
                        y: (node.position.y + lastNode!.position.y) / 2.0)
                    let joint = SKPhysicsJointFixed.jointWithBodyA(node.physicsBody, bodyB: lastNode!.physicsBody, anchor: midpoint)
                    
                    self.physicsWorld.addJoint(joint)
                }
                lastNode = node
            }
        }
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        selectedTool = .None
        joinBodies = false
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        selectedTool = .None
        joinBodies = false
    }
    
    override func update(currentTime: NSTimeInterval) {
        self.enumerateChildNodesWithName("body", usingBlock: {
            (node: SKNode!, stop: CMutablePointer<ObjCBool>) -> Void in
            if node.physicsBody.resting {
                node.runAction(SKAction.fadeOutWithDuration(0.3), completion: { node.removeFromParent() })
            }
            })

    }
    
}
