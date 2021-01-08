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
        case planks, bumpers, triangles, stickyBall
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
        let blockBG = SKShapeNode(rectOf: CGSize(width: width, height: width))
        blockBG.fillColor = UIColor.randomHueFaded
        addChild(blockBG)
        blockBG.zPosition = -100
    }
    
    private func setup() {
        let worldType = WorldType.allCases.randomElement()
        
        switch worldType {
        case .planks:
            makePlanks()
        case .bumpers:
            makeBumpers()
        case .triangles:
            makeTriangles()
        case .stickyBall:
            makeStickyBalls()
        case .none:
            return
        }
    }

    private func makePlanks() {
        let nPlanks = Int.random(in: 3...20)
        
        for _ in 0..<nPlanks {
            var plankSize: CGSize {
                let w = CGFloat.random(in: 150...500)
                let h: CGFloat = 25
                return CGSize(width: w, height: h)
            }
            
            let isRigid = Bool.random()
            let plank = Plank(size: plankSize, isRigid: isRigid)
            plank.position = randomPositionInBlock
            addChild(plank)

            //Angled or Straight
            if Bool.random() {
                plank.zRotation = CGFloat.random(in: 0...CGFloat.pi)
            } else {
                plank.zRotation = Bool.random() ? 0 : .pi/2
            }
        }
    }
    
    private func makeBumpers() {
        let nBumpers = Int.random(in: 3...10)
        
        for _ in 0..<nBumpers {
            let bumper = Bumper()
            bumper.position = randomPositionInBlock
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
}
