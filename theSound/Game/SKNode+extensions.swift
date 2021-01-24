//
//  SKNode+extensions.swift
//  theSound
//
//  Created by Jayson Coppo on 1/8/21.
//

import SpriteKit

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
        run(.sequence([
            .scale(to: scale, duration: 0.1),
            .scale(to: 1.0, duration: 0.1),
        ]))
    }

    func distanceFrom(point: CGPoint) -> CGFloat {
        let dx = point.x - position.x
        let dy = point.y - position.y
        return sqrt(pow(dx, 2) + pow(dy, 2))
    }
    
    var speedScalar: CGFloat {
        guard let dx = physicsBody?.velocity.dx,
              let dy = physicsBody?.velocity.dy else {
            return 0
        }
        return sqrt(pow(dx, 2) + pow(dy, 2))
    }
    
    static func pointDirection(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return atan2(dy, dx)
    }
}
