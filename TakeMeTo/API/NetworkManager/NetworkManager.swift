import Foundation
import SwiftyJSON

class NetworkManager {

    typealias SuccessModel<M: Codable> = (M) -> Void

    class func handleModel<M: Codable>(json: JSON, success: SuccessModel<M>? = nil, failure: FailureHandler? = nil) {
        guard let data = try? json["data"].rawData() else {
            failure?(Error(propertyName: LocalizeStrings.networkError, displayMessage: LocalizeStrings.networkErrorMsg, errorCode: ErrorCode.errorParsing))
            return
        }
        do {
            let resultModel = try JSONDecoder().decode(M.self, from: data)
            success?(resultModel)
        } catch let error {
            print(error.localizedDescription)
            failure?(Error(propertyName: LocalizeStrings.networkError, displayMessage: error.localizedDescription, errorCode: ErrorCode.errorDecode))
        }
    }

    class func handleArrayOfModels<M: Codable>(json: JSON, success: SuccessModel<[M]>? = nil, failure: FailureHandler? = nil) {
        guard let data = try? json["data"].rawData() else {
            failure?(Error(propertyName: LocalizeStrings.networkError, displayMessage: LocalizeStrings.networkErrorMsg, errorCode: ErrorCode.errorParsing))
            return
        }
        do {
            let resultModel = try JSONDecoder().decode([M].self, from: data)
            success?(resultModel)
        } catch {
            print(error.localizedDescription)
            failure?(Error(propertyName: LocalizeStrings.networkError, displayMessage: error.localizedDescription, errorCode: ErrorCode.errorDecode))
        }
    }
    
    //MARK: - Login
    class func login(model: RequestLoginModel, success: (() -> Void)? = nil, failure: FailureHandler? = nil) {
        HTTPManager.get(url: .login, params: model.dictionary) { result in
            Persistance.token = result["data"].stringValue
            Persistance.isLogin = true
            success?()
        } failureHandler: { error in
            failure?(error)
        }
    }

    // MARK: - Get User
    class func getUser(success: ((UserModel) -> Void)? = nil, failure: FailureHandler? = nil) {
        HTTPManager.get(url: .getUser, params: nil) { result in
            handleModel(json: result, success: success, failure: failure)
        } failureHandler: { error in
            failure?(error)
        }
    }
    
    // MARK: - Get Tour
    class func getTour(success: (([TourDataModel]) -> Void)? = nil, failure: FailureHandler? = nil) {
        HTTPManager.get(url: .getTour, params: nil) { result in
            handleArrayOfModels(json: result, success: success, failure: failure)
        } failureHandler: { error in
            failure?(error)
        }
    }
}
