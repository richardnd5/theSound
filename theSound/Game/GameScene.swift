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

class GameScene: SKScene, SKPhysicsContactDelegate {
        
    private struct ZLayers {
        static let background: CGFloat = -100
        static let Game: CGFloat = 1
        static let UI: CGFloat = 100
    }

    let worldBlockWidth: CGFloat = 1500
    var worldBlocks = [WorldBlock]()
    
    let tempo: CGFloat = 110
    var soundTimer: Timer!
    var beatIndex = 0
    var subdivisions = 16
    
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
        backgroundColor = #colorLiteral(red: 0.09816829115, green: 0.06094957143, blue: 0.177924186, alpha: 1)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    
        addBackground()
        
        addChild(hero)
        hero.position = CGPoint(x: worldBlockWidth/2, y: worldBlockWidth/2)
        
        camera = cameraNode
        cameraNode.position = hero.position
        
        createBlocks(around: previousBlockPosition)
            
        instructionLabel.position = CGPoint(x: hero.position.x, y: hero.position.y + 200)
        addChild(instructionLabel)
        
        cleanupTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {_ in
            self.cleanup()
        })
        setupSoundTimer()
    }
        
    private func addBackground() {
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

        block.position.x = (CGFloat(blockPosition.x) * worldBlockWidth) + worldBlockWidth/2
        block.position.y = (CGFloat(blockPosition.y) * worldBlockWidth) + worldBlockWidth/2
        
        worldBlocks.append(block)
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
        backgroundStars.checkForStarWrapAround(heroPosition: hero.position, screenSize: size)
    }
    
    private func checkIfCurrentBlockChanged() {
        if currentBlockPosition != previousBlockPosition {
            createBlocks(around: currentBlockPosition)
        }
        previousBlockPosition = currentBlockPosition
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
            
            bounceObjectAway(from: bumperNode, object: otherNode, speed: 1500)
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
            soundBall.removeFromParent()
        }


    }
    
    // MARK: Memory Management
    private func cleanup() {
        // remove things way outside view
    }
    
    // MARL: Sound
    func playBeatSubdivision() {
        worldBlocks.forEach {
            for child in $0.children {
                guard let soundBall = child as? SoundBall else {
                    continue
                }
                soundBall.playBeat(beatIndex: beatIndex)
            }
        }

        beatIndex += 1
        if beatIndex == subdivisions {
            beatIndex = 0
        }
    }
}
