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
            1: "Action", 2: "Adventure", 5: "Avant Garde", 46: "Award Winning", 28: "Boys Love", 4: "Comedy", 8: "Drama",
            10: "Fantasy", 26: "Girls Love", 47: "Gourmet", 14: "Horror", 7: "Mystery", 22: "Romance", 24: "Sci-Fi",
            36: "Slice of Life", 30: "Sports", 37: "Supernatural", 41: "Suspense", 9: "Ecchi", 49: "Erotica", 12: "Hentai",
            50: "Adult Cast", 51: "Anthropomorphic", 52: "CGDCT", 53: "Childcare", 54: "Combat Sports", 81: "Crossdressing",
            55: "Delinquents", 39: "Detective", 56: "Educational", 57: "Gag Humor", 58: "Gore", 35: "Harem", 59: "High Stakes Game",
            13: "Historical", 60: "Idols (Female)", 61: "Idols (Male)", 62: "Isekai", 63: "Iyashikei", 64: "Love Polygon",
            65: "Magical Sex Shift", 66: "Mahou Shoujo", 17: "Martial Arts", 18: "Mecha", 67: "Medical", 38: "Military",
            19: "Music", 6: "Mythology", 68: "Organized Crime", 69: "Otaku Culture", 20: "Parody", 70: "Performing Arts",
            71: "Pets", 40: "Psychological", 3: "Racing", 72: "Reincarnation", 73: "Reverse Harem", 74: "Love Status Quo",
            21: "Samurai", 23: "School", 75: "Showbiz", 29: "Space", 11: "Strategy Game", 31: "Super Power", 76: "Survival",
            77: "Team Sports", 78: "Time Travel", 32: "Vampire", 79: "Video Game", 80: "Visual Arts", 48: "Workplace",
            82: "Urban Fantasy", 83: "Villainess", 43: "Josei", 15: "Kids", 42: "Seinen", 25: "Shoujo", 27: "Shounen"
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
}
extension OpenAIService: OpenAIServiceProtocol {}
