//
//  GameScene.swift
//  Breakout
//
//  Created by Rishi Anand on 7/12/18.
//  Copyright © 2018 Rishi Anand. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var ball = SKShapeNode()
    
    override func didMove(to view: SKView) {
        createBackGround()
        makeBall()
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
}
