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
}

extension SKNode {
    func move(_ dx: CGFloat, _ dy: CGFloat, factor: CGFloat) {
        physicsBody?.velocity.dx += dx * factor
        physicsBody?.velocity.dy += dy * factor
    }
}

extension UIColor {
    static var randomHueFaded: UIColor {
        let h = CGFloat.random(in: 0...1)
        return UIColor(hue: h, saturation: 0.4, brightness: 1.0, alpha: 0.6)
    }
}
