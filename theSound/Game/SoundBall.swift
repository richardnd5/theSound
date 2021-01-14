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

	var outerCircle: SKShapeNode!
	var innerCircle: SKShapeNode!

	private var canPulse = true
    
    override init() {
        super.init()
        
        innerColor = UIColor.random
        outerColor = UIColor.random

        outerCircle = SKShapeNode(circleOfRadius: radius)
        outerCircle.fillColor = outerColor
        outerCircle.lineWidth = 0
        addChild(outerCircle)
        
        innerCircle = SKShapeNode(circleOfRadius: radius*0.65)
        innerCircle.fillColor = innerColor
        innerCircle.lineWidth = 0
        addChild(innerCircle)
        
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
			if canPulse {
				pulse(to: 1.2)
			}
		}
	}

	func remove() {
		if canPulse {
			print("removing")
			canPulse = false

			let scaleOut: SKAction = .scale(by: 1.5, duration: 0.1)
			let shrink: SKAction = .scale(to: 0, duration: 0.1)

			run(.sequence([
				scaleOut,
				shrink,
				.removeFromParent()
			]))
		}
	}


//	func createLingeringParticles(at node: SKNode, pos: CGPoint, completion: @escaping () -> () = {}){
//		print("creating particles")
//		let particle = SKEmitterNode(fileNamed: StaticStrings.lingeringParticles)
//		particle?.position = pos
//		node.addChild(particle!)
//
//		particle?.run(.sequence([
//			.fadeAlpha(to: 0.0, duration: 0.5),
//			.removeFromParent(),
//			.run{completion()}
//		]))
//	}

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
