//
//  WorldBlock.swift
//  Ballsplosion
//
//  Created by Jayson Coppo on 1/4/21.
//

import SpriteKit

struct BlockPosition: Equatable {
    var x: Int
    var y: Int
}

class WorldBlock: SKNode {
    
    private enum WorldType: CaseIterable {
        case soundBalls, planks, bumpers, triangles, stickyBall
    }
    
    var width: CGFloat!
    var blockPosition: BlockPosition!
    
    var randomPositionInBlock: CGPoint {
        let x = CGFloat.random(in: -width/2...width/2)
        let y = CGFloat.random(in: -width/2...width/2)
        return CGPoint(x: x, y: y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(blockPosition: BlockPosition, width: CGFloat) {
        super.init()
        
        self.blockPosition = blockPosition
        self.width = width
        
//        addBackground()
        setup()
    }
    
    private func addBackground() {
        // For testing purposes
        let blockBG = SKShapeNode(rectOf: CGSize(width: width, height: width))
        blockBG.fillColor = UIColor.randomHueFaded
        addChild(blockBG)
        blockBG.zPosition = -100
    }
    
    private func setup() {
        makeSoundBalls()
        makePlanks()
    }
    
    private func makeSoundBalls() {
        let nBalls = Int.random(in: 1...10)
        
        for _ in 0..<nBalls {
            let soundBall = SoundBall()
            soundBall.position = randomPositionInBlock
            addChild(soundBall)
        }
    }

    private func makePlanks() {
        let nPlanks = Int.random(in: 3...20)
        
        for _ in 0..<nPlanks {
            var plankSize: CGSize {
                let w = CGFloat.random(in: 200...600)
                let h: CGFloat = 25
                return CGSize(width: w, height: h)
            }
            
            let plank = Plank(size: plankSize, isRigid: true)
            plank.position = randomPositionInBlock
            addChild(plank)

            //Angled or Straight
            if Float.random(in: 0...1) < 0.2 {
                plank.zRotation = CGFloat.random(in: 0...CGFloat.pi)
            } else {
                plank.zRotation = Bool.random() ? 0 : .pi/2
            }
        }
    }
    
    private func makeBumpers() {
        let spacing: CGFloat = 320
        
        let hexagonPositions: [CGPoint] = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: spacing),
            CGPoint(x: spacing, y: -spacing*0.5),
            CGPoint(x: spacing, y: spacing*0.5),
            CGPoint(x: spacing, y: spacing*1.5),
            CGPoint(x: spacing*2, y: 0),
            CGPoint(x: spacing*2, y: spacing)
        ]
        
        hexagonPositions.forEach { pos in
            let bumper = Bumper()
            bumper.position = pos
            addChild(bumper)
        }
    }
    
    private func makeTriangles() {
        let nTirangles = Int.random(in: 3...10)
        
        for _ in 0..<nTirangles {
            let triangle = Triangle()
            triangle.position = randomPositionInBlock
            triangle.zRotation = CGFloat.random(in: 0...CGFloat.pi)
            addChild(triangle)
        }
    }
    
    private func makeStickyBalls() {
        let nBalls = Int.random(in: 3...10)
        
        for _ in 0..<nBalls {
            let stickyBall = StickyBall()
            stickyBall.position = randomPositionInBlock
            addChild(stickyBall)
        }
    }
    
    func checkForSoundBallsInView(heroPosition: CGPoint, screenSize: CGSize) {
        for child in children {
            guard let soundBall = child as? SoundBall else {
                continue
            }
            let ballToHero_X = soundBall.position.x + (position.x - heroPosition.x)
            let ballToHero_Y = soundBall.position.y + (position.y - heroPosition.y)
            
            if (-screenSize.width/2...screenSize.width/2).contains(ballToHero_X) &&
                (-screenSize.height/2...screenSize.height/2).contains(ballToHero_Y) {
                soundBall.soundIsActivated = true
            } else {
                soundBall.soundIsActivated = false
            }
        }
    }
}
