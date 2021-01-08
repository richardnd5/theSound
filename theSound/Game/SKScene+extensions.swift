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

extension SKNode {
    func move(_ dx: CGFloat, _ dy: CGFloat, factor: CGFloat) {
        physicsBody?.velocity.dx += dx * factor
        physicsBody?.velocity.dy += dy * factor
    }
    
    func stopMotion() {
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        physicsBody?.angularVelocity = 0
    }
    
    func pulse(to scale: CGFloat) {
        run(SKAction.sequence([
            SKAction.scale(to: scale, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1),
        ]))
    }
    
    static func pointDirection(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return atan2(dy, dx)
    }
}

extension UIColor {
    static var randomHueFaded: UIColor {
        let h = CGFloat.random(in: 0...1)
        return UIColor(hue: h, saturation: 0.4, brightness: 1.0, alpha: 0.6)
    }
}
