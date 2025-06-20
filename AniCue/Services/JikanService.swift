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

    func fetchAnimes(for titles: [String]) async throws -> [JikanAnime] {
        var all: [JikanAnime] = []

        for title in titles {
            let encoded = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            guard let url = URL(string: "\(baseURL)/anime?q=\(encoded)&limit=5") else {
                throw JikanBatchError.invalidTitleURL(title: title)
            }

            do {
                let (data, response) = try await URLSession.shared.data(from: url)

                if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                    throw JikanBatchError.serverError(title: title, message: message)
                }

                let result = try JSONDecoder().decode(JikanAnimeListResponse.self, from: data)

                if let firstTV = result.data.first(where: { $0.type == "TV" }) {
                    all.append(firstTV)
                } else if let first = result.data.first {
                    all.append(first)
                } else {
                    throw JikanBatchError.serverError(title: title, message: "No anime found")
                }

            } catch is DecodingError {
                throw JikanBatchError.decodingError(title: title)
            } catch {
                throw JikanBatchError.genericError(title: title, error: error)
            }
        }

        return all
    }
}
