import UIKit

let CompositionRoot = CompositionRootImpl.sharedInstance

class CompositionRootImpl {

    static var sharedInstance = CompositionRootImpl()

    private init() {}
    
    func resolveRootViewController() -> RootViewController {
        let vc = RootViewController.instantiateFromStoryboard("RootViewController")
        return vc
    }

    func resolveLoginViewController() -> LoginViewController {
        let vc = LoginViewController.instantiateFromStoryboard("Login")
        vc.viewModel = LoginViewModel(view: vc)
        return vc
    }
    
    func resolveMainViewController() -> MainViewController {
        let vc = MainViewController.instantiateFromStoryboard("MainViewController")
        vc.viewModel = MainViewModel(view: vc)
        return vc
    }
    
    func resolveSettingsViewController() -> MapViewController {
        let vc = MapViewController.instantiateFromStoryboard("MapViewController")
        vc.viewModel = MapViewModel()
        return vc
    }

}
