//
//  ViewController.swift
//  StoryShareSample
//
//  Created by Burak Ekmen on 21.12.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var imgBlur: UIImageView!
    @IBOutlet private weak var imgLocation: UIImageView!
    @IBOutlet private weak var btnInstagram: UIButton!
    @IBOutlet private weak var btnFacebook: UIButton!
    
    private let shareManager = SocialMediaShareManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
    }

    func prepareUI() {
        imgBlur.addBlurEffect()
        subView.roundCornersEachCorner(.allCorners, radius: 5)
    }
    
    @IBAction func instagramStoryTapped(_ sender: UIButton) {
        handleStoryProcess(type: .instagram)
    }
        
    @IBAction func facebookStoryTapped(_ sender: UIButton) {
        handleStoryProcess(type: .facebook)
    }
}


extension ViewController {
    
    func handleStoryProcess(type: SMSMShareButtonType) {
        let storyImage = containerView.asImage()
        shareManager.shareToPlatform(
            type: type,
            storyImage: storyImage,
            warningCompletion: { [weak self] warningInfo in
                guard let self else { return }
                
                if let appStoreRedirectUrl = warningInfo.appStoreRedirectUrl {
                    self.showAlert(
                        title: warningInfo.title,
                        message: warningInfo.message,
                        positiveButtonText: "Install Now",
                        positiveButtonClickListener: { [weak self] in
                            self?.openUrl(url: appStoreRedirectUrl)
                        },
                        negativeButtonText: "Ok"
                    )
                } else {
                    self.showAlert(
                        title: warningInfo.title,
                        message: warningInfo.message)
                }
                
            })
    }
    
}
