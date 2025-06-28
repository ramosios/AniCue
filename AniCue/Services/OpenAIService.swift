import Foundation

struct OpenAIService {
    private let apiKey: String
    private let session: URLSession
    private let endpoint: URL

    init(apiKey: String = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String ?? "",
         session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            fatalError("Invalid OpenAI endpoint URL")
        }
        self.endpoint = url
    }

    func fetchGenres(from prompt: String) async throws -> [Int] {
        let genreMap: [Int: String] = [
            1: "Action", 2: "Adventure", 3: "Cars", 4: "Comedy", 5: "Dementia", 6: "Demons", 7: "Mystery", 8: "Drama",
            9: "Ecchi", 10: "Fantasy", 11: "Game", 12: "Hentai", 13: "Historical", 14: "Horror", 15: "Kids", 16: "Magic",
            17: "Martial Arts", 18: "Mecha", 19: "Music", 20: "Parody", 21: "Samurai", 22: "Romance", 23: "School",
            24: "Sci-Fi", 25: "Shoujo", 26: "Shoujo Ai", 27: "Shounen", 28: "Shounen Ai", 29: "Space", 30: "Sports",
            31: "Super Power", 32: "Vampire", 33: "Harem", 34: "Slice of Life", 35: "Supernatural", 36: "Military",
            37: "Police", 38: "Psychological", 39: "Thriller", 40: "Seinen", 41: "Josei", 42: "Doujinshi", 43: "Gender Bender"
        ]

        let genreList = genreMap.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
        let query = """
        You are given this list of anime genres with IDs:
        \(genreList)

        Based on the user prompt: "\(prompt)"
        Return a JSON array (only) of up to 1 genre IDs that best match the prompt. Example: [1]
        Do not include any explanation, just the JSON array itself.
        """

        let response = try await sendPrompt(query, model: .gpt3_5, temperature: 0.5)
        return try extractJSONArray(from: response)
    }

    func recommendTopAnime(from animes: [JikanAnime], prompt: String) async throws -> [JikanAnime] {
        guard animes.count > 5 else { return animes }

        let titles = animes.prefix(20).map(\.title)
        let formattedTitles = titles.map { "- \($0)" }.joined(separator: "\n")
        let query = """
        Based on this user prompt: "\(prompt)"
        From this list of anime titles, select the top 5 that best match the prompt:

        \(formattedTitles)

        Return only a JSON array of the selected titles. Example: ["Naruto", "Bleach", "Haikyu!!"]
        """

        let response = try await sendPrompt(query, model: .gpt4, temperature: 0.4)
        let topTitles = try extractJSONArray(from: response, as: [String].self)

        return animes.filter { anime in
            topTitles.contains { $0.caseInsensitiveCompare(anime.title) == .orderedSame }
        }
    }

    // MARK: - Private Helpers

    private func sendPrompt(_ prompt: String, model: OpenAIModel, temperature: Double) async throws -> String {
        guard !apiKey.isEmpty else { throw OpenAIError.missingAPIKey }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": model.rawValue,
            "messages": [["role": "user", "content": prompt]],
            "temperature": temperature
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

        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func extractJSONArray<T: Decodable>(from text: String, as type: T.Type = [Int].self) throws -> T {
        let pattern = #"(?s)\[.*?\]"#
        guard let range = text.range(of: pattern, options: .regularExpression) else {
            throw OpenAIError.decodingFailed
        }

        let jsonString = String(text[range])
        guard let data = jsonString.data(using: .utf8) else {
            throw OpenAIError.decodingFailed
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}

extension OpenAIService: OpenAIServiceProtocol {}
