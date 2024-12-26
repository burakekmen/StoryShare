//
//  UIViewController+Extensions.swift
//  StoryShareSample
//
//  Created by Burak Ekmen on 21.12.2024.
//

import UIKit

extension UIViewController {
    
    func showAlert(
        title: String,
        message: String,
        positiveButtonText: String? = "Ok",
        positiveButtonClickListener: (() -> Void)? = nil,
        negativeButtonText: String? = nil,
        negativeButtonClickListener: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Positive Action
        let posAction = UIAlertAction(title: positiveButtonText, style: .default,
                                      handler: { _ in
                                          positiveButtonClickListener?()
                                      })
        alert.addAction(posAction)

        // Negative Action
        var negAction: UIAlertAction? = nil
        if let negativeButtonText = negativeButtonText {
            negAction = UIAlertAction(title: negativeButtonText, style: .cancel,
                                      handler: { _ in
                                          negativeButtonClickListener?()
                                      })
            alert.addAction(negAction!)
        }

        present(alert, animated: true, completion: nil)
    }
    
    func openUrl(url: String) {
        if let url = URL(string: url) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}
