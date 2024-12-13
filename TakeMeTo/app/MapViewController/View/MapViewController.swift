import UIKit

class MapViewController: BaseViewController<MapViewModel> {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        Coordinator.logout()
    }
}
