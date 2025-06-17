// OpenAIServiceTests.swift

import XCTest
@testable import AniCue

// MARK: - Mock URLProtocol

final class MockURLProtocol: URLProtocol {
    static var responseData: Data?
    static var responseCode: Int = 200

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let response = HTTPURLResponse(url: request.url!,
                                       statusCode: Self.responseCode,
                                       httpVersion: nil,
                                       headerFields: nil)!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        if let data = Self.responseData {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

// MARK: - Tests

final class OpenAIServiceTests: XCTestCase {

    func makeMockSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }

    func testFetchAnimeTitles_ReturnsParsedTitles() async throws {
        let mockResponse = """
        {
          "choices": [{
            "message": {
              "role": "assistant",
              "content": "1. Naruto\\n2. One Piece\\n3. Death Note"
            }
          }]
        }
        """
        MockURLProtocol.responseData = mockResponse.data(using: .utf8)
        MockURLProtocol.responseCode = 200

        let service = OpenAIService(apiKey: "dummy", session: makeMockSession())
        let result = try await service.fetchAnimeTitles(prompt: "", userPreferences: [], excluding: [])
        XCTAssertEqual(result, ["Naruto", "One Piece", "Death Note"])
    }

    func testFetchAnimeTitles_ThrowsEmptyChoices() async {
        let emptyResponse = """
        {
          "choices": []
        }
        """
        MockURLProtocol.responseData = emptyResponse.data(using: .utf8)
        MockURLProtocol.responseCode = 200

        let service = OpenAIService(apiKey: "dummy", session: makeMockSession())
        do {
            _ = try await service.fetchAnimeTitles(prompt: "", userPreferences: [], excluding: [])
            XCTFail("Expected error, but got success")
        } catch {
            XCTAssertEqual(error as? OpenAIError, .emptyChoices)
        }
    }

    func testFetchAnimeTitles_ThrowsDecodingError() async {
        MockURLProtocol.responseData = "invalid json".data(using: .utf8)
        MockURLProtocol.responseCode = 200

        let service = OpenAIService(apiKey: "dummy", session: makeMockSession())
        do {
            _ = try await service.fetchAnimeTitles(prompt: "", userPreferences: [], excluding: [])
            XCTFail("Expected decoding error")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }

    func testFetchAnimeTitles_ThrowsServerError() async {
        let errorBody = "Some server error"
        MockURLProtocol.responseData = errorBody.data(using: .utf8)
        MockURLProtocol.responseCode = 500

        let service = OpenAIService(apiKey: "dummy", session: makeMockSession())
        do {
            _ = try await service.fetchAnimeTitles(prompt: "", userPreferences: [], excluding: [])
            XCTFail("Expected server error")
        } catch {
            if case let OpenAIError.serverError(message) = error {
                XCTAssertTrue(message.contains("Some server error"))
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        }
    }
}

