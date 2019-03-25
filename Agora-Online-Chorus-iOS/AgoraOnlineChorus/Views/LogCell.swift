//
//  LogCell.swift
//  AgoraOnlineChorus
//
//  Created by ZhangJi on 2019/3/21.
//  Copyright © 2019 ZhangJi. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {

    @IBOutlet weak var logLabel: UILabel!
    
    func set(log: String) {        
        logLabel.text = log
    }
}
