import UIKit

protocol LoginViewProtocol: NSObjectProtocol {
    func showError(error: Error)
    func showError(title: String, message: String)
}

class LoginViewController: BaseViewController<LoginViewModel> {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var constraintCenter: NSLayoutConstraint!
    
    override var isKeyboardNotificationsEnable: Bool { true }
    override var hideKeyboardOnTap: Bool { true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func keyboardWill(hide: CGSize) {
        constraintCenter.constant = 0
        animate()
    }
    
    override func keyboardWill(show: CGSize) {
        
        let keyboardHeight = show.height
        
        let buttonFrame = loginButton.convert(loginButton.bounds, to: self.view)
        let buttonBottomY = buttonFrame.maxY
        
        let visibleAreaHeight = UIScreen.main.bounds.height - keyboardHeight
        
        if buttonBottomY > visibleAreaHeight {
            let offset = buttonBottomY - visibleAreaHeight + 16
            constraintCenter.constant = -offset
        }
        animate()
    }
    
    //MARK: - Actions
    @IBAction func googleLoginAction(_ sender: Any) {
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        dismissKeyboard()
        viewModel.login(email: emailTextField.text, password: passwordTextField.text)
    }
    
    @IBAction func resetPasswordAction(_ sender: Any) {
        
    }
    
    @IBAction func createAccountAction(_ sender: Any) {
        emailTextField.text = "bis@gmail.com"
        passwordTextField.text = "12345"
    }
    
}
extension LoginViewController: LoginViewProtocol {
    func showError(error: Error) {
        UniversalAlertView.show(title: error.propertyName, message: error.displayMessage, confirmText: LocalizeStrings.ok)
    }
    
    func showError(title: String, message: String) {
        UniversalAlertView.show(title: title, message: message, confirmText: LocalizeStrings.ok)
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
