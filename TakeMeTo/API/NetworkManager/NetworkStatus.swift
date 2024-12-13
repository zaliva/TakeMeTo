import Foundation
import Alamofire

let NetworkStatusManager = NetworkManagerStatus.shared

class NetworkManagerStatus {

    static let shared = NetworkManagerStatus()

    var isConnected = false

    private var currentState: Alamofire.NetworkReachabilityManager.NetworkReachabilityStatus?

    private let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "google.com")
    
    private init() {}

    func startNetworkReachabilityObserver() {

        self.reachabilityManager?.startListening(onUpdatePerforming: { networkStatusListener in

            switch networkStatusListener {

            case .notReachable:
                self.isConnected = false
                self.didChangeConnectStatus()
            case .unknown :
                self.isConnected = false
                self.didChangeConnectStatus()
            case .reachable(.ethernetOrWiFi):
                self.isConnected = true
                if !self.checkIfNetworkConnectionIsBack() {
                    self.didChangeConnectStatus()
                }
            case .reachable(.cellular):
                self.isConnected = true
                if !self.checkIfNetworkConnectionIsBack() {
                    self.didChangeConnectStatus()
                }
            }
            self.currentState = networkStatusListener
        })
    }

    private func checkIfNetworkConnectionIsBack () -> Bool {

        guard self.currentState != .reachable(.ethernetOrWiFi), self.currentState != .reachable(.cellular) else { return false }
        ENManager.post(nnNetworkConnectionIsBack)
        return true
    }

    private func didChangeConnectStatus() {
        ENManager.post(nnDidChangeNetworkStatus)
    }
}
