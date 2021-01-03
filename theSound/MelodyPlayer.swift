//
//  MelodyPlayer.swift
//  theSound
//
//  Created by N Richard on 1/3/21.
//

import AudioKit

public class MelodyPlayer {

	var currentMelodyStep = 0
	let melody = [1,1,5,5,6,6,5,4,4,3,3,2,2,1]

	func scaleDegreeToMidiNote(_ degree: Int, key: Int = 0) -> MIDINoteNumber? {
		if degree == 0 {
			print("scale degree was zero")
			return nil
		}

		return MusicConstants.majorScale[degree-1]
	}

	func playNoteOfMelody() {
		let midiNote = scaleDegreeToMidiNote(melody[currentMelodyStep])!

		Sound.shared.soundEffects.play(.marimbaC, number: midiNote, velocity: 120)
		currentMelodyStep += 1
		if currentMelodyStep >= melody.count {
			currentMelodyStep = 0
		}
	}
}