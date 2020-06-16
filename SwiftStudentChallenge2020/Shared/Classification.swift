// Struct for classifications

public struct Classification: Codable {
    var name: String
    var primaryResult: Int
    var secondaryResult: Int?
    var delta: Int
}
