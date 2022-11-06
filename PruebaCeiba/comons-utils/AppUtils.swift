import Foundation
import UIKit
import NVActivityIndicatorView


func showLoading() {
    let attributedString = NSAttributedString(string: "\n\nPor favor espere", attributes: [
        NSAttributedString.Key.font :  UIFont.boldSystemFont(ofSize: 15),
        NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.07028970894, green: 0.4611325048, blue: 0.2668374855, alpha: 1)
    ])
    
    let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
    alert.setValue(attributedString, forKey: "attributedMessage")
    let frame = CGRect(x: alert.view.center.x-90, y: 15, width: 40, height: 40)
    let loadingIndicator = NVActivityIndicatorView(frame: frame, type: .ballPulseSync, color: #colorLiteral(red: 0.07028970894, green: 0.4611325048, blue: 0.2668374855, alpha: 1), padding: .none)
    loadingIndicator.startAnimating()
    alert.view.addSubview(loadingIndicator)
    getTopMostViewController()?.present(alert, animated: true)

}

func hidenLoading() {
    DispatchQueue.main.async {
        getTopMostViewController()?.dismiss(animated: true)        
    }
}

func getTopMostViewController() -> UIViewController? {
    
    var topMostViewController = UIApplication.shared.windows.first?.rootViewController

    while let presentedViewController = topMostViewController?.presentedViewController {
        topMostViewController = presentedViewController
    }

    return topMostViewController
}
