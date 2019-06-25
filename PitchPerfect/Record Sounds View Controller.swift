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
    var darkModeSetting: Bool!
    var recordingSession : AVAudioSession!
    var ready : Bool!
    // MARK: Defining Outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    // MARK: Recording State
    enum recordingState { case active , inactive, idle }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(.idle)
        
    }
    override func  viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
            try recordingSession.setActive(true, options: .notifyOthersOnDeactivation)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.ready = true
                    } else {
                        self.ready = false
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    // MARK: UI Functions
    func configureUI(_ recordState: recordingState){
        switch recordState {
        case .active:
            recordLabel.text="Recording Audio"
            recordButton.isEnabled=false
            stopRecordButton.isEnabled=true
        case .inactive:
            recordButton.isEnabled=true
            stopRecordButton.isEnabled=false
            recordLabel.text="Tap to Record"
        case .idle:
            darkModeSetting=false
            stopRecordButton.isEnabled=false
            darkModeSwitch.isOn=false
        }
    }
    
    // MARK: Starting Audio Recording
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(.active)
        if ready {
            
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))
            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
                audioRecorder.delegate=self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
                audioRecorder.record()
        }
        else
        {
            print("Boo Hoo")
        }
    }
    
    // MARK: Stopping Audio Recording
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(.inactive)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)

    }
    
    // MARK: Dark Mode Handling
    @IBAction func toggleDarkMode(_ sender: Any) {
        if(darkModeSwitch.isOn){
            view.backgroundColor = UIColor.black
            darkModeLabel.textColor=UIColor.white
            recordLabel.textColor=UIColor.white
            view.backgroundColor = UIColor.black
            navigationController?.navigationBar.barTintColor = UIColor.black
            navigationController?.navigationBar.barStyle = .black
            darkModeSetting = true
        }
        else{
            view.backgroundColor = UIColor.white
            darkModeLabel.textColor=UIColor.black
            recordLabel.textColor=UIColor.black
        navigationController?.navigationBar.barTintColor = UIColor.white
            navigationController?.navigationBar.barStyle = .default

    navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black.withAlphaComponent(0.5)]
            darkModeSetting = false
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            print("Recorded successfully")
        }
        else{
            print("Recording could not be saved")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            playSoundsVC.goDark = darkModeSetting
        }
    }
}

