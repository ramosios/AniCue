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

    func fetchAnimeTitles(prompt: String, userPreferences: [String], excluding animesToAvoid: [Int]) async throws -> [String] {
        guard !apiKey.isEmpty else {
            throw OpenAIError.missingAPIKey
        }
        let fullPrompt = buildAnimePrompt(from: prompt, userPreferences: userPreferences, animesToAvoid: animesToAvoid)
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw OpenAIError.invalidResponse
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "gpt-4o",
            "messages": [["role": "user", "content": fullPrompt]],
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
    func buildAnimePrompt(from prompt: String, userPreferences: [String], animesToAvoid: [Int]) -> String {
        let rule1 = "Rule 1 : If user mentions a genre on the prompt only recommend animes from that genre"
        let rule2 = "Rule 2: You can only return 3 anime recommendations but you can have a prelimanary list of 6 and then choose from that the top 3 based on user preferences"
        let rule = rule1 + "\n" + rule2
        let preferenceText = formatPreferences(userPreferences)

        return "Recommend up to 3 anime for the following prompt just give anime title: \(prompt).\n\(preferenceText)\(rule)."
    }
}
extension OpenAIService: OpenAIServiceProtocol {}
