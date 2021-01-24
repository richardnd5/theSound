//
//  SoundBallMini.swift
//  theSound
//
//  Created by Jayson Coppo on 1/9/21.
//

import SpriteKit
import AudioKit

class SoundBallMini: SKNode {
    
    let radius: CGFloat = 15
    var outerColor: UIColor!
    var innerColor: UIColor!

    var rhythm = [Bool]()
    var noteNumber: MIDINoteNumber!
    
    init(innerColor: UIColor, outerColor: UIColor, rhythm: [Bool], noteNumber: MIDINoteNumber) {
        super.init()
        
        self.innerColor = innerColor
        self.outerColor = outerColor
        self.rhythm = rhythm
        self.noteNumber = noteNumber
        
        let outerCircle = SKShapeNode(circleOfRadius: radius)
        outerCircle.fillColor = outerColor
        outerCircle.lineWidth = 0
        addChild(outerCircle)
        
        let innerCrcle = SKShapeNode(circleOfRadius: radius*0.65)
        innerCrcle.fillColor = innerColor
        innerCrcle.lineWidth = 0
        addChild(innerCrcle)
    }
    
    func playBeat(beatIndex: Int) {
        guard beatIndex < rhythm.count else {
            return
        }
        
        if rhythm[beatIndex] {
            Sound.shared.soundEffects.play(.marimbaC, note: noteNumber, velocity: 60, pan: 0.5)
            pulse(to: 1.2)
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
