//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Daniel A Wahby on 5/29/19.
//  Copyright © 2019 Danny. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController,AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var stopRecordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordButton.isEnabled=false
        darkModeSwitch.isOn=false
        
    }
    override func  viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        recordLabel.text="Recording Audio"
        recordButton.isEnabled=false
        stopRecordButton.isEnabled=true
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
                audioRecorder.delegate=self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
                audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recordButton.isEnabled=true
        stopRecordButton.isEnabled=false
        recordLabel.text="Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)

    }
    @IBAction func toggleDarkMode(_ sender: Any) {
        if(darkModeSwitch.isOn){
            view.backgroundColor = UIColor.black
            darkModeLabel.textColor=UIColor.white
            recordLabel.textColor=UIColor.white
            self.view.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.view.backgroundColor = UIColor.red
            
        }
        else{
            view.backgroundColor = UIColor.white
            darkModeLabel.textColor=UIColor.black
            recordLabel.textColor=UIColor.black
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black.withAlphaComponent(0.5)]
            
                    }

    }
}

