//
//  SpaceshipScene.swift
//  HelloSpriteKit
//
//  Created by Nicolas Ameghino on 6/13/14.
//  Copyright (c) 2014 Nicolas Ameghino. All rights reserved.
//
import UIKit
import SpriteKit

class SpaceshipScene: SKScene, SKPhysicsContactDelegate {
    var contentCreated = false
    var spaceship: SKSpriteNode?
    var touchPoint: CGPoint?
    let touchPointNode: SKSpriteNode
    
    let rockCategory: UInt32 = 0x1 << 0
    let touchCategory: UInt32 = 0x1 << 1
    
    init(size: CGSize) {
        let touchPointRadius = CGFloat(25.0)
        touchPointNode = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: touchPointRadius, height: touchPointRadius))
        touchPointNode.physicsBody = SKPhysicsBody(circleOfRadius: touchPointRadius)
        touchPointNode.physicsBody.dynamic = false
        touchPointNode.physicsBody.categoryBitMask = touchCategory
        touchPointNode.physicsBody.collisionBitMask = rockCategory
        touchPointNode.physicsBody.contactTestBitMask = rockCategory
        
        super.init(size: size)
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0)
    }
    
    let density = 1.8 as CGFloat
    func addRocks(count: Int = 1) {
        if self.children.count > 20 { return }
        for i in (0..count) {
            
            let size = randBetween(10, and: 40)
            
            let rock = SKSpriteNode(color: SKColor.brownColor(), size: CGSizeMake(size, size))
            rock.position = CGPointMake(
                randBetween(0, and: self.size.width),
                randBetween(0, and: self.size.height)
            )
            rock.name = "rock"
            rock.physicsBody = SKPhysicsBody(rectangleOfSize: rock.size)
            rock.physicsBody.usesPreciseCollisionDetection = true
            rock.physicsBody.density = density
            rock.physicsBody.restitution = 1
            rock.physicsBody.categoryBitMask = rockCategory
            rock.physicsBody.collisionBitMask = rockCategory | touchCategory
            rock.physicsBody.contactTestBitMask = rockCategory | touchCategory
            self.addChild(rock)
        }
    }
    
    func createContent() {
        self.backgroundColor = SKColor.blackColor()
        self.scaleMode = SKSceneScaleMode.AspectFit
        //self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectInset(self.frame, -1, -1))
        
        /*
        spaceship = newSpaceship()
        spaceship!.position = CGPointMake(
        CGRectGetMidX(self.frame),
        CGRectGetMidY(self.frame) - 150.0
        )
        self.addChild(spaceship)
        */
        
        let createRocksAction = SKAction.sequence(
            [
                SKAction.runBlock({ self.addRocks() }),
                SKAction.waitForDuration(0.1, withRange: 0.15)
                
            ])
        self.runAction(SKAction.repeatAction(createRocksAction, count: 20))
        
        contentCreated = true
    }
    
    override func didMoveToView(view: SKView!) {
        if !contentCreated {
            self.createContent()
        }
    }
    
    override func didSimulatePhysics() {
        self.enumerateChildNodesWithName("rock", usingBlock:
            {
                (node: SKNode!, stop: CMutablePointer<ObjCBool>) -> Void in
                switch node.position.x {
                case 0..self.size.width:
                    break
                default:
                    node.removeFromParent()
                }
                switch node.position.y {
                case 0..self.size.height:
                    break
                default:
                    node.removeFromParent()
                }
                
            }
        )
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        let touch = touches!.anyObject() as UITouch
        touchPoint = touch.locationInNode(self)
        let touchedNodes = self.nodesAtPoint(touchPoint!)
        if touchedNodes.count != 0 {
            NSLog("touched %@", touchedNodes)
        } else {
            touchPointNode.position = touchPoint!
            self.addChild(touchPointNode)
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        let touch = touches!.anyObject() as UITouch
        touchPoint = touch.locationInNode(self)
        touchPointNode.position = touchPoint!
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        touchPoint = nil
        touchPointNode.removeFromParent()
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!)  {
        touchPoint = nil
        touchPointNode.removeFromParent()
    }
    
    func didBeginContact(contact: SKPhysicsContact!) {
        let a = contact.bodyA.node
        let b = contact.bodyB.node
        var otherBody: SKSpriteNode?
        if a != touchPointNode.physicsBody && b != touchPointNode {
            return
        } else {
            if a == touchPointNode.physicsBody {
                otherBody = b as? SKSpriteNode
            } else {
                otherBody = a as? SKSpriteNode
            }
        }
        self.destroyRock(otherBody!)
    }
    
    func destroyRock(rock: SKSpriteNode) {
        let newRockSize = rock.size.width / 2
        let point = rock.position
        NSLog("will remove %@", rock)
        rock.removeFromParent()
        for x in 0..2 {
            for y in 0..2 {
                let littleRock = SKSpriteNode(color: SKColor.greenColor(), size: CGSize(width: newRockSize, height: newRockSize))
                littleRock.physicsBody = SKPhysicsBody(rectangleOfSize: littleRock.size)
                littleRock.name = "explodedRock"
                littleRock.physicsBody.usesPreciseCollisionDetection = true
                littleRock.physicsBody.density = density
                littleRock.physicsBody.restitution = 1
                littleRock.physicsBody.categoryBitMask = rockCategory
                littleRock.physicsBody.collisionBitMask = rockCategory | touchCategory
                littleRock.physicsBody.contactTestBitMask = rockCategory | touchCategory
                
                var dict: NSMutableDictionary = [:]
                dict["origin"] = NSValue(CGPoint: point)
                littleRock.userData = dict
                
                let nx: CGFloat = point.x + CGFloat(1 * (x % 2 == 0  ? -1 : 1))
                let ny: CGFloat = point.y + CGFloat(1 * (y % 2 == 0  ? -1 : 1))
                littleRock.position = CGPointMake(nx, ny)
                
                self.addChild(littleRock)
                NSLog("added %@", littleRock)
            }
        }
    }
    
    override func update(currentTime: NSTimeInterval)  {
        self.enumerateChildNodesWithName("explodedRock", usingBlock: {
            (node: SKNode!, stop: CMutablePointer<ObjCBool>) -> Void in
            let point = (node.userData["origin"] as NSValue).CGPointValue()
            let forceVector = CGVectorMake(node.position.x - point.x, node.position.y - point.y)
            node.physicsBody.applyImpulse(forceVector)
            node.name = "rock"
            })
    }
}
