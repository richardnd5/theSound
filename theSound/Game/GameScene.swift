//
//  GameScene.swift
//  Color Cheatah
//
//  Created by Jayson Coppo on 1/3/21.
//

import SpriteKit

class GameScene: SKScene {
        
    private struct ZLayers {
        static let background: CGFloat = -100
        static let Game: CGFloat = 1
        static let UI: CGFloat = 100
    }

    let worldBlockWidth: CGFloat = 1500
    var worldBlocks = [WorldBlock]()
    
    var currentBlockPosition: BlockPosition {
        let x = Int(floor(hero.position.x/CGFloat(worldBlockWidth)))
        let y = Int(floor(hero.position.y/CGFloat(worldBlockWidth)))
        return BlockPosition(x: x, y: y)
    }
    var previousBlockPosition = BlockPosition(x: 0, y: 0)
    
    var cleanupTimer: Timer!
    
    let cameraNode = SKCameraNode()
    let hero = Ball()
    var backgroundStars: BackgroundStars!
    let instructionLabel = GameLabel(text: "Swipe to move ball")
    
    override func didMove(to view: SKView) {
        backgroundColor = #colorLiteral(red: 0.09816829115, green: 0.06094957143, blue: 0.177924186, alpha: 1)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    
        addBackground()
                
        addChild(hero)
        hero.position = CGPoint(x: worldBlockWidth/2, y: worldBlockWidth/2)
        
        camera = cameraNode
        cameraNode.position = hero.position
        
        createBlocks(around: previousBlockPosition)
        
        cleanupTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {_ in
            self.cleanup()
        })
        
        instructionLabel.position = CGPoint(x: hero.position.x, y: hero.position.y + 400)
        addChild(instructionLabel)
    }
    
    private func addBackground() {
        backgroundStars = BackgroundStars(size: size)
        backgroundStars.zPosition = ZLayers.background
        addChild(backgroundStars)
    }
    
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {        
        for t in touches {
            let touchPoint = t.location(in: self)
            
            // TAP BUTTON
            for node in nodes(at: touchPoint) {
                // check for node name
            }
        }
    }
    
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

    override func didSimulatePhysics() {
        cameraNode.position = hero.position
        
        // Background Paralax
        backgroundStars.position.x = hero.position.x * 0.95
        backgroundStars.position.y = hero.position.y * 0.95

        checkIfCurrentBlockChanged()
    }
    
    private func checkIfCurrentBlockChanged() {
        if currentBlockPosition != previousBlockPosition {
            createBlocks(around: currentBlockPosition)
        }
        previousBlockPosition = currentBlockPosition
    }
    
    
    private func cleanup() {
        // remove things way outside view
    }
}