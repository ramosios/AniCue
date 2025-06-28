import Foundation

protocol NetworkSession {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {}

struct JikanService {
    private let baseURL = "https://api.jikan.moe/v4"
    private let session: NetworkSession

    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    func fetchFilteredAnime(
        genreIds: [Int],
        excludedMalIds: [Int] = [],
        startDate: String,
        endDate: String,
        limit: Int = 25,
        page: Int = 1,
        minimumScore: Double = 7.0
    ) async throws -> [JikanAnime] {
        let genreQuery = genreIds.map(String.init).joined(separator: ",")
        let urlString = "\(baseURL)/anime?start_date=\(startDate)&end_date=\(endDate)&genres=\(genreQuery)&order_by=score&sort=desc&limit=\(limit)&page=\(page)"
        guard let url = URL(string: urlString) else { throw JikanAPIError.invalidURL }

        let (data, response) = try await session.data(from: url)
        guard let httpResp = response as? HTTPURLResponse, (200...299).contains(httpResp.statusCode) else {
            throw JikanAPIError.requestFailed
        }

        do {
            let decoded = try JSONDecoder().decode(JikanAnimeListResponse.self, from: data)
            return decoded.data.filter {
                !excludedMalIds.contains($0.malId) &&
                ($0.score ?? 0) >= minimumScore
            }
        } catch {
            throw JikanAPIError.decodingFailed
        }
    }
}

extension JikanService: JikanServiceProtocol {}

enum JikanAPIError: Error, LocalizedError, Equatable {
    case invalidURL
    case requestFailed
    case decodingFailed
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid Jikan API URL."
        case .requestFailed: return "Request to Jikan API failed."
        case .decodingFailed: return "Failed to decode Jikan API response."
        case .serverError(let message): return "Jikan API error: \(message)"
        }
    }
}

enum JikanBatchError: Error, LocalizedError {
    case invalidTitleURL(title: String)
    case serverError(title: String, message: String)
    case decodingError(title: String)
    case genericError(title: String, error: Error)

    var errorDescription: String? {
        switch self {
        case .invalidTitleURL(let title):
            return "Invalid URL for title: \(title)"
        case .serverError(let title, let message):
            return "Request failed for title \(title): \(message)"
        case .decodingError(let title):
            return "Decoding error for title: \(title)"
        case .genericError(let title, let error):
            return "Error fetching anime for title \(title): \(error.localizedDescription)"
        }
    }
}
