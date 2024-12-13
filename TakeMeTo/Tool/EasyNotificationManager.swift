//        //ДОБАВЛЕНИЕ ОБСЕРВЕРА
//
//        //Через менеджер:
//        ENManager.add(nnFollowee, identifier: self) { notif in
//            print("TEST 0")
//            print(notif.object)
//            print(notif.userInfo["key"])
//        }
//
//
//        //ИСПОЛЬЗОВАНИЕ
//        ENManager.post(nnFollowee)
//        ENManager.post(nnFollowee, object: "test")
//        ENManager.post(nnFollowee, object: "test", userInfo: ["key": "testValue"])
//
//        //или:
//        nnFollowee.post()
//        nnFollowee.post(object: "test")
//        nnFollowee.post(object: "test", userInfo: ["key": "testValue"])
//
//        //УДАЛЕНИЕ
//
//        //Для конкретного нейма
//        ENManager.remove(self, observerName: nnFollowee)
//        //Удалит все обсерверы для класса
//        ENManager.removeAllIn(self)
//        //Удалит все кроме тех что в масиве
//        ENManager.removeAllIn(self, butExclude: [nnFollowee, nnUserLogout])
//        //Удалит только те что в массиве
//        ENManager.removeOnly(self, and: [nnUserLogout])

import Foundation

let ENManager = EasyNotificationManager.shared

class EasyNotificationManager {
    static let shared = EasyNotificationManager()

    var observers = [String: NSObjectProtocol]()

    private init() {}

    func add(_ observerName: Notification.Name, identifier: NSObject, object: Any? = nil, queue: OperationQueue? = nil, using: @escaping (Notification) -> Void) {
        let obsItem = NotificationCenter.default.addObserver(forName: observerName, object: object, queue: queue, using: using)
        let className = String(describing: identifier)
        let notifName = observerName.rawValue

        addObserver(className: className, notificationName: notifName, observerIdentifier: obsItem)
    }

    func post(_ observerName: Notification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: observerName, object: object, userInfo: userInfo)
    }

    func remove(_ identifier: NSObject, observerName: Notification.Name) {
        let className = String(describing: identifier)
        let notifName = observerName.rawValue
        removeObserver(className: className, notificationName: notifName)
    }

    func removeAllIn(_ identifier: NSObject, butExclude array: [Notification.Name] = []) {
        let className = String(describing: identifier)
        let excludeArray = array.map({$0.rawValue})

        let observers = self.observers
        observers.forEach { element in
            if let notifName = element.key.split(separator: "|").last?.description {
                if element.key.contains("\(className)|") && !excludeArray.contains(notifName) {
                    removeObserverFor(key: element.key)
                }
            }
        }
    }

    func removeOnly(_ identifier: NSObject, and array: [Notification.Name]) {
        let className = String(describing: identifier)
        array.forEach { notifName in
            removeObserver(className: className, notificationName: notifName.rawValue)
        }
    }

    private func addObserver(className: String, notificationName: String, observerIdentifier: NSObjectProtocol) {
        // In case if instantiate the 2 identical observers in the same class
        removeObserver(className: className, notificationName: notificationName)

        observers["\(className)|\(notificationName)"] = observerIdentifier
    }

    private func removeObserver(className: String, notificationName: String) {
        removeObserverFor(key: "\(className)|\(notificationName)")
    }

    private func removeObserverFor(key: String) {
        if let identifier = observers.removeValue(forKey: key) {
            NotificationCenter.default.removeObserver(identifier)
        }
    }
}
