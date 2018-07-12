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
    
    override func didMove(to view: SKView) {
        createBackGround()
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
}
