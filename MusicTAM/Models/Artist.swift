import Foundation

struct ArtistResponse: Codable {
    let resultCount: Int?
    let results: [Artist]?
}

struct Artist: Codable {
    let artistId: Int32?
    let amgArtistId: Int32?
    let artistName: String?
    let primaryGenreName: String?
}
