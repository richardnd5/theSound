//
//  GameLabel.swift
//  theSound
//
//  Created by Jayson Coppo on 1/7/21.
//

import SpriteKit

class GameLabel: SKNode {
    
    init(text: String) {
        super.init()
        
        let label = SKLabelNode(text: text)
        label.fontName = "Verdana"
        label.fontSize = 38
        label.fontColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
