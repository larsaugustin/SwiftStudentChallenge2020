// Main sound classifier

import SoundAnalysis

public class AudioClassifier: NSObject {

    var classifications = [Classification]()
    var analysisResults = [AnalysisResult]()

    var usesRawMode = false

    var completion: (([Classification]) -> Void) = { _ in }
    var rawCompletion: (([AnalysisResult]) -> Void) = { _ in }

    func generateClassification(for url: URL) {
        let model = SwiftStudentChallengeClassifier()
        let fileAnalyzer = try? SNAudioFileAnalyzer(url: url)
        let request = try? SNClassifySoundRequest(mlModel: model.model)
        if request == nil || fileAnalyzer == nil { return }
        try? fileAnalyzer?.add(request!, withObserver: self)
        fileAnalyzer?.analyze()
    }


    func generateClassification(from results: [AnalysisResult]) -> Classification? {
        let sortedByConfidence = results.sorted{ $0.confidence > $1.confidence }
        if sortedByConfidence.count == 0 { return nil }
        var duplicates = [(AnalysisResult, Int)]()

        for result in results {
            let filteredResults = results.filter{ $0.result == result.result }
            if filteredResults.count > 1 && !duplicates.contains(where: { $0.0.result == result.result}) {
                let confidences = filteredResults.map{ $0.confidence }
                var newConfidence = 0
                confidences.forEach{ newConfidence += $0 }
                let newResult = AnalysisResult(result: result.result, confidence: Int(Double(newConfidence) * 0.75))
                duplicates.append((newResult, filteredResults.count))
            }
        }

        if !duplicates.contains(where: {$0.0.result == sortedByConfidence.first?.confidence }) {
            duplicates.insert((sortedByConfidence.first!, sortedByConfidence.first!.confidence), at: 0)
        }

        duplicates.sort(by: {$0.0.confidence > $1.0.confidence })
        let firstValue = duplicates.first!.0
        var secondValue: AnalysisResult? = nil
        if duplicates.count >= 2 {
            if duplicates[1].0.result != firstValue.result {
                secondValue = duplicates[1].0
            }
        }

        let delta = firstValue.confidence - (secondValue?.confidence ?? 0)
        return Classification(name: "New Classification", primaryResult: firstValue.result, secondaryResult: secondValue?.result, delta: delta)
    }

    func getClosestClassification(to input: Classification, from allClassifications: [Classification]) -> Classification {
        if allClassifications.count == 0 { return Classification(name: "Error: No patterns to recognize", primaryResult: 0, secondaryResult: 0, delta: 0)}

        let samePrimary = allClassifications.filter{ $0.primaryResult == input.primaryResult }
        if samePrimary.count > 1 {
            let sameSecondary = allClassifications.filter{ $0.secondaryResult == input.secondaryResult }
            if sameSecondary.count > 1 {
                if input.delta >= 50 {
                    return sameSecondary.first{ $0.delta > 50 } ?? sameSecondary[0]
                } else {
                    return sameSecondary.first{ $0.delta < 50 } ?? sameSecondary[0]
                }
            } else if sameSecondary.count == 1 {
                return sameSecondary[0]
            }
        } else if samePrimary.count == 1 {
            return samePrimary[0]
        }
        return Classification(name: "Error: Couldn't find pattern", primaryResult: 0, secondaryResult: 0, delta: 0)
    }
}
