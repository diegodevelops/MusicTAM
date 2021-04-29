//REPOSITORY IS A FEATURE WE USE FOR BOTH READ OR WRITE FROM OR TO WHEREVER, GIVEN
//THAT MOST OF THE TIME, WE WILL BE READING DATA FROM REMOTE SERVERS, DATABASES, ETC
//AND SAVING THEM TO LOCAL STORAGES OR SIMPLY USING DATA TO BE SHOWN IN APP.

//IN THIS CASE, IT IS PROVIDED A RESTREPOSITORY THAT WILL BE USING THE WEBSERVICE
//LAYER, IN CHARGE OF THE NETWORK CONNECTIONS

import Foundation

protocol Repository {
    func request<T>(requestParams: Request,
                    completion: @escaping (_ result: [T]) -> Void,
                    failure: ((_ error: String?) -> Void)?) where T: Codable
}

class RestRepository: Repository {
    private let webService: WebServiceProtocol

    init(webService: WebService) {
        self.webService = webService
    }

    func request<T>(requestParams: Request,
                    completion: @escaping (_ result: [T]) -> Void,
                    failure: ((_ error: String?) -> Void)?) where T: Codable {

        webService.get(request: requestParams, completion: {(result) in

            print("GET FROM REMOTE 👍: \n\(requestParams.description())")

            if let parsed: T = try? JSONDecoder().decode(T.self, from: result) {
                completion([parsed])
                return

            } else if let parsed: [T] = try? JSONDecoder().decode([T].self, from: result) {
                completion(parsed)
                return
            }

            completion([])

        }, failure: {(error) in
            failure?(error.localizedDescription)
        })
    }

}
