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
    
    func bounceAway(node: SKNode, from position: CGPoint, speed: CGFloat) {
        let angle = SKNode.pointDirection(point1: position, point2: node.position)
        node.physicsBody?.velocity.dx = speed * cos(angle)
        node.physicsBody?.velocity.dy = speed * sin(angle)
    }
}

extension UIColor {
    static var random: UIColor {
        let r = CGFloat.random(in: 0...1)
        let b = CGFloat.random(in: 0...1)
        let g = CGFloat.random(in: 0...1)
        return UIColor(red: r, green: b, blue: g, alpha: 1.0)
    }
    
    static var randomHueFaded: UIColor {
        let h = CGFloat.random(in: 0...1)
        return UIColor(hue: h, saturation: 0.4, brightness: 1.0, alpha: 0.6)
    }
}
