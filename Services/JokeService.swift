import Foundation

/// Service responsible for fetching a `Joke` from the Official Joke API
public final class JokeService {
    public enum ServiceError: Error {
        case badResponse
        case decodingError(Error)
        case networkError(Error)
    }

    private let url: URL
    private let session: URLSession

    public init(url: URL = URL(string: "https://official-joke-api.appspot.com/random_joke")!, session: URLSession = .shared) {
        self.url = url
        self.session = session
    }

    /// Fetch a random joke asynchronously
    public func fetchJoke() async throws -> Joke {
        do {
            let (data, response) = try await session.data(from: url)

            guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
                throw ServiceError.badResponse
            }

            do {
                let decoder = JSONDecoder()
                return try decoder.decode(Joke.self, from: data)
            } catch {
                throw ServiceError.decodingError(error)
            }
        } catch {
            throw ServiceError.networkError(error)
        }
    }
}
