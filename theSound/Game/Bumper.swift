//
//  Bumper.swift
//  Ballsplosion
//
//  Created by Jayson Coppo on 1/4/21.
//

import SpriteKit

class Bumper: SKNode {
    
    let radius: CGFloat = 80
    let outerRingColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    let innerRingColor = #colorLiteral(red: 1, green: 0.8867470026, blue: 0.9833434224, alpha: 1)

    override init() {
        super.init()
        
        let outerRing = SKShapeNode(circleOfRadius: radius)
        outerRing.fillColor = outerRingColor
        outerRing.lineWidth = 0
        addChild(outerRing)
        
        let innerCrcle = SKShapeNode(circleOfRadius: radius*0.75)
        innerCrcle.fillColor = innerRingColor
        innerCrcle.lineWidth = 0
        addChild(innerCrcle)
        
        setupPhysics()
    }
        
    private func setupPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.isDynamic = false
        physicsBody?.restitution = 2.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
