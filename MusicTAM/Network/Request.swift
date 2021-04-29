import Foundation

struct Request{
    public var serviceUrl: String?
    public var params: [String: Any]?
    public var contentType: RequestType
    public var method: RequestMethod

    public init(serviceUrl: String? = nil,
                params: [String: Any]? = nil,
                contentType: RequestType,
                method: RequestMethod) {

        self.serviceUrl = serviceUrl
        self.params = params
        self.contentType = contentType
        self.method = method
    }

    public func getId() -> String {
        var output = serviceUrl

        if let params = params, params.count > 0 {
            for (key, value) in params {
                output?.append(contentsOf: "_\(key)_\(value)")
            }
        }

        return output ?? ""
    }

    public func description() -> String {
        return "\(serviceUrl != nil ? "ServiceURL: \(serviceUrl!)\n" : "")" +
            "\(params != nil ? "Params: \(params!)\n" : "")"
    }
}

public enum RequestType: String {
    case urlEncoded
    case json
    case queryString
}

public enum RequestMethod: String {
    case get
    case post
    case delete
    case put
    case patch
}
