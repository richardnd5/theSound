import AudioKit

class BackgroundAudio: AKMIDISampler {
	private var audioFile: AKAudioFile!
	var randomIntervalTimer = Timer()

	var loopTimer = Timer()

	override init() {
		super.init(midiOutputName: "sampler")
		audioFile = loadAudioFile("background")
		setupSampler()
	}

	private func loadAudioFile(_ name: String) -> AKAudioFile {
		let path = Bundle.main.url(forResource: name, withExtension: "mp3")
		var file: AKAudioFile!
		do {
			try file = AKAudioFile(forReading: path!)
		} catch {
			print("didn't load the audio file. Why? \(error)")
		}
		return file
	}

	func setupSampler() {
		do { try loadAudioFile(audioFile!) } catch { print("Couldn't load the audio file. Here's why:     \(error)") }
		enableMIDI()
		volume = 0.85
	}

	func turnDownSound() {
		volume = 0.4
	}

	func turnUpSound() {
		volume = 0.75
	}

	func playLoop() {
		do { try play(noteNumber: 60, velocity: 127, channel: 1) } catch { print("couldn't play the note. Why? Here:  \(error)") }

		let audioLength = audioFile.duration - 2
		loopTimer = Timer.scheduledTimer(withTimeInterval: audioLength, repeats: false, block: { _ in self.playLoop() })
	}

	func stopLoop() {
		loopTimer.invalidate()
		do { try stop(noteNumber: 60, channel: 1) } catch { print("couldn't stop pond loop. Here's why: \(error)") }
	}
}
