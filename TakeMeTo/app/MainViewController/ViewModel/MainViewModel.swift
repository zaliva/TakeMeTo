import UIKit

class MainViewModel: ViewModel {
    
    var tourDataModel: [TourDataModel] = []
    
    var view: MainViewControllerProtocol?
    
    init(view: MainViewControllerProtocol) {
        self.view = view
    }
    
    override func viewDidLoad() {
        getToursModel()
    }
    
    func getToursModel() {
        Toast.show()
        NetworkManager.getTour() { [weak self] model in
            Toast.dismiss()
            self?.tourDataModel = model
        } failure: { [weak self] error in
            Toast.dismiss()
            self?.view?.showError(error: error)
        }
    }
    
}
    
