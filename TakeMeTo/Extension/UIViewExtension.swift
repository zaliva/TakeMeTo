
import UIKit

extension UIView {
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = self.layer.borderColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }

        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable var circle: Bool {
        get {
            return cornerRadiusWithMasks == self.frame.width/2
        }
        set {
            let minDimension = min(self.frame.width, self.frame.height)
            cornerRadiusWithMasks = (newValue ? minDimension/2 : 0)
        }
    }

    @IBInspectable var cornerRadiusWithMasks: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.masksToBounds = newValue > 0
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }

        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }

        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable var layerShadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var layerShadowColor: UIColor {
        get {
            if let layerShadowColor = layer.shadowColor {
                return UIColor.init(cgColor: layerShadowColor)
            } else {
                return UIColor.clear
            }
        }
        set { layer.shadowColor = newValue.cgColor }
    }

    @IBInspectable public var zPosition: CGFloat {
        get {
            return layer.zPosition
        }

        set {
            layer.zPosition = newValue
        }
    }
}
