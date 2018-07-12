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
    var scoreLabel = SKLabelNode()
    var livesLabel = SKLabelNode()
    var brickValues = [SKSpriteNode: Int]()
    var score = 0
    var lives = 3
    var originalBricks = 0
    var colors = [UIColor.blue, UIColor.green, UIColor.yellow]
    var playing = true
    var resultLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        beginPlay()
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
        ball = SKShapeNode(circleOfRadius: 100)
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
                let brick = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 50, height: 20))
                brick.position = CGPoint(x: CGFloat(Int(frame.minX) + (60 + 60 * j)), y: CGFloat(Int(frame.maxY) - 30*(i+1)))
                brick.name = "brick\(i)\(j)"
                brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
                brick.physicsBody?.isDynamic = false
                bricks.append(brick)
                brickValues[brick] = i
                brick.color = colors[i]
                addChild(brick)
            }
        }
        originalBricks = bricks.count
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
        if(playing){
            for touch in touches {
                let location = touch.location(in: self)
                paddle.position.x = location.x
            }
            if(ball.speed <= 0.0){
                ball.speed = 1.0
                ball.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 5))
            }
            if(ball.speed <= 2.0){
                ball.speed = 5.0
            }
        }
        else{
            playing = true
            beginPlay()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(playing){
            for touch in touches {
                let location = touch.location(in: self)
                paddle.position.x = location.x
            }
        }
        else{
            beginPlay()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        for i in bricks{
            if (contact.bodyA.node)! == i ||
                (contact.bodyB.node)! == i {
                if(brickValues[i] == 0){
                    i.removeFromParent()
                    bricks.remove(at: bricks.index(of: i)!)
                    score += 1
                    resetScoreLabel()
                }
                else{
                    brickValues[i]! -= 1
                    i.color = colors[brickValues[i]!]
                }
                if(score == originalBricks){
                    setResultNode(message: "You win! Click to play again")
                    playing = false
                }
            }
        }
        
        if contact.bodyA.node?.name == "loseZone" ||
            contact.bodyB.node?.name == "loseZone" {
            if(lives == 1){
                lives -= 1
                resetLivesLabel()
                setResultNode(message: "You lose! Click to play again")
                playing = false
                ball.removeFromParent()
            }
            else{
                lives -= 1
                resetLivesLabel()
                ball.run(SKAction .move(to: CGPoint(x: 0, y: 0), duration: 0.0))
            }
        }
    } 
    
    func makeScoreLabel(){
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: frame.maxX - 64, y: frame.minY + 20)
        scoreLabel.fontSize = 28
        scoreLabel.color = .yellow
        scoreLabel.fontColor = .green
        addChild(scoreLabel)
    }
    
    func resetScoreLabel(){
        scoreLabel.text = "Score: \(score)"
    }
    
    func makeLivesLabel(){
        livesLabel.text = "Lives: \(lives)"
        livesLabel.position = CGPoint(x: frame.minX + 64, y: frame.minY + 20)
        livesLabel.fontSize = 28
        livesLabel.color = .yellow
        livesLabel.fontColor = .green
        addChild(livesLabel)
    }
    
    func resetLivesLabel(){
        livesLabel.text = "Lives: \(lives)"
    }
    
    func beginPlay(){
        self.removeAllChildren()
        createBackGround()
        makeBall()
        makePaddle()
        makeBricks()
        makeLoseZone()
        makeScoreLabel()
        makeLivesLabel()
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 5))
    }
 
    func setResultNode(message: String){
        resultLabel.text = message
        resultLabel.fontSize = 36
        resultLabel.fontColor = .white
        resultLabel.position = CGPoint(x: 0, y: 0)
        addChild(resultLabel)
    }
    
}
