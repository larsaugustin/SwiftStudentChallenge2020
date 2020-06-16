// Age recognition for page 0

import UIKit

extension Page0ViewController {
    @objc func sliderDidChange(_ sender: UISlider) {
        currentFrequency = sender.value
        if sender == leftSlider {
            leftLabel.text = String(String(sender.value.rounded()).dropLast(2))
        } else if sender == rightSlider {
            rightLabel.text = String(String(sender.value.rounded()).dropLast(2))
        }

        let age = getAgeFor(frequency: (rightSlider.value + leftSlider.value) / 2)
        earsAgeCell.textLabel?.text = "Your ears are \(age) old"
    }

    func getAgeFor(frequency input: Float) -> String {
        switch input{
        case 0...4500:
            return "more than 100"
        case 4500...6000:
            return "more than 90"
        case 6000...7500:
            return "more than 80"
        case 7500...9000:
            return "more than 70"
        case 9000...11000:
            return "more than 60"
        case 11000...12500:
            return "more than 50"
        case 12500...14000:
            return "more than 40"
        case 14000...16000:
            return "more than 30"
        case 16000...17500:
            return "more than 20"
        case 17500...19000:
            return "more than 10"
        default:
            return "less than 10"
        }
    }
}
