//
//  MainViewController.swift
//  AgoraOnlineChorus
//
//  Created by ZhangJi on 2019/3/21.
//  Copyright © 2019 ZhangJi. All rights reserved.
//

import UIKit

enum EnterType {
    case singer
    case playback
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var popoverSourceView: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier, let roomName = sender as? String else {
                return
        }
        
        switch segueId {
        case "mainToRoom":
            let roomVC = segue.destination as! RoomViewController
            roomVC.roomName = roomName
            roomVC.delegate = self
        case "mainToPlayback":
            let playbackVC = segue.destination as! PlaybackViewController
            playbackVC.roomName = roomName
            playbackVC.delegate = self
        default:
            break
        }
        
    }
    
    @IBAction func doRoomNameTextFieldEditing(_ sender: UITextField) {
        if let text = sender.text , !text.isEmpty {
            let legalString = MediaCharacter.updateToLegalMediaString(from: text)
            sender.text = legalString
        }
    }
    
    @IBAction func doJoinPressed(_ sender: UIButton) {
        showRoleSelection()
    }
}

private extension MainViewController {
    func showRoleSelection() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let singer = UIAlertAction(title: "As Singer", style: .default) { [weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.enter(roomName: strongSelf.roomNameTextField.text, type: .singer)
        }
        let playback = UIAlertAction(title: "Playback", style: .default) { [weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.enter(roomName: strongSelf.roomNameTextField.text, type: .playback)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(singer)
        sheet.addAction(playback)
        sheet.addAction(cancel)
        sheet.popoverPresentationController?.sourceView = popoverSourceView
        sheet.popoverPresentationController?.permittedArrowDirections = .up
        present(sheet, animated: true, completion: nil)
    }
    
    func enter(roomName: String?, type: EnterType) {
        guard let roomName = roomName , !roomName.isEmpty else {
            return
        }
        switch type {
        case .singer:
            performSegue(withIdentifier: "mainToRoom", sender: roomName)
        case .playback:
            performSegue(withIdentifier: "mainToPlayback", sender: roomName)
        }
    }
}

extension MainViewController: RoomVCDelegate, PlaybackVCDelegate {
    func playbackVCNeedClose(_ roomVC: PlaybackViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func roomVCNeedClose(_ roomVC: RoomViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        showRoleSelection()
        return true
    }
}
