//
//  UIImageView+Extensions.swift
//  StoryShareSample
//
//  Created by Burak Ekmen on 21.12.2024.
//

import UIKit

extension UIImageView {
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(blurEffectView)
    }

    
}
