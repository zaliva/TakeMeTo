import UIKit

protocol MainViewControllerProtocol: NSObjectProtocol {
    func showError(error: Error)
    func showError(title: String, message: String)
}

class MainViewController: BaseViewController<MainViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showProfileAction(_ sender: Any) {
        Coordinator.logout()
    }
    
    @IBAction func startTourAction(_ sender: Any) {
        
    }
}

extension MainViewController: MainViewControllerProtocol {
    func showError(error: Error) {
        UniversalAlertView.show(title: error.propertyName, message: error.displayMessage, confirmText: LocalizeStrings.ok)
    }
    
    func showError(title: String, message: String) {
        UniversalAlertView.show(title: title, message: message, confirmText: LocalizeStrings.ok)
    }
}
