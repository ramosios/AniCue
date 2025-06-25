import XCTest
@testable import AniCue

final class MockSession: NetworkSession {
    var mockData: Data?
    var mockResponse: URLResponse?
    var error: Error?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error { throw error }
        return (mockData ?? Data(), mockResponse ?? HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!)
    }
}

final class JikanServiceTests: XCTestCase {
    var mockSession: MockSession!
    var service: JikanService!

    override func setUp() {
        super.setUp()
        mockSession = MockSession()
        service = JikanService(session: mockSession)
    }

    // MARK: - fetchAnime(by:)

    /// Verifies that valid JSON response correctly decodes into a JikanAnime instance
    func testFetchAnime_success() async throws {
        mockSession.mockData = """
        {
            "data": {
                "mal_id": 1,
                "title": "Cowboy Bebop",
                "type": "TV"
            }
        }
        """.data(using: .utf8)

        let anime = try await service.fetchAnime(by: 1)
        XCTAssertEqual(anime.title, "Cowboy Bebop")
    }

    /// Simulates malformed JSON and asserts that decodingFailed is thrown
    func testFetchAnime_decodingError() async {
        mockSession.mockData = Data("bad json".utf8)
        do {
            _ = try await service.fetchAnime(by: 1)
            XCTFail("Expected decodingFailed error")
        } catch let error as JikanAPIError {
            XCTAssertEqual(error, .decodingFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    /// Mocks a non-2xx HTTP response and ensures requestFailed is thrown
    func testFetchAnime_httpError() async {
        mockSession.mockData = Data()
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: "https://fail.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        do {
            _ = try await service.fetchAnime(by: 1)
            XCTFail("Expected requestFailed error")
        } catch let error as JikanAPIError {
            XCTAssertEqual(error, .requestFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - searchAnime(title:)

    /// Ensures successful search response is parsed into a list of JikanAnime
    func testSearchAnime_success() async throws {
        mockSession.mockData = """
        {
            "data": [
                { "mal_id": 2, "title": "Naruto", "type": "TV" },
                { "mal_id": 3, "title": "Bleach", "type": "TV" }
            ]
        }
        """.data(using: .utf8)

        let results = try await service.searchAnime(title: "Naruto")
        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results.first?.title, "Naruto")
    }

    /// Feeds invalid JSON and checks decodingFailed is triggered
    func testSearchAnime_decodingError() async {
        mockSession.mockData = Data("oops".utf8)
        do {
            _ = try await service.searchAnime(title: "invalid")
            XCTFail("Expected decodingFailed error")
        } catch let error as JikanAPIError {
            XCTAssertEqual(error, .decodingFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    /// Simulates a failed HTTP status code and confirms requestFailed is returned
    func testSearchAnime_requestFailed() async {
        mockSession.mockData = Data()
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: "https://fail.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        do {
            _ = try await service.searchAnime(title: "fail")
            XCTFail("Expected requestFailed error")
        } catch let error as JikanAPIError {
            XCTAssertEqual(error, .requestFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - fetchAnimes(for:)

    /// Provides multiple types of anime, ensures first TV anime is selected
    func testFetchAnimes_success_firstTVFound() async throws {
        mockSession.mockData = """
        {
            "data": [
                { "mal_id": 1, "title": "Death Note", "type": "TV" },
                { "mal_id": 2, "title": "Movie Example", "type": "Movie" }
            ]
        }
        """.data(using: .utf8)

        let results = try await service.fetchAnimes(for: ["Death Note"])
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, "Death Note")
    }

    /// Ensures fallback to first item if no TV anime is found
    func testFetchAnimes_success_firstFallback() async throws {
        mockSession.mockData = """
        {
            "data": [
                { "mal_id": 5, "title": "OVA Example", "type": "OVA" }
            ]
        }
        """.data(using: .utf8)

        let results = try await service.fetchAnimes(for: ["OVA Example"])
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, "OVA Example")
    }

    /// Simulates empty response and asserts serverError with "No anime found"
    func testFetchAnimes_noMatchThrows() async {
        mockSession.mockData = """
        { "data": [] }
        """.data(using: .utf8)

        do {
            _ = try await service.fetchAnimes(for: ["Empty"])
            XCTFail("Expected serverError for no anime found")
        } catch let error as JikanBatchError {
            guard case let .serverError(title, message) = error else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertEqual(title, "Empty")
            XCTAssert(message.contains("No anime found"))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    /// Tests JSON decoding failure for one of the titles and expects decodingError
    func testFetchAnimes_decodingError() async {
        mockSession.mockData = Data("invalid".utf8)
        do {
            _ = try await service.fetchAnimes(for: ["Bad"])
            XCTFail("Expected decodingError")
        } catch let error as JikanBatchError {
            guard case let .decodingError(title) = error else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertEqual(title, "Bad")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    /// Mocks HTTP error and confirms serverError is thrown with correct title
    func testFetchAnimes_httpError() async {
        mockSession.mockData = Data()
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: "https://fail.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        do {
            _ = try await service.fetchAnimes(for: ["Fail"])
            XCTFail("Expected serverError")
        } catch let error as JikanBatchError {
            guard case let .serverError(title, _) = error else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertEqual(title, "Fail")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

