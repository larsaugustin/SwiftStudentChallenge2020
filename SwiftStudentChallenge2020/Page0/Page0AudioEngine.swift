// Audio engine setup for page 0

import AVFoundation
import UIKit

extension Page0ViewController {

    @objc func didPressPlayPause() {
        if source.volume == 1.0 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "play.fill"), style: .plain, target: self, action: #selector(didPressPlayPause))
            source.volume = 0
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pause.fill"), style: .plain, target: self, action: #selector(didPressPlayPause))
            source.volume = 1.0
        }
    }

    func getWave(frequency: Float, time: Float) -> Float {
        sin(2.0 * .pi * frequency * time)
    }

    func setupAudioEngine() {
        engine = AVAudioEngine()
        source = AVAudioSourceNode(renderBlock: { (_, _, frameCount, bufferList) -> OSStatus in
            let listPointer = UnsafeMutableAudioBufferListPointer(bufferList)

            let rampValue = self.frequencyRamp
            let frequency = self.currentFrequency

            let period = 1 / frequency

            for frame in 0..<Int(frameCount) {
                let completion = self.time

                let sample = self.getWave(frequency: frequency + rampValue * completion, time: self.time)
                self.time += self.delta
                self.time = fmod(self.time, period)
                for buffer in listPointer {
                    let bufferPointer = UnsafeMutableBufferPointer<Float>(buffer)
                    bufferPointer[frame] = sample
                }
            }

            return noErr
        })

        let format = engine.outputNode.inputFormat(forBus: 0)
        let rate = format.sampleRate
        delta = 1 / Float(rate)
        let inputFormat = AVAudioFormat(commonFormat: format.commonFormat, sampleRate: format.sampleRate, channels: 1, interleaved: format.isInterleaved)

        engine.attach(source)
        engine.connect(source, to: engine.mainMixerNode, format: inputFormat)
        engine.connect(engine.mainMixerNode, to: engine.outputNode, format: nil)

        do {
            try engine.start()
        } catch {
            showUIError("Error while starting audio engine: " + error.localizedDescription)
        }
    }
}
