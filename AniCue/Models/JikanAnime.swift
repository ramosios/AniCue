import Foundation

struct JikanAnimeResponse: Codable {
    let data: JikanAnime
}

struct JikanAnimeListResponse: Codable {
    let data: [JikanAnime]
}

struct JikanAnime: Codable {
    let malId: Int
    let title: String
    let titleEnglish: String?
    let titleJapanese: String?
    let titleSynonyms: [String]?
    let synopsis: String?
    let type: String?
    let episodes: Int?
    let duration: String?
    let status: String?
    let score: Double?
    let rank: Int?
    let popularity: Int?
    let members: Int?
    let favorites: Int?
    let images: [String: JikanImage]?
    let trailer: JikanTrailer?
    let aired: AiredPeriod?
    let studios: [JikanEntity]?
    let producers: [JikanEntity]?
    let licensors: [JikanEntity]?
    let genres: [JikanEntity]?
    let themes: [JikanEntity]?
    let demographics: [JikanEntity]?
    let source: String?
    let broadcast: JikanBroadcast?
    let streaming: [JikanStreaming]?

    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case title
        case titleEnglish = "title_english"
        case titleJapanese = "title_japanese"
        case titleSynonyms = "title_synonyms"
        case synopsis, type, episodes, duration, status, score, rank, popularity, members, favorites
        case images, trailer, aired, studios, producers, licensors, genres, themes, demographics, source, broadcast, streaming
    }
}

struct JikanImage: Codable {
    let imageUrl: String?
    let largeImageUrl: String?
    let smallImageUrl: String?
    let webp: JikanWebPImage?

    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case largeImageUrl = "large_image_url"
        case smallImageUrl = "small_image_url"
        case webp
    }
}

struct JikanWebPImage: Codable {
    let imageUrl: String?
    let largeImageUrl: String?
    let smallImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case largeImageUrl = "large_image_url"
        case smallImageUrl = "small_image_url"
    }
}

struct JikanTrailer: Codable {
    let youtubeId: String?
    let url: String?
    let embedUrl: String?
    let images: JikanTrailerImage?

    enum CodingKeys: String, CodingKey {
        case youtubeId = "youtube_id"
        case url
        case embedUrl = "embed_url"
        case images
    }
}

struct JikanTrailerImage: Codable {
    let imageUrl: String?
    let smallImageUrl: String?
    let mediumImageUrl: String?
    let largeImageUrl: String?
    let maximumImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case smallImageUrl = "small_image_url"
        case mediumImageUrl = "medium_image_url"
        case largeImageUrl = "large_image_url"
        case maximumImageUrl = "maximum_image_url"
    }
}

struct AiredPeriod: Codable {
    let from: String?
    let to: String?
    let string: String?
}

struct JikanEntity: Codable {
    let name: String
}

struct JikanBroadcast: Codable {
    let day: String?
    let time: String?
    let timezone: String?
    let string: String?
}

struct JikanStreaming: Codable {
    let name: String
    let url: String
}
