import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	var count = 0
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for _ in touches {
			Sound.shared.soundEffects.playRandomPitch(.marimbaC, noteRange: 48...72, velocity: Int.random(in: 20...120))
		}
	}
}

