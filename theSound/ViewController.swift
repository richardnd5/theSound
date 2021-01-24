import UIKit
import SpriteKit

class ViewController: UIViewController {

    @IBOutlet weak var skView: SKView!
    
    override func viewDidLoad() {
		super.viewDidLoad()
                
        let gameScene = GameScene(size: CGSize(width: 750, height: 1530))
        gameScene.scaleMode = .aspectFill
        skView.presentScene(gameScene)
        skView.showsNodeCount = true
	}

	var count = 0
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for _ in touches {
//			Sound.shared.soundEffects.playRandomPitch(.marimbaC, noteRange: 48...72, velocity: Int.random(in: 20...120))
//			Sound.shared.playNoteOfMelody()

		}
	}
}


