import AudioKit

class SoundClips {
	private var clips = [SoundEffects: SoundEffect]()
	
	init(mixer: AKMixer) {
		SoundEffects.allCases.forEach { sound in
				clips[sound] = SoundEffect(
					fileName: sound.rawValue,
					volume: 1.0,
					mixer: mixer)
		}
	}
	
	func play(
		_ name: SoundEffects,
		note: MIDINoteNumber = 60,
		velocity: MIDIVelocity = 127,
		pan: Double = 0.0) {

		clips[name]!.sampler.pan = pan

		try! clips[name]!.sampler.play(
			noteNumber: note,
			velocity: velocity,
			channel: 1)
	}

	func play(_ name: SoundEffects,
								number: MIDINoteNumber,
								velocity: MIDIVelocity = 127) {

		clips[name]!.playNote(note: number, velocity: velocity)
	}
	
	func playRandomPitch(_ name: SoundEffects, noteRange: ClosedRange<Int> = 58...62,velocity: Int = 127) {
		clips[name]!.playRandomPitch(noteRange,velocity: velocity)
	}
	
	func playAtRandomIntervals(_ name: SoundEffects) {
		clips[name]!.playRandomIntervalAndPitch()
	}
	
	func stopSound(_ name: SoundEffects) {
		clips[name]!.stopReplaying()
	}
	
	func loopSoundEffect(_ name: SoundEffects) {
		clips[name]!.loop()
	}
	
	func stopLoopedSoundEffect(_ name: SoundEffects) {
		clips[name]!.stopLoop()
	}
}
