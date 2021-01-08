//
//  Ball.swift
//  Color Cheatah
//
//  Created by Jayson Coppo on 1/3/21.
//

import SpriteKit

class Ball: SKNode {
    
    let radius: CGFloat = 20
    let color = #colorLiteral(red: 0.4824152589, green: 0.3049225211, blue: 0.8937572837, alpha: 1)
    
    override init() {
        super.init()
        
        let circle = SKShapeNode(circleOfRadius: radius)
        circle.fillColor = color
        circle.lineWidth = 0
        addChild(circle)
        
        setupPhysics()
    }
        
    private func setupPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.isDynamic = true
        physicsBody?.linearDamping = 0.5
        physicsBody?.restitution = 0.4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
