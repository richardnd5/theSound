//
//  GameScene.swift
//  Color Cheatah
//
//  Created by Jayson Coppo on 1/3/21.
//

import SpriteKit

struct BitMask {
    static let None: UInt32 = 0x1 << 0
    static let Hero: UInt32 = 0x1 << 1
    static let Bumper: UInt32 = 0x1 << 2
    static let StickyBall: UInt32 = 0x1 << 3
    static let SoundBall: UInt32 = 0x1 << 4
    static let Plank: UInt32 = 0x1 << 5
}

enum WorldMode {
    case sky, space
}

class GameScene: SKScene, SKPhysicsContactDelegate {
        
    private struct ZLayers {
        static let background: CGFloat = -100
        static let Game: CGFloat = 1
        static let UI: CGFloat = 100
    }

    let worldMode = WorldMode.sky
    
    let worldBlockWidth: CGFloat = 1500
    var worldBlocks = [WorldBlock]()
    
    let tempo: CGFloat = 90
    var soundTimer: Timer!
    var beatIndex = 0
    var subdivisions = 16
    
    var soundBallsCollected = [SoundBallMini]()
    
    var currentBlockPosition: BlockPosition {
        let x = Int(floor(hero.position.x/CGFloat(worldBlockWidth)))
        let y = Int(floor(hero.position.y/CGFloat(worldBlockWidth)))
        return BlockPosition(x: x, y: y)
    }
    var previousBlockPosition = BlockPosition(x: 0, y: 0)
    
    var cleanupTimer: Timer!
    
    let cameraNode = SKCameraNode()
    let hero = HeroBall()
    var backgroundStars: BackgroundStars!
    let instructionLabel = GameLabel(text: "Swipe to move")
    
    // MARK: Setup
    override func didMove(to view: SKView) {
        let grav_Y = worldMode == .space ? 0 : -5
        physicsWorld.gravity = CGVector(dx: 0, dy: grav_Y)
        physicsWorld.contactDelegate = self
    
        addBackground()
        addChild(hero)
        
        camera = cameraNode
        cameraNode.position = hero.position
        
        createBlocks(around: currentBlockPosition)
            
        instructionLabel.position = CGPoint(x: hero.position.x, y: hero.position.y + 200)
        addChild(instructionLabel)
        
        cleanupTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {_ in
            self.cleanup()
        })
        setupSoundTimer()
    }
        
    private func addBackground() {
        backgroundColor = worldMode == .space ? #colorLiteral(red: 0.09816829115, green: 0.06094957143, blue: 0.177924186, alpha: 1) : #colorLiteral(red: 0.2785946727, green: 0.2789702415, blue: 0.5156394839, alpha: 1)

        backgroundStars = BackgroundStars(size: size)
        backgroundStars.zPosition = ZLayers.background
        addChild(backgroundStars)
    }
    
    private func setupSoundTimer() {
        let beatDuration = TimeInterval(60/tempo)
        //16th Notes
        soundTimer = Timer.scheduledTimer(withTimeInterval: beatDuration/4, repeats: true, block: { _ in
            self.playBeatSubdivision()
        })
    }
    
    // MARK: Game Events
    private func createBlocks(around pos: BlockPosition) {
        let positions: [BlockPosition] = [
            BlockPosition(x: pos.x, y: pos.y),
            BlockPosition(x: pos.x+1, y: pos.y),
            BlockPosition(x: pos.x-1, y: pos.y),
            BlockPosition(x: pos.x, y: pos.y+1),
            BlockPosition(x: pos.x, y: pos.y-1),
            BlockPosition(x: pos.x+1, y: pos.y+1),
            BlockPosition(x: pos.x-1, y: pos.y-1),
            BlockPosition(x: pos.x+1, y: pos.y-1),
            BlockPosition(x: pos.x-1, y: pos.y+1)
        ]
        
        positions.forEach {
            createBlockIfNotExist(at: $0)
        }
    }
    
    private func createBlockIfNotExist(at blockPosition: BlockPosition) {
        for block in worldBlocks {
            if block.blockPosition == blockPosition {
                return
            }
        }
        
        let block = WorldBlock(blockPosition: blockPosition, width: worldBlockWidth)
        addChild(block)

        block.position.x = (CGFloat(blockPosition.x) * worldBlockWidth)
        block.position.y = (CGFloat(blockPosition.y) * worldBlockWidth)
        
        worldBlocks.append(block)
    }

	func makeSpark(at pos: CGPoint){
		let particle = SKEmitterNode(fileNamed: StaticStrings.wallCollisionSKS)
		particle?.position = pos
		particle?.zPosition = ZLayers.background-1
		addChild(particle!)

		particle?.run(.sequence([
			.fadeAlpha(to: 0.0, duration: 0.3),
			.removeFromParent()
		]))
	}


    // MARK: touches
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            // FLICK HERO AROUND
            let location = t.location(in: self)
            let previous = t.previousLocation(in: self)
            let dx = location.x - previous.x
            let dy = location.y - previous.y
            hero.move(dx, dy, factor: 3)
        }
        
        if !instructionLabel.isHidden {
            instructionLabel.isHidden = true
        }
    }

    // MARK: Frame Loop
    override func didSimulatePhysics() {
        cameraNode.position = hero.position

        // Background Paralax
        backgroundStars.position.x = hero.position.x * 0.95
        backgroundStars.position.y = hero.position.y * 0.95

        checkIfCurrentBlockChanged()
        worldBlocks.forEach {
            $0.checkForSoundBallsInView(heroPosition: hero.position, screenSize: size)
        }
        soundBallsFollowHero()
        backgroundStars.checkForStarWrapAround(heroPosition: hero.position, screenSize: size)
    }

    private func checkIfCurrentBlockChanged() {
        if currentBlockPosition != previousBlockPosition {
            createBlocks(around: currentBlockPosition)
        }
        previousBlockPosition = currentBlockPosition
    }
    
    private func soundBallsFollowHero() {
        for (index, soundBall) in soundBallsCollected.enumerated() {
            let delay = TimeInterval(index+1) * 0.2
            let heroPosition = hero.position
            Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
                soundBall.position = heroPosition
            }
        }
    }

    // MARK: Collisions
    func didBegin(_ contact: SKPhysicsContact) {
        let maskA = contact.bodyA.categoryBitMask
        let maskB = contact.bodyB.categoryBitMask


//			print("mask a is Hero",maskA == BitMask.Hero)
//			print("mask a is Bumper",maskA == BitMask.Bumper)
//			print("mask a is Plank",maskA == BitMask.Plank)
//			print("mask a is SoundBall",maskA == BitMask.SoundBall)
//
//
//			print("mask b is Hero",maskB == BitMask.Hero)
//			print("mask b is Bumper",maskB == BitMask.Bumper)
//			print("mask b is Plank",maskB == BitMask.Plank)
//			print("mask b is SoundBall",maskB == BitMask.SoundBall)

		// Hero collides with Bumper
		if (maskA == BitMask.Plank || maskB == BitMask.Hero) {
			Sound.shared.soundEffects.playRandomPitch(.plankHit, noteRange: 60...65)
			makeSpark(at: hero.position)
			return
		}

		if (maskA == BitMask.StickyBall || maskB == BitMask.Hero
				|| maskA == BitMask.Hero || maskB == BitMask.StickyBall) {
			Sound.shared.soundEffects.playRandomPitch(.collectSound, noteRange: 60...65)
		}


		// StickyBall collides with anything
        if maskA == BitMask.StickyBall || maskB == BitMask.StickyBall {
            guard let nodeA = contact.bodyA.node else { return }
            guard let nodeB = contact.bodyB.node else { return }
            let otherNode = maskA == BitMask.StickyBall ? nodeB : nodeA
            otherNode.stopMotion()
        }
        
        // Bumper collides with anything
        if maskA == BitMask.Bumper || maskB == BitMask.Bumper {
            guard let nodeA = contact.bodyA.node else { return }
            guard let nodeB = contact.bodyB.node else { return }
            
            let bumperNode = maskA == BitMask.Bumper ? nodeA : nodeB
            let otherNode = maskA == BitMask.Bumper ? nodeB : nodeA
            
            bumperNode.pulse(to: 1.25)
            
            guard let bumperNodeParent = bumperNode.parent else { return }
            let bumperPositionInScene = convert(bumperNode.position, from: bumperNodeParent)
            bounceAway(node: otherNode, from: bumperPositionInScene, speed: 1500)
        }
        
        // Hero collides with SoundBall
        if (maskA == BitMask.Hero || maskB == BitMask.SoundBall) ||
            (maskA == BitMask.SoundBall || maskB == BitMask.Hero){
            guard let nodeA = contact.bodyA.node else { return }
            guard let nodeB = contact.bodyB.node else { return }
        
            let soundBallNode = maskA == BitMask.SoundBall ? nodeA : nodeB
            guard let soundBall = soundBallNode as? SoundBall else {
                return
            }
            soundBallCollected(soundBall: soundBall)
            soundBall.removeFromParent()
        }
    }
    
    private func soundBallCollected(soundBall: SoundBall) {
        let soundBallMini = SoundBallMini(
            innerColor: soundBall.innerColor,
            outerColor: soundBall.outerColor,
            rhythm: soundBall.rhythm,
            noteNumber: soundBall.noteNumber
        )
        soundBallMini.position.x = soundBall.position.x + (soundBall.parent?.position.x)!
        soundBallMini.position.y = soundBall.position.y + (soundBall.parent?.position.y)!
        addChild(soundBallMini)
        soundBallsCollected.append(soundBallMini)
    }
    
    // MARK: Memory Management
    private func cleanup() {
        // remove things way outside view
    }
    
    // MARK: Sound
    func playBeatSubdivision() {
        worldBlocks.forEach {
            for child in $0.children {
                guard let soundBall = child as? SoundBall else {
                    continue
                }
                soundBall.playBeat(beatIndex: beatIndex)
            }
        }
        
        soundBallsCollected.forEach {
            $0.playBeat(beatIndex: beatIndex)
        }

        beatIndex += 1
        if beatIndex == subdivisions {
            beatIndex = 0
        }
    }
}
