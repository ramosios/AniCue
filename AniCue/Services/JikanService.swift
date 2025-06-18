import Foundation

enum JikanAPIError: Error, LocalizedError {
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

struct JikanService {
    private let baseURL = "https://api.jikan.moe/v4"

    func fetchAnime(by id: Int) async throws -> JikanAnime {
        let urlString = "\(baseURL)/anime/\(id)"
        guard let url = URL(string: urlString) else { throw JikanAPIError.invalidURL }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResp = response as? HTTPURLResponse, (200...299).contains(httpResp.statusCode) else {
            throw JikanAPIError.requestFailed
        }

        do {
            let decoded = try JSONDecoder().decode(JikanAnimeResponse.self, from: data)
            return decoded.data
        } catch {
            throw JikanAPIError.decodingFailed
        }
    }

    func searchAnime(title: String) async throws -> [JikanAnime] {
        let query = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)/anime?q=\(query)&limit=10"
        guard let url = URL(string: urlString) else { throw JikanAPIError.invalidURL }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResp = response as? HTTPURLResponse, (200...299).contains(httpResp.statusCode) else {
            throw JikanAPIError.requestFailed
        }

        do {
            let decoded = try JSONDecoder().decode(JikanAnimeListResponse.self, from: data)
            return decoded.data
        } catch {
            throw JikanAPIError.decodingFailed
        }
    }
}
