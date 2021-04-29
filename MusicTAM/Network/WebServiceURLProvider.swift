protocol WebServiceURLProvider {
    var artistSearchURL: String { get set }
    var albumsURL: String { get set }
    var songsURL: String { get set }
}

class WebServiceURLProviderImpl: WebServiceURLProvider {
    var artistSearchURL: String
    var albumsURL: String
    var songsURL: String

    init(artistSearchURL: String, albumsURL: String, songsURL: String) {
        self.artistSearchURL = artistSearchURL
        self.albumsURL = albumsURL
        self.songsURL = songsURL
    }
}

class WebServiceURLProviderBuilder {

    private let artistSearchURLMock = "https://itunes.apple.com/search?term={{searchTerm}}&entity=allArtist"
    private let albumsURLMock = "https://itunes.apple.com/lookup?amgArtistId={{amgArtistId}}&entity=album"
    private let songsURLMock = "https://itunes.apple.com/lookup?id={{collectionId}}&entity=song"

    func getProvider(for environment: Environment) -> WebServiceURLProvider {
        switch Compilation.environment {
        case .mock:
            return WebServiceURLProviderImpl(artistSearchURL: artistSearchURLMock,
                                             albumsURL: albumsURLMock,
                                             songsURL: songsURLMock)
        }
    }
}
