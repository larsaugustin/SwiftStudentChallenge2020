// Audio recognition view controller for page 2

import UIKit

public class Page2RecognitionResultViewController: UIViewController {

    var resultName: String {
        get { return resultLabel.text ?? "" }
        set { resultLabel.text = newValue }
    }

    lazy var titleLabel = UILabel()
    lazy var resultLabel = UILabel()
    lazy var stackView = UIStackView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        title = "Result"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didPressShare(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didPressDone))
        setupStackView()
    }

    func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        titleLabel.text = "Recognition Result:"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        stackView.addArrangedSubview(titleLabel)
        resultLabel.font = UIFont.systemFont(ofSize: 45, weight: .bold)
        stackView.addArrangedSubview(resultLabel)
        stackView.sizeToFit()
    }

    @objc func didPressShare(_ sender: UIBarButtonItem) {
        if !resultName.isEmpty {
            let activityViewController = UIActivityViewController(activityItems: [resultName], applicationActivities: nil)
            activityViewController.popoverPresentationController?.barButtonItem = sender
            present(activityViewController, animated: true, completion: nil)
        }
    }

    @objc func didPressDone() {
        dismiss(animated: true, completion: nil)
    }
}
