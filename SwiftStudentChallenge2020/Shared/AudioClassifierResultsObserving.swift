// Sound analysis functions

import SoundAnalysis

extension AudioClassifier: SNResultsObserving {
    public func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let classificationResult = result as? SNClassificationResult else { return }
        let results = classificationResult.classifications
            .filter{ Int($0.identifier) != nil }
            .map{ AnalysisResult(result: Int($0.identifier)!, confidence: Int($0.confidence * 100))}
        if !usesRawMode {
            if let classification = generateClassification(from: results) {
                classifications.append(classification)
            }
        } else {
            analysisResults.append(contentsOf: results)
        }
    }

    public func request(_ request: SNRequest, didFailWithError error: Error) {
        // Finish anyways
        if !usesRawMode {
            if classifications.count != 0 {
                completion(classifications)
            }
        } else {
            rawCompletion(analysisResults)
        }
    }

    public func requestDidComplete(_ request: SNRequest) {
        if !usesRawMode {
            completion(classifications)
        } else {
            rawCompletion(analysisResults)
        }
    }
}
