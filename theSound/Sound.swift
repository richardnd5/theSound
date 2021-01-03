import AudioKit

public struct Sound {

	static var shared = Sound()
	var soundEffects: SoundClips!
	private var soundEffectMixer = AKMixer()
	private let mainMixer = AKMixer()
	private var reverb: AKReverb?

	var melodyPlayer = MelodyPlayer()

	//MARK: Setup
	mutating func setup(){

		soundEffects = SoundClips(mixer: soundEffectMixer)
		reverb = AKReverb(soundEffectMixer)
		reverb?.dryWetMix = 0.8

		mainMixer.connect(input: soundEffectMixer)
		mainMixer.connect(input: reverb)

	}
}

//MARK: Play Sounds
extension Sound {

	mutating func playNoteOfMelody() {
		melodyPlayer.playNoteOfMelody()
	}

	mutating func playMarimba(note: Int, velocity: Int = 127){
		soundEffects.play(
			.marimbaC,
			note: MIDINoteNumber(note),
			velocity: MIDIVelocity(velocity))
	}

	mutating func readText(text: String){
		let speechSynthesizer = AVSpeechSynthesizer()
		let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
		speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
		speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-UK")
		speechUtterance.volume = 0.2
		speechSynthesizer.speak(speechUtterance)
	}
}

extension Sound {
	mutating func startAudioKit(){
		do {
			try AVAudioSession
				.sharedInstance()
				.setCategory(
					.playback,
					mode: .default,
					options: [])
		} catch let error {
			print("Error in AVAudio Session\(error.localizedDescription)")
		}

		AKSettings.playbackWhileMuted = true
		AKManager.output = mainMixer

		do { try AKManager.start() }
		catch {
			print("Couldn't start AudioKit. Here's Why: \(error)")
		}

		setup()
	}


	func stopAudioKit(){
		do {
			try AKManager.stop()
		} catch {
			print("Couldn't start AudioKit. Here's Why: \(error)")
		}
	}
}



