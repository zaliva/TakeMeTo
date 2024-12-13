import Foundation

//Use all endpoints
enum UrlRequest: String {

    // MARK: - User
    case getUser = "/api/user/get-user"
    case getTour = "/api/tour/get-tours"
    case login = "/api/authorize/login"
    
    var fullUrl: String { "\(baseUrl)\(rawValue)" }
}
