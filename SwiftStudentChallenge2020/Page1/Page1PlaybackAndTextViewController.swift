// Processed audio playback view controller for page 2

import UIKit
import AVKit

public class PlaybackAudioViewController: UIViewController {

    var url: URL!
    let exportURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("processed.aif")

    lazy var stackView = UIStackView()
    lazy var bottomStackView = UIStackView()
    lazy var textView = UITextView()
    lazy var playButton = UIButton()
    lazy var toolbar = UIToolbar()

    let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(didPressShare))
    var engine: AVAudioEngine!
    var player: AVAudioPlayerNode!

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Playback"
        navigationItem.largeTitleDisplayMode = .never

        view.backgroundColor = .systemBackground

        stackView.axis = .vertical
        stackView.distribution = .fillEqually

        setupToolbar()
        setupPlayButton()
        setupTextView()
        setupAudioEngine()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

    func setupToolbar() {
        shareButton.isEnabled = false
        toolbar.tintColor = .systemPink
        toolbar.items = [shareButton]
        view.addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupTextView() {
        textView.tintColor = .systemPink
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isEditable = false
        textView.isSelectable = false
        stackView.addArrangedSubview(textView)

        textView.text = "You should now be able to hear a clearer version of the recorded audio. If not, disable silent mode on your device. Various filters improve the audio in realtime. You can even save the recording by pressing the share button below. As described before, people who are hard of hearing can have an easier time understanding a cleaned-up version like this."
        view.addSubview(stackView)
    }

    func setupPlayButton() {
        playButton.setImage(UIImage(systemName: "pause.fill")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        playButton.setTitle("  Tap to pause", for: .normal)
        playButton.addTarget(self, action: #selector(didTapPause(_:)), for: .touchUpInside)
        playButton.setTitleColor(.label, for: .normal)
        playButton.tintColor = .systemPink
        playButton.backgroundColor = .secondarySystemBackground
        stackView.addArrangedSubview(playButton)
    }

    @objc func didPressShare() {
        if exportURL != nil {
            let activityController = UIActivityViewController(activityItems: [exportURL!], applicationActivities: nil)
            activityController.popoverPresentationController?.barButtonItem = shareButton
            present(activityController, animated: true, completion: nil)
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
