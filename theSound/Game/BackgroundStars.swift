//
//  BackgroundStars.swift
//  Ballsplosion
//
//  Created by Jayson Coppo on 1/4/21.
//

import SpriteKit

class BackgroundStars: SKNode {
        
    init(size: CGSize) {
        super.init()
        
        for _ in 0..<20 {
            let star = SKShapeNode(circleOfRadius: 1)
            star.fillColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            star.lineWidth = 0
            addChild(star)
            
            star.position.x = CGFloat.random(in: -size.width/2...size.width/2)
            star.position.y = CGFloat.random(in: -size.height/2...size.height/2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
