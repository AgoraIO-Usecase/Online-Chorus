//
//  PlaybackViewController.swift
//  AgoraOnlineChorus
//
//  Created by ZhangJi on 2019/3/22.
//  Copyright © 2019 ZhangJi. All rights reserved.
//

import UIKit
import AgoraAudioKit

enum MixingStatus {
    case stopped, mixing, paused
}

protocol PlaybackVCDelegate: class {
    func playbackVCNeedClose(_ roomVC: PlaybackViewController)
}

class PlaybackViewController: UIViewController {
    
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var musicTableView: UITableView!
    @IBOutlet weak var muteAudioButton: UIButton!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var processSlider: UISlider!
    @IBOutlet weak var processLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var musicVolumeSlider: UISlider!
    
    
    var roomName: String!
    var musicNames = ["两只老虎", "我只在乎你"]
    
    fileprivate var agoraKit: AgoraRtcEngineKit!
    weak var delegate: PlaybackVCDelegate?
    
    var playingIndex: Int = -1
    
    fileprivate var audioMuted = true {
        didSet {
            DispatchQueue.main.async {
                self.muteAudioButton?.setImage(UIImage(named: self.audioMuted ? "btn_mute_blue" : "btn_mute"), for: UIControl.State())
            }
            
            agoraKit.muteLocalAudioStream(audioMuted)
        }
    }
    
    fileprivate var speakerEnabled = true {
        didSet {
            DispatchQueue.main.async {
                self.speakerButton?.setImage(UIImage(named: self.speakerEnabled ? "btn_speaker_blue" : "btn_speaker"), for: UIControl.State())
                self.speakerButton?.setImage(UIImage(named: self.speakerEnabled ? "btn_speaker" : "btn_speaker_blue"), for: .highlighted)
                
            }
            
            agoraKit.setEnableSpeakerphone(speakerEnabled)
        }
    }
    
    fileprivate var mixingStatus: MixingStatus = .stopped {
        didSet {
            DispatchQueue.main.async {
                self.updateView(withMixingStatus: self.mixingStatus)
            }
        }
    }
    
    fileprivate var musicPath: String?
    
    fileprivate var progressTimer: DispatchSourceTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomNameLabel.text = "\(roomName!)"
        
        loadAgoraKit()
    }
    
    @IBAction func doPlayPressed(_ sender: UIButton) {
        switch mixingStatus {
        case .stopped:
            guard let path = musicPath else { return }
            agoraKit.startAudioMixing(path, loopback: false, replace: true, cycle: 1)
            audioMuted = false
            mixingStatus = .mixing
        case .mixing:
            agoraKit.pauseAudioMixing()
            audioMuted = true
            mixingStatus = .paused
        case .paused:
            agoraKit.resumeAudioMixing()
            audioMuted = false
            mixingStatus = .mixing
        }
    }
    
    @IBAction func doStopPressed(_ sender: UIButton) {
        agoraKit.stopAudioMixing()
        audioMuted = true
        mixingStatus = .stopped
    }
    
    @IBAction func doPlayVolumeChanged(_ sender: UISlider) {
        let volume = Int(sender.value)
        agoraKit.adjustAudioMixingPublishVolume(volume)
//        agoraKit.adjustAudioMixingVolume(volume)
    }
    
    @IBAction func doMuteAudioPressed(_ sender: UIButton) {
        audioMuted = !audioMuted
    }
    
    @IBAction func doSpeakerPressed(_ sender: UIButton) {
        speakerEnabled = !speakerEnabled
    }
    
    @IBAction func doClosePressed(_ sender: UIButton) {
        leaveChannel()
    }
    
    @IBAction func doProcessChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        agoraKit.setAudioMixingPosition(value)
    }
    
    @IBAction func doPlayoutChanged(_ sender: UISwitch) {
        agoraKit.adjustAudioMixingPlayoutVolume(sender.isOn ? 100 : 0)
    }
}

private extension PlaybackViewController {
    func loadAgoraKit() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: self)
        
        agoraKit.muteAllRemoteAudioStreams(true)
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        agoraKit.muteLocalAudioStream(true)
        
        agoraKit.setParameters("{\"che.audio.lowlatency\":true}")
        agoraKit.setParameters("{\"rtc.lowlatency\":1}")
        
        agoraKit.joinChannel(byToken: nil, channelId: roomName, info: nil, uid: 0, joinSuccess: nil)
    }
    
    func leaveChannel() {
        agoraKit.leaveChannel(nil)
        delegate?.playbackVCNeedClose(self)
    }
}

private extension PlaybackViewController {
    func updateView(withMixingStatus status: MixingStatus) {
        stopButton.isHidden = (status == .stopped)
        playButton.setImage((status == .mixing ? #imageLiteral(resourceName: "pause") : #imageLiteral(resourceName: "play")), for: .normal)
        if status == .stopped {
            stopUpdatingMixProgressView()
        } else {
            startUpdatingMixProgressView()
        }
    }
    
    func startUpdatingMixProgressView() {
        progressTimer = DispatchSource.makeTimerSource()
        progressTimer?.schedule(deadline: .now(), repeating: .seconds(1))
        
        progressTimer?.setEventHandler(handler: {
            let duration = self.agoraKit.getAudioMixingDuration()
            let position = self.agoraKit.getAudioMixingCurrentPosition()
            
            if Int(position / 1000) == Int(duration / 1000) {
                self.doStopPressed(self.stopButton)
                return
            }
            
            DispatchQueue.main.async {
                if duration > 0 {
                    self.processSlider?.maximumValue = Float(duration)
                    self.processSlider?.setValue(Float(position), animated: true)
                }
                
                self.processLabel?.text = "\(Int(position / 1000)) / \(Int(duration / 1000))"
            }
        })
        
        progressTimer?.resume()
    }
    
    func stopUpdatingMixProgressView() {
        progressTimer = nil
        processSlider?.value = 0
        processLabel?.text = "0/0"
    }
}

extension PlaybackViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        agoraKit.adjustAudioMixingPublishVolume(10)
    }
}

extension PlaybackViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicInfoCell") as! MusicInfoCell
        cell.musicNameLabel.text = musicNames[indexPath.row]
        cell.accessoryType = indexPath.row == playingIndex ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.doStopPressed(stopButton)
        
        let cell = tableView.cellForRow(at: indexPath) as! MusicInfoCell
        guard  let path = Bundle.main.path(forResource: cell.musicNameLabel.text, ofType: "mp3") else {
            return
        }
        self.musicPath = path
        cell.accessoryType = .checkmark
        
        let playingCell = tableView.cellForRow(at: IndexPath(row: self.playingIndex, section: 0))
        playingCell?.accessoryType = .none
        
        self.playingIndex = indexPath.row
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
