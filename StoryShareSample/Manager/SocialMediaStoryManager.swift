//
//  SocialMediaStoryManager.swift
//  StoryShareSample
//
//  Created by Burak Ekmen on 21.12.2024.
//

import Foundation
import UIKit

enum SMSMOptionKey: String {
    case appIdFacebook = "com.facebook.sharedSticker.appID"
    case backgroundImageFacebook = "com.facebook.sharedSticker.backgroundImage"
    case backgroundImageInstagram = "com.instagram.sharedSticker.backgroundImage"
}

enum SMSMPlatformUrlScheme: String {
    case facebook = "facebook-stories://share"
    case instagram = "instagram-stories://share"
}

enum SMSMPlatformAppStoreUrl: String {
    case facebook = "https://apps.apple.com/app/facebook/id284882215"
    case instagram = "https://apps.apple.com/app/instagram/id389801252"
}

enum SMSMShareButtonType {
    case facebook
    case instagram
}

struct SMSMWarningInfoModel {
    let title: String
    let message: String
    let appStoreRedirectUrl: String?
}

final class SocialMediaShareManager {
    static let shared = SocialMediaShareManager()
    private init() {}
    
    func shareToPlatform(type: SMSMShareButtonType,
                         storyImage: UIImage?,
                         warningCompletion: ((SMSMWarningInfoModel) -> Void)?) {
        
        var urlScheme: URL?
        var pasteboardItems: [String: Any] = [:]
        
        switch type {
        case .facebook:
            urlScheme = URL(string: SMSMPlatformUrlScheme.facebook.rawValue)
            pasteboardItems = preparePasteboardItems(
                appID: "FACEBOOK_APP_ID",
                appIDKey: .appIdFacebook,
                image: storyImage,
                imageKey: .backgroundImageFacebook
            )
            
        case .instagram:
            urlScheme = URL(string: "\(SMSMPlatformUrlScheme.instagram.rawValue)?source_application=\(Bundle.main.appName)")
            pasteboardItems = preparePasteboardItems(
                image: storyImage,
                imageKey: .backgroundImageInstagram
            )
            
        }
        
        guard let urlScheme, validateURLScheme(type, urlScheme, warningCompletion: warningCompletion) else { return }
        guard storyImage != nil else {
            warningCompletion?(prepareWarningModel(message: "Try Again Later"))
            return
        }
        
        shareWithPasteboard(urlScheme: urlScheme, items: pasteboardItems)
    }
}

private extension SocialMediaShareManager {
    // If the user does not have the relevant app on their device, a warning will be displayed and they will be directed to the App Store
    func validateURLScheme(_ type: SMSMShareButtonType, _ urlScheme: URL, warningCompletion: ((SMSMWarningInfoModel) -> Void)?) -> Bool {
        guard UIApplication.shared.canOpenURL(urlScheme) else {
            warningCompletion?(prepareWarningModel(
                title: "App Not Installed on The Phone",
                message: "Please Install The App Then Try Later",
                appStoreRedirectUrl: getAppStoreUrl(type: type)
            ))
            return false
        }
        return true
    }
    
    
    func preparePasteboardItems(appID: String? = nil,
                                appIDKey: SMSMOptionKey? = nil,
                                image: UIImage?,
                                imageKey: SMSMOptionKey) -> [String: Any] {
        var items: [String: Any] = [:]
        
        if let appID,
           let appIDKey {
            items[appIDKey.rawValue] = appID
        }
        
        if let imageData = image?.pngData() {
            items[imageKey.rawValue] = imageData
        }
        
        return items
    }
    
    
    func shareWithPasteboard(urlScheme: URL, items: [String: Any]) {
        let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [
            .expirationDate: Date().addingTimeInterval(300)
        ]
        
        UIPasteboard.general.setItems([items], options: pasteboardOptions)
        UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
    }
}


internal extension SocialMediaShareManager {
    
    func getAppStoreUrl(type: SMSMShareButtonType) -> String {
        switch type {
        case .facebook:
            SMSMPlatformAppStoreUrl.facebook.rawValue
        case .instagram:
            SMSMPlatformAppStoreUrl.instagram.rawValue
        }
    }
    
    func prepareWarningModel(title: String = "Warning",
                             message: String,
                             appStoreRedirectUrl: String? = nil) -> SMSMWarningInfoModel {
        SMSMWarningInfoModel(title: title,
                             message: message,
                             appStoreRedirectUrl: appStoreRedirectUrl)
    }
    
}
