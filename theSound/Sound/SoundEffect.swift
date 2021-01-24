import AudioKit

class SoundEffect {
	private var audioFile: AKAudioFile!
  var sampler: AKMIDISampler!
	private var randomIntervalTimer = Timer()
	
	private var name: String!
	private var volume: Double!
	private var firstTime = true
	
	init(fileName: String, volume: Double = 1.0, mixer: AKMixer? = nil) {
		sampler = AKMIDISampler(midiOutputName: "sampler")
		self.volume = volume
		audioFile = loadAudioFile("\(fileName)")
		setupSampler(mixer: mixer)
		name = fileName
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
	
	private func setupSampler(mixer: AKMixer?) {
		do {
			try sampler.loadAudioFile(audioFile!)
		} catch {
			print("Couldn't load the audio file. Here's why:     \(error)")
		}
		sampler.enableMIDI()
		sampler.volume = volume
		
		if let mixer = mixer {
			sampler.connect(to: mixer)
		}
	}
	
	func play() {
		do {
			try sampler.play(noteNumber: 60, velocity: 100, channel: 1)
		} catch {
			print("couldn't play the note. Why? Here:  \(error)")
		}
	}
	
	func playRandomPitch(_ range: ClosedRange<Int>, velocity: Int) {
		let randomNote = MIDINoteNumber.random(in: MIDINoteNumber(range.lowerBound)...MIDINoteNumber(range.upperBound))
		do {
			try sampler.play(noteNumber: randomNote, velocity: MIDIVelocity(velocity), channel: 1)
		} catch {
			print("couldn't play the note. Why? Here:  \(error)")
		}
	}

	func playNote(note: MIDINoteNumber, velocity: MIDIVelocity) {
		do {
			try sampler.play(noteNumber: note, velocity: velocity, channel: 1)
		} catch {
			print("couldn't play the note. Why? Here:  \(error)")
		}
	}
	
	private var setInterval = Timer()
	private var firstLoop = true
	
	func loop() {
		setInterval.invalidate()
		sampler.volume = volume
		if firstLoop {
			firstLoop = false
			do {
				try sampler.play(noteNumber: 60, velocity: 127, channel: 1)
			} catch {
				print("couldn't play the note. Why? Here:  \(error)")
			}
		}
		let length = audioFile.duration
		setInterval = Timer.scheduledTimer(withTimeInterval: length, repeats: false, block: { _ in
			do {
				try self.sampler.play(noteNumber: 60, velocity: 127, channel: 1)
			} catch {
				print("couldn't play the note. Why? Here:  \(error)")
			}
			self.loop()
		})
	}
	
	func stopLoop() {
		sampler.volume = 0.0
		setInterval.invalidate()
		do {
			try sampler.stop(noteNumber: 60, channel: 1)
		} catch {
			print("couldn't stop the sampler. Why? \(error)")
		}
		firstLoop = true
	}
	
	func playRandomIntervalAndPitch() {
		if firstTime {
			firstTime = false
			do {
				try sampler.play(noteNumber: 60, velocity: 127, channel: 1)
			} catch {
				print("couldn't play the note. Why? Here:  \(error)")
			}
		}
		let randTimeInterval = TimeInterval.random(in: 0.3 ... 0.6)
		randomIntervalTimer = Timer.scheduledTimer(withTimeInterval: randTimeInterval, repeats: false, block: { _ in
			let randomPitch = MIDINoteNumber.random(in: 54 ... 70)
			let randVel = MIDIVelocity.random(in: 80 ... 127)
			do {
				try self.sampler.play(noteNumber: randomPitch, velocity: randVel, channel: 1) } catch { print("couldn't play the note. Why? Here:  \(error)")
				}
			self.playRandomIntervalAndPitch()
		})
	}
	
	func stopReplaying() {
		randomIntervalTimer.invalidate()
		firstTime = true
	}
}
