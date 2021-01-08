//
//  Triangle.swift
//  theSound
//
//  Created by Jayson Coppo on 1/7/21.
//

import SpriteKit

class Triangle: SKNode {
    
    let width: CGFloat = 70
    let color = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    let borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    var shapePath: CGMutablePath!
    
    override init() {
        super.init()
        
        shapePath = CGMutablePath()
        shapePath.move(to: CGPoint(x: -width, y: -width*sqrt(3)/2))
        shapePath.addLine(to: CGPoint(x: width, y: -width*sqrt(3)/2))
        shapePath.addLine(to: CGPoint(x: 0, y: width*sqrt(3)/2))
        shapePath.addLine(to: CGPoint(x: -width, y: -width*sqrt(3)/2))

        let shape = SKShapeNode(path: shapePath)
        shape.fillColor = color
        shape.strokeColor = borderColor
        shape.lineWidth = 8
        addChild(shape)
        
        setupPhysics()
    }
        
    private func setupPhysics() {
        physicsBody = SKPhysicsBody(polygonFrom: self.shapePath)
        physicsBody?.isDynamic = true
        physicsBody?.linearDamping = 0.5
        physicsBody?.restitution = 0.4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
