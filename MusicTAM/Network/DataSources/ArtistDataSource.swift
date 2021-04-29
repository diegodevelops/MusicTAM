//BY USING DATASOURCE EXTENSIONS, WE GET TO ISOLATE WHAT INTERACTORS CAN ACCESS AND ALSO
//TO GET ESCALABILITY BY NOT CREATING MASSIVE DATA SOURCES WITH THE WHOLE CALLS IN A SINGLE FILE

import Foundation

protocol ArtistDataSource {
    func getArtists(searchTerm: String,
                     page: String?,
                     limit: String?,
                     needsLoader: ((Bool) -> Void)?,
                     completion: @escaping (([ArtistResponse]?) -> Void),
                     failure: ((String?) -> Void)?)

    func getAlbums(amgArtistId: Int32,
                       needsLoader: ((Bool) -> Void)?,
                       completion: @escaping (([AlbumResponse]?) -> Void),
                       failure: ((String?) -> Void)?)
    
    func getSongs(collectionId: Int32,
                       needsLoader: ((Bool) -> Void)?,
                       completion: @escaping (([SongResponse]?) -> Void),
                       failure: ((String?) -> Void)?)
}

extension DataSource: ArtistDataSource {

    func getArtists(searchTerm: String,
                    page: String? = nil,
                    limit: String? = nil,
                    needsLoader: ((Bool) -> Void)?,
                    completion: @escaping (([ArtistResponse]?) -> Void),
                    failure: ((String?) -> Void)?) {
        
        let serviceUrl = webServiceURLProvider.artistSearchURL
            .replacingOccurrences(of: "{{searchTerm}}", with: searchTerm)
        
        let request = Request(serviceUrl: serviceUrl,
                              contentType: .queryString,
                              method: .get)

        performRequest(requestParams: request,
                       needsLoader: needsLoader,
                       completion: completion,
                       failure: failure)
    }
    
    func getAlbums(amgArtistId: Int32,
                   needsLoader: ((Bool) -> Void)?,
                   completion: @escaping (([AlbumResponse]?) -> Void),
                   failure: ((String?) -> Void)?) {
        
        let serviceUrl = webServiceURLProvider.albumsURL
            .replacingOccurrences(of: "{{amgArtistId}}", with: "\(amgArtistId)")
        
        let request = Request(serviceUrl: serviceUrl,
                              contentType: .queryString,
                              method: .get)

        performRequest(requestParams: request,
                       needsLoader: needsLoader,
                       completion: completion,
                       failure: failure)
    }
    
    func getSongs(collectionId: Int32,
                  needsLoader: ((Bool) -> Void)?,
                  completion: @escaping (([SongResponse]?) -> Void),
                  failure: ((String?) -> Void)?) {
        
        let serviceUrl = webServiceURLProvider.songsURL
            .replacingOccurrences(of: "{{collectionId}}", with: "\(collectionId)")
        
        let request = Request(serviceUrl: serviceUrl,
                              contentType: .queryString,
                              method: .get)

        performRequest(requestParams: request,
                       needsLoader: needsLoader,
                       completion: completion,
                       failure: failure)
    }
}
