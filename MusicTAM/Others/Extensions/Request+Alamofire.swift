import Alamofire

//THIS EXTENSION IS USED FOR TRANSLATING REQUEST CLASS PARAMS TO ALAMOFIRE
//IN CASE WE WHERE TO USE ANOTHER NETWORK FRAMEWORK, WE WOULD JUST NEED TO
//REWRITE THIS

extension Request {
    var alamofireEncondingType: URLEncoding {
        switch self.contentType {
        case .json:
            return URLEncoding.httpBody
        case .queryString:
            return URLEncoding.queryString
        case .urlEncoded:
            return URLEncoding.queryString
        }
    }

    var alamofireMethod: HTTPMethod {
        switch method {
        case .get:
            return HTTPMethod.get
        case .post:
            return HTTPMethod.post
        case .delete:
            return HTTPMethod.delete
        case .put:
            return HTTPMethod.put
        case .patch:
            return HTTPMethod.patch
        }
    }
}
