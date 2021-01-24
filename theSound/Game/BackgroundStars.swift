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
    
    func checkForStarWrapAround(heroPosition: CGPoint, screenSize: CGSize) {
        children.forEach {
            let starToHero_X = $0.position.x + (position.x - heroPosition.x)
            let starToHero_Y = $0.position.y + (position.y - heroPosition.y)
            
            if starToHero_X > screenSize.width/2 {
                $0.position.x -= screenSize.width
            }
            if starToHero_X < -screenSize.width/2 {
                $0.position.x += screenSize.width
            }
            if starToHero_Y > screenSize.height/2 {
                $0.position.y -= screenSize.height
            }
            if starToHero_Y < -screenSize.height/2 {
                $0.position.y += screenSize.height
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
