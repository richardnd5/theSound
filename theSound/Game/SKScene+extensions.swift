//
//  SKScene+extensions.swift
//  theSound
//
//  Created by Jayson Coppo on 1/7/21.
//

import SpriteKit

extension SKScene {
    var midScreen: CGPoint {
        return CGPoint(x: size.width/2, y: size.height/2)
    }
    
    func bounceObjectAway(from node1: SKNode, object node2: SKNode, speed: CGFloat) {
        node1.pulse(to: 1.25)
        
        guard let node1Parent = node1.parent else { return }
        let node1PositionInScene = convert(node1.position, from: node1Parent)
        
        let angle = SKNode.pointDirection(point1: node1PositionInScene, point2: node2.position)
        node2.physicsBody?.velocity.dx = speed * cos(angle)
        node2.physicsBody?.velocity.dy = speed * sin(angle)
    }
}

extension UIColor {
    static var randomHueFaded: UIColor {
        let h = CGFloat.random(in: 0...1)
        return UIColor(hue: h, saturation: 0.4, brightness: 1.0, alpha: 0.6)
    }
}
