import AudioKit

public class MelodyPlayer {

	var currentMelodyStep = 0
	private var melody = [1,1,5,5,6,6,5,4,4,3,3,2,2,1]

	func setMelody(_ melody: [Int]){
		self.melody = melody
	}

	func scaleDegreeToMidiNote(_ degree: Int, key: Int = 0) -> MIDINoteNumber? {
		if degree == 0 {
			print("scale degree was zero")
			return nil
		}

		return MusicConstants.majorScale[degree-1]
	}

	func getNoteOfMelody() -> MIDINoteNumber {

		let noteToReturn = scaleDegreeToMidiNote(melody[currentMelodyStep])!

		currentMelodyStep += 1
		if currentMelodyStep >= melody.count {
			currentMelodyStep = 0
		}
		return noteToReturn
	}
}
