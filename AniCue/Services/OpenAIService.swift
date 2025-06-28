//
//  OpenAIService.swift
//  AniCue
//
//  Created by Jorge Ramos on 14/06/25.
//
import Foundation

struct OpenAIService {
    let apiKey: String
    let session: URLSession

    init(apiKey: String = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String ?? "",
         session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    func fetchGenres(from prompt: String) async throws -> [Int] {
        guard !apiKey.isEmpty else { throw OpenAIError.missingAPIKey }
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else { throw OpenAIError.invalidResponse }

        let genreMap: [Int: String] = [
            1: "Action", 2: "Adventure", 3: "Cars", 4: "Comedy", 5: "Dementia", 6: "Demons", 7: "Mystery", 8: "Drama", 9: "Ecchi",
            10: "Fantasy", 11: "Game", 12: "Hentai", 13: "Historical", 14: "Horror", 15: "Kids", 16: "Magic", 17: "Martial Arts", 18: "Mecha",
            19: "Music", 20: "Parody", 21: "Samurai", 22: "Romance", 23: "School", 24: "Sci-Fi", 25: "Shoujo", 26: "Shoujo Ai", 27: "Shounen",
            28: "Shounen Ai", 29: "Space", 30: "Sports", 31: "Super Power", 32: "Vampire", 33: "Harem", 34: "Slice of Life", 35: "Supernatural",
            36: "Military", 37: "Police", 38: "Psychological", 39: "Thriller", 40: "Seinen", 41: "Josei", 42: "Doujinshi", 43: "Gender Bender"
        ]

        let genreList = genreMap.map { "\($0.key): \($0.value)" }.joined(separator: ", ")

        let queryPrompt = """
        You are given this list of anime genres with IDs:
        \(genreList)

        Based on the user prompt: "\(prompt)"
        Return a JSON array (only) of up to 1 genre IDs that best match the prompt. Example: [1]
        Do not include any explanation, just the JSON array itself.
        """

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "gpt-4o",
            "messages": [["role": "user", "content": queryPrompt]],
            "temperature": 0.5
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await session.data(for: request)

        guard let httpResp = response as? HTTPURLResponse, (200...299).contains(httpResp.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw OpenAIError.serverError(message)
        }

        let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        guard let message = decoded.choices.first?.message.content else {
            throw OpenAIError.emptyChoices
        }

        let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)

        // Regex to extract JSON array from text
        let regex = try NSRegularExpression(pattern: "\\[(.*?)\\]", options: [])
        if let match = regex.firstMatch(in: trimmed, options: [], range: NSRange(location: 0, length: trimmed.utf16.count)) {
            let nsRange = match.range
            if let range = Range(nsRange, in: trimmed) {
                let jsonArray = String(trimmed[range])
                if let data = jsonArray.data(using: .utf8) {
                    return try JSONDecoder().decode([Int].self, from: data)
                }
            }
        }

        throw OpenAIError.decodingFailed
    }

    func recommendTopAnime(from animes: [JikanAnime], prompt: String) async throws -> [JikanAnime] {
        guard !apiKey.isEmpty else { throw OpenAIError.missingAPIKey }

        // Shortcut: if 5 or fewer animes, return them directly
        if animes.count <= 5 {
            return animes
        }

        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw OpenAIError.invalidResponse
        }

        let titles = animes.prefix(20).map(\.title)

        let fullPrompt = """
        Based on this user prompt: "\(prompt)"
        From this list of anime titles, select the top 5 that best match the prompt:

        \(titles.map { "- \($0)" }.joined(separator: "\n"))

        Return only a JSON array of the selected titles. Example: ["Naruto", "Bleach", "Haikyu!!"]
        """

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "gpt-4o",
            "messages": [["role": "user", "content": fullPrompt]],
            "temperature": 0.4
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await session.data(for: request)
        guard let httpResp = response as? HTTPURLResponse, (200...299).contains(httpResp.statusCode) else {
            throw OpenAIError.serverError(String(data: data, encoding: .utf8) ?? "Unknown error")
        }

        let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        guard let content = decoded.choices.first?.message.content else {
            throw OpenAIError.emptyChoices
        }

        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        let pattern = #"(?s)\[.*?\]"#
        guard let range = trimmed.range(of: pattern, options: .regularExpression) else {
            throw OpenAIError.decodingFailed
        }

        let jsonString = String(trimmed[range])
        guard let titleData = jsonString.data(using: .utf8) else {
            throw OpenAIError.decodingFailed
        }

        let topTitles = try JSONDecoder().decode([String].self, from: titleData)

        return animes.filter { anime in
            topTitles.contains { $0.caseInsensitiveCompare(anime.title) == .orderedSame }
        }
    }

    func fetchAnimeTitles(prompt: String, userPreferences: [String], excluding animesToAvoid: [Int]) async throws -> [String] {
        guard !apiKey.isEmpty else {
            throw OpenAIError.missingAPIKey
        }
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw OpenAIError.invalidResponse
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "gpt-4o",
            "messages": [["role": "user", "content": prompt]],
            "temperature": preferenceIntensity(from: userPreferences)
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await session.data(for: request)

        if let httpResp = response as? HTTPURLResponse, !(200...299).contains(httpResp.statusCode) {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw OpenAIError.serverError(message)
        }

        let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        guard let text = decoded.choices.first?.message.content else {
            throw OpenAIError.emptyChoices
        }

        return text
            .components(separatedBy: "\n")
            .compactMap { $0.components(separatedBy: ". ").last }
            .filter { !$0.isEmpty }
    }
}
extension OpenAIService: OpenAIServiceProtocol {}
