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
        label.fontColor = .yellow
        label.fontName = "Verdana-Bold"
        label.fontSize = 30
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
