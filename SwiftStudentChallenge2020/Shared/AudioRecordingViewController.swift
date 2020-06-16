// Standard audio recording view controller

import UIKit
import AVFoundation

public class AudioRecordingViewController: UIViewController {

    var recodingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder?

    var completion: ((URL?) -> Void) = { _ in }
    var fileUrl: URL?

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recording…"

        navigationItem.largeTitleDisplayMode = .never

        fileUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("audio.caf")

        view.backgroundColor = .systemBackground

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        setupStopButton()
        beginRecording()
    }

    func setupStopButton() {
        let stopButton = UIButton()
        stopButton.backgroundColor = .systemPink
        stopButton.setTitle("Stop Recording", for: .normal)
        stopButton.addTarget(self, action: #selector(stopRecording), for: .touchUpInside)
        stopButton.layer.cornerRadius = 30

        view.addSubview(stopButton)
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stopButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopButton.heightAnchor.constraint(equalToConstant: 60),
            stopButton.widthAnchor.constraint(equalToConstant: 170)
        ])
    }

    func beginRecording() {
        recodingSession = AVAudioSession.sharedInstance()
        do {
            try recodingSession.setCategory(.playAndRecord)
            try recodingSession.setActive(true)
            AVAudioSession.sharedInstance().requestRecordPermission { allowed in
                if allowed {
                    self.startRecording()
                } else {
                    self.showUIError("Couldn't start recording: Permission was not granted")
                }
            }
        } catch {
            showUIError("Couldn't start audio engine: " + error.localizedDescription)
        }
    }

    func startRecording() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatAppleLossless),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVVideoQualityKey: AVAudioQuality.medium.rawValue
        ]

        if fileUrl == nil {
            showUIError("Couldn't start recording: No output url")
            return
        }
        do {
            audioRecorder = try AVAudioRecorder(url: fileUrl!, settings: settings)
            audioRecorder!.delegate = self
            audioRecorder!.record()
        } catch {
            showUIError("Couldn't start audio engine: " + error.localizedDescription)
        }
    }

    @objc func cancel() {
        audioRecorder = nil
        dismiss(animated: true, completion: nil)
    }

    @objc func stopRecording() {
        if audioRecorder != nil {
            audioRecorder!.stop()
            audioRecorder = nil
        }
    }

    func doneRecording() {
        dismiss(animated: true) {
            self.completion(self.fileUrl)
        }
    }

    func showUIError(_ text: String) {
        let alertController = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alertController.view.tintColor = .systemPink
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
}

extension AudioRecordingViewController: AVAudioRecorderDelegate {
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            doneRecording()
        } else {
            showUIError("Couldn't record audio.")
        }
    }
}
