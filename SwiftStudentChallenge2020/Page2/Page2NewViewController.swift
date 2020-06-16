// New pattern view controller for page 2

import UIKit

public class Page2NewViewController: UIViewController {

    lazy var stackView = UIStackView()
    lazy var soundButtons = [UIButton(), UIButton(), UIButton()]
    lazy var analysisResults = [AnalysisResult]()
    var completions = [Int]()

    var completion: ((Classification) -> Void) = { _ in }

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Train"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didPressCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didPressDone))
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        setupButtons()
    }

    func setupButtons() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        soundButtons.forEach { button in
            button.setImage(UIImage(systemName: "music.mic"), for: .normal)
            button.setTitle("Tap to record sound", for: .normal)
            button.setTitleColor(.label, for: .normal)
            button.tintColor = .systemPink
            button.addTarget(self, action: #selector(didPressRecord(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }

    @objc func didPressCancel() {
        dismiss(animated: true, completion: nil)
    }

    @objc func didPressDone() {
        let alertController = UIAlertController(title: "Add Name", message: "Give your sound a name. This name will be displayed if the sound is recognized.", preferredStyle: .alert)
        alertController.addTextField { field in
            field.placeholder = "Name"
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            alertController.dismiss(animated: true, completion: nil)
        }))
        let classifier = AudioClassifier()
        let classification = classifier.generateClassification(from: analysisResults)
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            self.dismiss(animated: true) {
                if var newClassification = classification {
                    newClassification.name = alertController.textFields?.first?.text ?? "Untitled Sound"
                    self.completion(newClassification)
                }
            }
        }))
        alertController.view.tintColor = .systemPink
        present(alertController, animated: true, completion: nil)
    }

    @objc func didPressRecord(_ sender: UIButton) {
        let recordingViewController = AudioRecordingViewController()
        recordingViewController.completion = { newUrl in
            self.classifyUrl(newUrl, sender: sender)
        }
        present(UINavigationController(rootViewController: recordingViewController), animated: true, completion: nil)
    }


    func classifyUrl(_ url: URL?, sender: UIButton) {
        if url == nil { return }
        let classifier = AudioClassifier()
        classifier.usesRawMode = true
        classifier.rawCompletion = { result in
            sender.isEnabled = false
            sender.setTitle("Recorded!", for: .normal)
            self.analysisResults.append(contentsOf: result)
            self.completions.append(0)

            if self.completions.count == 3 {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
        classifier.generateClassification(for: url!)
    }
}
