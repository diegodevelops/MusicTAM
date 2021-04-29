import Foundation
import Alamofire

protocol WebServiceProtocol: class {
    func get(request: Request,
             completion : @escaping (_ result : Data) -> Void,
             failure : @escaping (_ result : AnyObject) -> Void)
}

class WebService: WebServiceProtocol {

    func get(request: Request,
             completion: @escaping (Data) -> Void,
             failure: @escaping (AnyObject) -> Void) {

        guard let serviceUrl = request.serviceUrl,
              let trimmed = serviceUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let finalUrl = URL(string: trimmed) else {

                failure("NO_REQUEST" as AnyObject)
                return
        }

        Alamofire.request(finalUrl,
                          method: request.alamofireMethod,
                          parameters: request.params,
                          encoding: request.alamofireEncondingType,
                          headers: nil)

            .responseData(completionHandler: { response in
                if response.result.isSuccess,
                    let data = response.result.value {
                    completion(data)

                } else {
                    failure((response.result.error?.localizedDescription ?? "NO_DATA") as AnyObject)
                }
            }
        )
    }

}
