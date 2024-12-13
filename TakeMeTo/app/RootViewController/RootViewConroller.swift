
import UIKit

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Toast.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            Toast.dismiss()
            Coordinator.showLoginOrMainViewController()
        })
    }
}
