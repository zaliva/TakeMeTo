import UIKit

public class UniversalAlertView: UIView {

    private var closeHandler: (() -> Void)?
    private var confirmHandler: (() -> Void)?

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var vBackgroundTitle: UIView!
    @IBOutlet weak var lTitle: UILabel!
    @IBOutlet weak var lSubtitle: UILabel!
    @IBOutlet weak var offsetConfirmButton: UIView!
    @IBOutlet weak var confirmBtnView: UIView!
    @IBOutlet weak var bConfirm: UIButton!
    @IBOutlet weak var bClose: UIButton!
    
    private class func instance() -> UniversalAlertView? {
        let bundle = Bundle(for: Self.self)
        let xibFile = bundle.loadNibNamed(String(describing: UniversalAlertView.self), owner: self, options: nil)
        guard let xibFile = xibFile, !xibFile.isEmpty, let view = xibFile.first as? UniversalAlertView else { return nil }
        view.frame = CGRect(x: 0, y: CGFloat(ScreenHeight), width: CGFloat(ScreenWidth), height: CGFloat(ScreenHeight))
        return view
    }
    
    class func show(title: String, message: String, confirmText: String?, showCloseBtn: Bool = true, confirmHandler: (() -> Void)? = nil, closeHandler: (() -> Void)? = nil) {
        guard !checkAlertAlreadyOpened(), let view = instance() else { return }
        UIApplication.shared.currentKeyWindow?.addSubview(view)
        view.configureView(title: title, message: message, confirmText: confirmText, showCloseBtn: showCloseBtn)
        view.showAnimation()
    }
    
    private func configureView(title: String, message: String, confirmText: String?, showCloseBtn: Bool, confirmHandler: (() -> Void)? = nil, closeHandler: (() -> Void)? = nil) {

        lTitle.text = title
        lSubtitle.text = message

        if let confirmText {
            confirmBtnView.isHidden = false
            offsetConfirmButton.isHidden = false
            bConfirm.setTitle(confirmText, for: .normal)
        } else {
            confirmBtnView.isHidden = true
            offsetConfirmButton.isHidden = true
        }
        
        self.closeHandler = closeHandler
        self.confirmHandler = confirmHandler

        bClose.isHidden = !showCloseBtn

    }

    
    private class func checkAlertAlreadyOpened() -> Bool {
        return UIApplication.shared.currentKeyWindow?.subviews.contains { $0 is UniversalAlertView } ?? false
    }
    
    // MARK: - Action
    @IBAction func confirmAction(_ sender: Any) {
        confirmHandler?()
        dismissView()
    }


    @IBAction func closeAction(_ sender: Any) {
        closeHandler?()
        dismissView()
    }

    @objc public func dismissView() {
        removeFromSuperview()
    }

    private func showAnimation() {
        UIView.animate(withDuration: 0.35) {
            self.frame = CGRect(x: 0, y: 0, width: CGFloat(ScreenWidth), height: CGFloat(ScreenHeight))
        } completion: { _ in
            UIView.animate(withDuration: 0.25) {
                self.backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)

                UIView.animateKeyframes(withDuration: 0, delay: 0, options: [], animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                        self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                        self.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25, animations: {
                        self.transform = CGAffineTransform(scaleX: 1, y: 1)
                    })
                })
            }
        }
    }
}
