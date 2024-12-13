import Foundation
import SwiftyJSON
import Alamofire

typealias SuccessHandler = (JSON) -> Void
typealias FailureHandler = (Error) -> Void

class HTTPManager {

    class func get(url: UrlRequest, params: [String: Any]?, successHandler: SuccessHandler? = nil, failureHandler: FailureHandler? = nil) {
        var requestUrl = url.fullUrl
        if let params = params {
            requestUrl += convertDictParamsToStringUrl(params)
        }

        NetworkSessionManager.shared
            .sessionManager
            .request(requestUrl,
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: API.authorizedHeaders())
            .validate()
            .responseData { response in
                LoggerManager.log(response: response)
                switch response.result {
                case .success(let data):
                    handleSuccessResponse(url: requestUrl, data: data, successHandler: successHandler, failureHandler: failureHandler)
                case .failure(let error):
                    handleFailureResponse(response: response, responseError: error, failureHandler: failureHandler)
                }
            }
    }

    class func post(url: UrlRequest, params: [String: Any]?, successHandler: SuccessHandler? = nil, failureHandler: FailureHandler? = nil) {
        NetworkSessionManager.shared
            .sessionManager
            .request(url.fullUrl,
                     method: .post,
                     parameters: params,
                     encoding: JSONEncoding.default,
                     headers: API.authorizedHeaders())
            .validate()
            .responseData { response in
                LoggerManager.log(response: response)
                switch response.result {
                case .success(let data):
                    handleSuccessResponse(url: url.fullUrl, data: data, successHandler: successHandler, failureHandler: failureHandler)
                case .failure(let error):
                    handleFailureResponse(response: response, responseError: error, failureHandler: failureHandler)
                }
            }
    }
    
    private class func handleFailureData(data: Data, failureHandler: FailureHandler?, defaultError: Error? = nil) {
        let defaultError: Error = defaultError != nil ? defaultError! : Error(propertyName: LocalizeStrings.networkError, displayMessage: LocalizeStrings.networkErrorMsg, errorCode: ErrorCode.unknownСodeFromServer)
        do {
            let json = try JSON(data: data, options: [])
            let errorsData = try json["errors"].rawData()
            let resultModel = try JSONDecoder().decode(Error.self, from: errorsData)
            failureHandler?(resultModel)
        } catch {
            failureHandler?(defaultError)
        }
    }

    private class func handleFailureResponse(response: AFDataResponse<Data>, responseError: AFError, failureHandler: FailureHandler?) {
        let defaultError = Error(propertyName: LocalizeStrings.networkError, displayMessage: responseError.localizedDescription, errorCode: responseError.responseCode ?? ErrorCode.unknownСodeFromServer)
        guard let data = response.data else {
            failureHandler?(defaultError)
            return
        }
        handleFailureData(data: data, failureHandler: failureHandler, defaultError: defaultError)
    }

    private class func handleSuccessResponse(url: String, data: Data, successHandler: SuccessHandler? = nil, failureHandler: FailureHandler? = nil) {
        do {
            let json = try JSON(data: data, options: [])
            let isSuccess = json["success"].boolValue
            if isSuccess {
                successHandler?(json)
            } else {
                handleFailureData(data: data, failureHandler: failureHandler)
            }
        } catch let error {
            debugPrint(error.localizedDescription + ", url: \(url)")
            failureHandler?(Error(propertyName: LocalizeStrings.networkError, displayMessage: LocalizeStrings.networkErrorMsg, errorCode: ErrorCode.errorParsing))
        }
    }

    class func uploadFile(uploadFileType: String,
                          url: String,
                          data: Data,
                          completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: url) else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.httpBody = data
        request.setValue(uploadFileType, forHTTPHeaderField: "Content-Type")

        NetworkSessionManager.shared
            .sessionManager
            .upload(data, with: request)
            .validate()
            .responseData { response in
                LoggerManager.log(response: response)
                completion(response.response?.statusCode == 200)
            }
    }

    private class func convertDictParamsToStringUrl(_ params: [String: Any]) -> String {
        var stringUrl = String()
        for (key, value) in params {
            if stringUrl.contains("?") {
                stringUrl += "&\(key)=\(value)"
            } else {
                stringUrl += "?\(key)=\(value)"
            }
        }
        return stringUrl
    }
}
