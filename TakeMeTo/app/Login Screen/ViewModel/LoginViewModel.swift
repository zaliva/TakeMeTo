import UIKit

class LoginViewModel: ViewModel {
    
    var view: LoginViewProtocol?
    
    init(view: LoginViewProtocol) {
        self.view = view
    }
    
    func login(email: String?, password: String?) {
        guard let email = email, let password = password else {
            view?.showError(title: LocalizeStrings.noInputProvided, message: LocalizeStrings.noInputProvidedMsg)
            return
        }
        guard email.isValidEmail() else {
            view?.showError(title: LocalizeStrings.invalidEmailFormat, message: LocalizeStrings.invalidEmailFormatMsg)
            return
        }
        guard password.count >= 5 else {
            view?.showError(title: LocalizeStrings.invalidPassword, message: LocalizeStrings.invalidPasswordMsg)
            return
        }
        Toast.show()
        NetworkManager.login(model: RequestLoginModel(email: email, password: password)) { [weak self] in
            self?.getUser()
        } failure: { [weak self] error in
            Toast.dismiss()
            self?.view?.showError(error: error)
        }
    }
    
    func getUser() {
        NetworkManager.getUser() { model in
            Toast.dismiss()
            Persistance.account = model.account
            Coordinator.showLoginOrMainViewController()
        } failure: { [weak self] error in
            Toast.dismiss()
            self?.view?.showError(error: error)
        }
    }
}
