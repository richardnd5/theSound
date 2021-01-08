//
//  StickyBall.swift
//  theSound
//
//  Created by Jayson Coppo on 1/7/21.
//

import SpriteKit

class StickyBall: SKNode {
    
    let radius: CGFloat = 60
    let color = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    let borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)

    override init() {
        super.init()
        
        let circle = SKShapeNode(circleOfRadius: radius)
        circle.fillColor = color
        circle.strokeColor = borderColor
        circle.lineWidth = 8
        addChild(circle)
        
        setupPhysics()
    }
        
    private func setupPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = BitMask.StickyBall
        physicsBody?.contactTestBitMask = BitMask.Hero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
