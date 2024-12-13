import Foundation

struct UserModel: Codable {
    let id: String
    let role: Int
    let account: AccountModel
//    let userTours: [String]?
}

struct AccountModel: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let phone: String
    let userId: String
}

struct RequestLoginModel: Codable {
    let email: String
    let password: String
}
