import UIKit

let Persistance = PersistanceEntity.shared

class PersistanceEntity {
    
    static let shared = PersistanceEntity()
    private let defaults = UserDefaults.standard
    
    //MARK: Keys
    
    //General
    private let kIsLogin = "Persistance.kIsLogin"
    private let KLanguageCode = "Persistance.KLanguageCode"
    private let kAccount = "Persistance.kAccount"

    //Token
    private let kToken = "Persistance.kToken"
    private let kTokenExpires = "Persistance.MessengerTokenExpires"
    
    //MARK: Values
    
    //General
    var isLogin: Bool {
        get { defaults.bool(forKey: kIsLogin) }
        set { setValue(newValue, withKey: kIsLogin) }
    }

    var languageCode: String? {
        get { defaults.string(forKey: KLanguageCode) }
        set { setValue(newValue, withKey: KLanguageCode) }
    }
 
    //Token
    var token: String? {
        get { defaults.string(forKey: kToken) }
        set { setValue(newValue, withKey: kToken) }
    }
    
    //MARK: - User info
    var account: AccountModel? {
        get {
            guard let data = defaults.data(forKey: kAccount) else { return nil }
            return try? JSONDecoder().decode(AccountModel.self, from: data)
        }
        set {
            guard let newValue = newValue else {
                defaults.removeObject(forKey: kAccount)
                return
            }
            let data = try? JSONEncoder().encode(newValue)
            setValue(data, withKey: kAccount)
        }
    }
    
    var tokenExpires: String? {
        get { defaults.string(forKey: kTokenExpires) }
        set { setValue(newValue, withKey: kTokenExpires) }
    }
}

extension PersistanceEntity {
    private func setValue<T>(_ value: T, withKey key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    func clearAllUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
    func removeForKey(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
