import UIKit

extension UIViewController {
    class func instantiateFromStoryboard(_ name: String = "Main") -> Self {
        return instantiateFromStoryboardHelper(name)
    }
    
    fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let identifier = String(describing: self)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier) as! T
        return controller
    }
}
