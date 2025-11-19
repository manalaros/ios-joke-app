import Foundation

/// Model representing a joke from the Official Joke API
public struct Joke: Codable, Identifiable {
    public let id: Int
    public let type: String
    public let setup: String
    public let punchline: String

    public init(id: Int, type: String, setup: String, punchline: String) {
        self.id = id
        self.type = type
        self.setup = setup
        self.punchline = punchline
    }
}
