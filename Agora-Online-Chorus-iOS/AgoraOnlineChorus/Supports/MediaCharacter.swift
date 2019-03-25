//
//  MediaCharacter.swift
//  AgoraOnlineChorus
//
//  Created by ZhangJi on 2019/3/21.
//  Copyright © 2019 ZhangJi. All rights reserved.
//

import Foundation

struct MediaCharacter {
    
    fileprivate static let legalMediaCharacterSet: NSCharacterSet = {
        return NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!#$%&()+,-:;<=.>?@[]^_`{|}~")
    }()
    
    static func updateToLegalMediaString(from string: String) -> String {
        let legalSet = MediaCharacter.legalMediaCharacterSet
        let separatedArray = string.components(separatedBy: legalSet.inverted)
        let legalString = separatedArray.joined(separator: "")
        return legalString
    }
}
