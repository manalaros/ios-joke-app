import Foundation
import SwiftUI

@MainActor
public final class JokeViewModel: ObservableObject {
    @Published public private(set) var joke: Joke?
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var errorMessage: String?

    private let service: JokeService

    public init(service: JokeService = JokeService()) {
        self.service = service
    }

    /// Loads a joke from the service. Handles loading state and errors.
    public func loadJoke() async {
        // Prevent re-entrant calls while already loading
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            let newJoke = try await service.fetchJoke()
            withAnimation(.easeIn) {
                self.joke = newJoke
            }
        } catch let serviceError as JokeService.ServiceError {
            switch serviceError {
            case .badResponse:
                errorMessage = "Invalid server response."
            case .decodingError(let err):
                errorMessage = "Failed to process data: \(err.localizedDescription)"
            case .networkError(let err):
                errorMessage = "Network error: \(err.localizedDescription)"
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
