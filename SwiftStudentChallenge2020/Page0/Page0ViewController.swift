// Main view controller for page 0

import AVFoundation
import UIKit

public class Page0ViewController: UITableViewController {

    var engine: AVAudioEngine!
    var source: AVAudioSourceNode!

    lazy var leftSliderCell = UITableViewCell()
    lazy var rightSliderCell = UITableViewCell()
    lazy var currentValueCell = UITableViewCell()
    lazy var earsAgeCell = UITableViewCell()

    lazy var leftSlider = UISlider()
    lazy var rightSlider = UISlider()

    lazy var leftLabel = UILabel()
    lazy var rightLabel = UILabel()

    var frequencyRamp = Float.zero

    var currentFrequency: Float = 20 {
        didSet {
            if oldValue != 0 { frequencyRamp = currentFrequency - oldValue

            } else { frequencyRamp = 0 }
        }
    }

    var time = Float.zero

    var delta = Float.zero

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hearing Test"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        navigationController?.navigationBar.tintColor = .systemPink
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pause.fill"), style: .plain, target: self, action: #selector(didPressPlayPause))
        earsAgeCell.textLabel?.text = "Start by moving a slider"
        earsAgeCell.selectionStyle = .none
        setupAudioEngine()
        setupCurrentValueCell()
        setupSliderCell(cell: leftSliderCell, slider: leftSlider, image: UIImage(systemName: "hand.point.left.fill"))
        setupSliderCell(cell: rightSliderCell, slider: rightSlider, image: UIImage(systemName: "hand.point.right.fill"))
    }

    func setupSliderCell(cell: UITableViewCell, slider: UISlider, image: UIImage?) {
        slider.minimumValue = 20
        slider.maximumValue = 20000
        slider.minimumTrackTintColor = .systemPink
        slider.addTarget(self, action: #selector(sliderDidChange(_:)), for: .valueChanged)
        view.addSubview(slider)
        cell.selectionStyle = .none
        cell.contentView.addSubview(slider)
        cell.imageView?.image = image
        cell.imageView?.tintColor = .secondaryLabel
        slider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: cell.imageView!.trailingAnchor, constant: 16),
            slider.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            slider.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -16)
        ])
    }

    func setupCurrentValueCell() {
        currentValueCell.selectionStyle = .none
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal // :-)
        horizontalStackView.distribution = .fillEqually
        currentValueCell.addSubview(horizontalStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: currentValueCell.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: currentValueCell.trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: currentValueCell.topAnchor),
            horizontalStackView.heightAnchor.constraint(equalToConstant: 100),
            currentValueCell.heightAnchor.constraint(equalToConstant: 100)
        ])

        for item in [("Left", leftLabel), ("Right", rightLabel)] {
            let newStackView = UIStackView()
            newStackView.axis = .vertical
            let leftDescriptionLabel = UILabel()
            leftDescriptionLabel.text = item.0.uppercased()
            leftDescriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            leftDescriptionLabel.textColor = .secondaryLabel
            leftDescriptionLabel.transform = CGAffineTransform(translationX: 0, y: 17)
            newStackView.alignment = .center
            newStackView.distribution = .fillProportionally
            leftDescriptionLabel.sizeToFit()
            newStackView.addArrangedSubview(leftDescriptionLabel)
            item.1.text = "20"
            item.1.transform = CGAffineTransform(translationX: 0, y: -5)
            item.1.font = UIFont.monospacedDigitSystemFont(ofSize: 40, weight: .semibold)
            item.1.sizeToFit()
            newStackView.addArrangedSubview(item.1)
            newStackView.backgroundColor = .red
            horizontalStackView.addArrangedSubview(newStackView)
            newStackView.sizeToFit()

        }
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Frequency"
        } else if section == 1 {
            return "About"
        } else if section == 2 {
            return "You"
        }
        return nil
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 2
        }
        return 10
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return leftSliderCell
            } else {
                return rightSliderCell
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") ?? UITableViewCell()
            cell.textLabel?.text = "This page features a frequency-based hearing test. By knowing the maximum frequency you can hear, this test can roughly determine the age of your ears. Before starting, please make sure the device you’re using doesn’t have silent mode enabled. I also recommend using headphones. Start by removing the earbud from your right ear. You can then move the slider for the left ear until you can’t hear the tone anymore. Repeat this procedure with the right earbud in the right ear. Your frequencies and ear age will be displayed below this text."
            cell.textLabel?.numberOfLines = 100
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return currentValueCell
            } else if indexPath.row == 1 {
                return earsAgeCell
            }
        }
        return UITableViewCell()
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
