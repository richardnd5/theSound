//
//  SoundBall.swift
//  theSound
//
//  Created by Jayson Coppo on 1/8/21.
//

import SpriteKit
import AudioKit

class SoundBall: SKNode {
    
    let radius: CGFloat = 40
    var outerColor: UIColor!
    var innerColor: UIColor!

    var moveTimer: Timer!
    var soundIsActivated = false
    var melody = [Bool]()
    let noteNumber = MIDINoteNumber.random(in: MIDINoteNumber(48)...MIDINoteNumber(84))
    
    override init() {
        super.init()
        
        innerColor = UIColor.random
        outerColor = UIColor.random

        let outerCircle = SKShapeNode(circleOfRadius: radius)
        outerCircle.fillColor = outerColor
        outerCircle.lineWidth = 0
        addChild(outerCircle)
        
        let innerCrcle = SKShapeNode(circleOfRadius: radius*0.65)
        innerCrcle.fillColor = innerColor
        innerCrcle.lineWidth = 0
        addChild(innerCrcle)
        
        setupPhysics()
        move()
        generateRhythm()
    }
        
    private func setupPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.isDynamic = true
        physicsBody?.linearDamping = 0.5
        physicsBody?.restitution = 0.4
        physicsBody?.categoryBitMask = BitMask.SoundBall
        physicsBody?.contactTestBitMask = BitMask.Hero
        physicsBody?.collisionBitMask = BitMask.Plank
    }
    
    private func move() {
        let direction = CGFloat.random(in: 0...CGFloat.pi*2)
        let moveSpeed = CGFloat.random(in: 1000...4000)
        let dx = cos(direction) * moveSpeed
        let dy = sin(direction) * moveSpeed
        physicsBody?.applyForce(CGVector(dx: dx, dy: dy))
        
        let moveTime = TimeInterval.random(in: 0.5...1.5)
        Timer.scheduledTimer(withTimeInterval: moveTime, repeats: false, block: { _ in
            self.move()
        })
    }
    
    private func generateRhythm() {
        for _ in 0..<16 {
            let beat = Float.random(in: 0...1) < 0.25 ? true : false
            melody.append(beat)
        }
    }
    
    func playBeat(beatIndex: Int) {
        guard soundIsActivated,
              beatIndex < melody.count else {
            return
        }
        
        if melody[beatIndex] {
            Sound.shared.soundEffects.play(.marimbaC, note: noteNumber, velocity: MIDIVelocity(Int.random(in: 60...120)), pan: 0.5)
            pulse(to: 1.2)
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
