// Main view controller for page 1

import UIKit

public class Page1ViewController: UIViewController {

    lazy var textView = UITextView()
    lazy var recordButton = UIButton()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Clear Voice"
        navigationItem.largeTitleDisplayMode = .always

        navigationController?.navigationBar.prefersLargeTitles = true
        setupTextView()
        setupRecordButton()
    }

    func setupTextView() {
        textView.isScrollEnabled = false
        textView.contentInset = UIEdgeInsets(top: 2, left: 16, bottom: 16, right: 16)
        textView.textColor = .label
        textView.isSelectable = false
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "This page uses various audio filters to make voices in recorded audio easier to hear. Press ”Record Audio“ and speak into the microphone. After taping ”Stop Recording“ a clearer version of the recorded audio will be played back. For people who are hard of hearing understanding dialog can be difficult. A way to clean up audio is very useful. Try it by speaking into the microphone while recording!"

        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func setupRecordButton() {
        recordButton.backgroundColor = .systemPink
        recordButton.setTitle("Record Audio", for: .normal)
        recordButton.addTarget(self, action: #selector(didPressRecord), for: .touchUpInside)
        recordButton.layer.cornerRadius = 15

        view.addSubview(recordButton)
        recordButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            recordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            recordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            recordButton.heightAnchor.constraint(equalToConstant: 60),
            recordButton.topAnchor.constraint(equalTo: textView.bottomAnchor)
        ])
    }

    @objc func didPressRecord() {
        let recordingViewController = AudioRecordingViewController()
        recordingViewController.completion = { url in
            let playbackViewController = PlaybackAudioViewController()
            playbackViewController.url = url
            self.navigationController?.show(playbackViewController, sender: self)
        }
        self.present(UINavigationController(rootViewController: recordingViewController), animated: true, completion: nil)
    }
}
