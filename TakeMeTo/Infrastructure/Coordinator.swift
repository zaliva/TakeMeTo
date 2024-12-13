import UIKit

let Coordinator = CoordinatorImpl.shared

class CoordinatorImpl {

    static let shared = CoordinatorImpl()

    private init() {}
    
    func showRootViewController() {
        UIApplication.shared.delegate?.window??.rootViewController = CompositionRoot.resolveRootViewController()
    }

    func showLoginOrMainViewController() {
        if Persistance.isLogin {
            showMainController()
        } else {
            let navController = UINavigationController(rootViewController: CompositionRoot.resolveLoginViewController())
            navController.navigationBar.isHidden = true
            navController.navigationController?.setNavigationBarHidden(true, animated: false)
            UIApplication.shared.delegate?.window??.rootViewController = navController
        }
    }

    func showMainController() {
        let navController = UINavigationController(rootViewController: CompositionRoot.resolveMainViewController())
        navController.navigationBar.isHidden = true
        navController.navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.delegate?.window??.rootViewController = navController
    }
    
    func logout() {
        Persistance.isLogin = false
        Persistance.clearAllUserDefaults()
        Coordinator.showLoginOrMainViewController()
    }

    func goToLoginViewController() {
        push(CompositionRoot.resolveLoginViewController())
    }
    
    func push(_ vc: UIViewController, animated: Bool = true) {
        currentNavigationController?.pushViewController(vc, animated: animated)
    }
    
    private var originKeyWindow: UIWindow?
    
    weak var currentNavigationController: UINavigationController? {
        get {
            if originKeyWindow == nil {
                originKeyWindow = UIApplication.shared.currentKeyWindow
            }
            let window = originKeyWindow ?? UIApplication.shared.currentKeyWindow

            var vc: UIViewController = window?.rootViewController ?? UIViewController()
            var navVC: UINavigationController?
            if vc.presentedViewController != nil {
                vc = vc.presentedViewController ?? UIViewController()
            }

            if vc is UINavigationController {
                navVC = vc as? UINavigationController
            } else if let tabBarVC = vc as? UITabBarController {
                navVC = tabBarVC.selectedViewController as? UINavigationController
            }

            if navVC == nil {
                debugPrint("error:1000.[Navigation not found,please restart application]")
            }

            return navVC
        }
    }

}
