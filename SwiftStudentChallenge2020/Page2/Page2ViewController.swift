// Main view controller for page 2

import UIKit

public class Page2ViewController: UITableViewController {

    var sounds = [Classification]()

    public override func viewDidLoad() {
        super.viewDidLoad()
        loadSounds()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemPink
        title = "Recognition"
        tableView.contentInset.bottom = 76
        view.backgroundColor = .systemGroupedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAdd))
        setupClassifyButton()
    }

    func loadSounds() {
        guard let defaultsData = UserDefaults.standard.data(forKey: "hearingUtilities.sounds") else { return }
        let decoder = JSONDecoder()
        if let result = try? decoder.decode([Classification].self, from: defaultsData) {
            sounds.append(contentsOf: result)
        }
    }

    func insertNew(classification: Classification) {
        sounds.insert(classification, at: 0)
        tableView.insertRows(at: [IndexPath(item: 0, section: 1)], with: .automatic)
        saveSounds()
    }

    func saveSounds() {
        let jsonEncoder = JSONEncoder()
        if let result = try? jsonEncoder.encode(sounds) {
            UserDefaults.standard.set(result, forKey: "hearingUtilities.sounds")
        }
    }

    func setupClassifyButton() {
        guard let navigationView = navigationController?.view else { return }
        let classifyButton = UIButton()
        classifyButton.setTitle("Recognize Sound", for: .normal)
        classifyButton.addTarget(self, action: #selector(didPressClassify), for: .touchUpInside)
        classifyButton.backgroundColor = .systemPink
        classifyButton.layer.cornerRadius = 30
        navigationView.addSubview(classifyButton)
        classifyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            classifyButton.centerXAnchor.constraint(equalTo: navigationView.centerXAnchor),
            classifyButton.bottomAnchor.constraint(equalTo: navigationView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            classifyButton.heightAnchor.constraint(equalToConstant: 60),
            classifyButton.widthAnchor.constraint(equalToConstant: 180)
        ])
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : sounds.count
    }

    public override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 { return nil }
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.sounds.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            self?.saveSounds()
        }
        deleteAction.backgroundColor = UIColor.systemPink

        return UISwipeActionsConfiguration(actions: [deleteAction])

    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") ?? UITableViewCell()
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            cell.imageView?.image = nil
            cell.textLabel?.text = "This page allows you to teach the playground certain sounds that it will then recognize. For people who are hard of hearing it can sometimes be hard to differentiate between multiple (quieter) sounds. On this page, you can train the playground to differentiate between sounds. After tapping ”+“ you will need to record a sound three times. You can then give it a name. To start, I recommend teaching it to recognize the difference between saying the word ”Apple“ and blowing into the microphone. After recording more than one sound, you can press recognize to classify a recording."
            cell.textLabel?.numberOfLines = 100
        } else {
            cell.imageView?.image = UIImage(systemName: "waveform")
            cell.imageView?.tintColor = .systemPink
            cell.textLabel?.text = sounds[indexPath.row].name
        }
        return cell
    }

    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sounds.isEmpty { return nil }
        return section == 0 ? nil : "Registered Sounds"
    }

    @objc func didPressAdd() {
        let newViewController = Page2NewViewController()
        newViewController.completion = { classification in
            self.insertNew(classification: classification)
        }
        present(UINavigationController(rootViewController: newViewController), animated: true, completion: nil)
    }

    @objc func didPressClassify() {
        let recordingViewController = AudioRecordingViewController()
        recordingViewController.completion = { url in
            guard let newUrl = url else {
                self.showUIError("Please record again.")
                return
            }
            self.classify(url: newUrl)
        }
        self.present(UINavigationController(rootViewController: recordingViewController), animated: true, completion: nil)
    }


    func classify(url input: URL) {
        let classifier = AudioClassifier()
        classifier.usesRawMode = true
        classifier.rawCompletion = { result in
            if let generalClassification = classifier.generateClassification(from: result) {
                let closestClassification = classifier.getClosestClassification(to: generalClassification, from: self.sounds)
                let resultViewController = Page2RecognitionResultViewController()
                resultViewController.resultName = closestClassification.name
                self.present(UINavigationController(rootViewController: resultViewController), animated: true, completion: nil)
            }
        }
        classifier.generateClassification(for: input)
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
