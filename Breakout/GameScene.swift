//
//  GameScene.swift
//  Breakout
//
//  Created by Rishi Anand on 7/12/18.
//  Copyright © 2018 Rishi Anand. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball = SKShapeNode()
    var paddle = SKSpriteNode()
    var bricks = [SKSpriteNode]()
    var loseZone = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        createBackGround()
        makeBall()
        makePaddle()
        makeBricks()
        makeLoseZone()
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 5))
    }
    
    func createBackGround(){
        let stars = SKTexture(imageNamed: "stars")
        for i in 0...1{
            let starsBg = SKSpriteNode(texture: stars)
            starsBg.zPosition = -1
            starsBg.position = CGPoint(x: 0, y: starsBg.size.height * CGFloat(i))
            addChild(starsBg)
            let moveDown = SKAction.moveBy(x: 0, y: -starsBg.size.height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: starsBg.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            starsBg.run(moveForever)
        }
    }
    
    func makeBall() {
        ball = SKShapeNode(circleOfRadius: 10)
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.strokeColor = UIColor.black
        ball.fillColor = UIColor.yellow
        ball.name = "ball"
        
        // physics shape matches ball image
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        // ignores all forces and impulses
        ball.physicsBody?.isDynamic = false
        // use precise collision detection
        ball.physicsBody?.usesPreciseCollisionDetection = true
        // no loss of energy from friction
        ball.physicsBody?.friction = 0
        // gravity is not a factor
        ball.physicsBody?.affectedByGravity = false
        // bounces fully off of other objects
        ball.physicsBody?.restitution = 1
        // does not slow down over time
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
        
        addChild(ball) // add ball object to the view
    }
    
    func makePaddle() {
        paddle = SKSpriteNode(color: UIColor.white, size: CGSize(width: frame.width/4, height: 20))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)
    }
    
    func makeBricks() {
        let brickCount = Int(self.frame.width/60)
        let layerCount = 3
        for i in 0..<layerCount{
            for j in 0..<brickCount{
                var brick = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 50, height: 20))
                brick.position = CGPoint(x: CGFloat(Int(frame.minX) + (60 + 60 * j)), y: CGFloat(Int(frame.maxY) - 30*(i+1)))
                brick.name = "brick\(i)\(j)"
                brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
                brick.physicsBody?.isDynamic = false
                bricks.append(brick)
                addChild(brick)
            }
        }
    }

    func makeLoseZone() {
        loseZone = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width, height: 50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        for i in bricks{
            if (contact.bodyA.node)! == i ||
                (contact.bodyB.node)! == i {
                i.removeFromParent()
                bricks.remove(at: bricks.index(of: i)!)
            }
        }
        
        if contact.bodyA.node?.name == "loseZone" ||
            contact.bodyB.node?.name == "loseZone" {
            print("You lose!")
            ball.removeFromParent()
        }
    } 
    
}
