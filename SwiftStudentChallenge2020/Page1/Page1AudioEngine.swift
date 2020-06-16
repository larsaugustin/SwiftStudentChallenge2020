// Audio engine setup for page 1

import AVFoundation
import UIKit

extension PlaybackAudioViewController {
    @objc func didTapPause(_ sender: UIButton) {
        if player.isPlaying {
            player.pause()
            sender.setImage(UIImage(systemName: "play.fill")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            sender.setTitle("  Tap to play", for: .normal)
        } else {
            player.play()
            sender.setImage(UIImage(systemName: "pause.fill")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            sender.setTitle("  Tap to pause", for: .normal)
        }
    }

    func setupAudioEngine() {
        engine = AVAudioEngine()
        player = AVAudioPlayerNode()
        player.volume = 10

        try? AVAudioSession.sharedInstance().setCategory(.playback)

        guard let file = try? AVAudioFile(forReading: self.url) else {
            showUIError("Couldn't read file. Please record again.")
            return
        }
        let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length))
        if buffer == nil {
            showUIError("An error occurred while reading the buffer. Please try again.")
            return
        }
        try? file.read(into: buffer!)

        let eq = AVAudioUnitEQ()

        let parameters = eq.bands[0]
        parameters.filterType = .resonantLowPass
        parameters.frequency = 500
        parameters.bandwidth = 2
        parameters.gain = 4

        let pitch = AVAudioUnitTimePitch()
        pitch.pitch = 100
        pitch.overlap = 4

        engine.mainMixerNode.occlusion = -20

        engine.attach(player)
        engine.attach(eq)
        engine.attach(pitch)
        engine.connect(player, to: eq, format: buffer!.format)
        engine.connect(eq, to: pitch, format: buffer!.format)
        engine.connect(pitch, to: engine.mainMixerNode, format: buffer!.format)

        if let newFileURL = exportURL {
            guard let newFile = try? AVAudioFile(forWriting: newFileURL, settings: [:]) else {
                showUIError("Couldn't find audio file")
                return
            }
            eq.installTap(onBus: 0, bufferSize: AVAudioFrameCount(file.length), format: nil) { (newBuffer, time) in
                if newFile.length < file.length {
                    try? newFile.write(from: newBuffer)
                } else {
                    eq.removeTap(onBus: 0)
                    DispatchQueue.main.async {
                        self.shareButton.isEnabled = true
                    }
                }
            }
        }
        player.scheduleBuffer(buffer!, at: nil, options: AVAudioPlayerNodeBufferOptions.loops, completionHandler: nil)

        engine.prepare()
        try? engine.start()
        player.play()
    }
}
