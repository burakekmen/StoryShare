//
//  Bundle+Extensions.swift
//  StoryShareSample
//
//  Created by Burak Ekmen on 21.12.2024.
//

import Foundation

extension Bundle {
    
    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }
}
