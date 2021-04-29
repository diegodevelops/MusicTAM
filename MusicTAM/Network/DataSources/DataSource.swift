import Foundation

protocol DataSourceProtocol {
}

class DataSource: DataSourceProtocol {

    internal let repository: Repository
    internal let webServiceURLProvider: WebServiceURLProvider
    typealias T = Codable

    init(repository: Repository, webServiceURLProvider: WebServiceURLProvider) {
        self.repository = repository
        self.webServiceURLProvider = webServiceURLProvider
    }

    // MARK: Internal Methods

    internal func performRequest<T>(requestParams: Request,
                                   needsLoader: ((Bool) -> Void)?,
                                   completion: @escaping (([T]?) -> Void),
                                   failure: ((String?) -> Void)?) where T: Codable {
        
        repository.request(requestParams: requestParams,
                           completion: completion,
                           failure: failure)
    }
}
