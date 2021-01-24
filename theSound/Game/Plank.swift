//
//  Plank.swift
//  Color Cheatah
//
//  Created by Jayson Coppo on 1/3/21.
//

import SpriteKit

class Plank: SKNode {
    
    var size: CGSize!
    var isRigid: Bool!
    
    let rigidColor = #colorLiteral(red: 0.4197152853, green: 0.455994606, blue: 0.5045749545, alpha: 1)
    let floatyColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)

    init(size: CGSize, isRigid: Bool) {
        super.init()
        
        self.size = size
        self.isRigid = isRigid
        
        let rect = SKShapeNode(rectOf: size)
        rect.fillColor = isRigid ? rigidColor : floatyColor
        rect.lineWidth = 0
        addChild(rect)
        
        setupPhysics()
    }
    
    private func setupPhysics() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = !isRigid
        physicsBody?.affectedByGravity = false
        physicsBody?.restitution = 0.5
        physicsBody?.categoryBitMask = BitMask.Plank
				physicsBody?.contactTestBitMask = BitMask.Hero
				physicsBody?.collisionBitMask = BitMask.Hero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
