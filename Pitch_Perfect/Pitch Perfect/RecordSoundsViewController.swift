//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Paul Christenson on 8/18/15.
//  Copyright (c) 2015 Paul Christenson. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {
    
    
    @IBOutlet weak var NowRecording: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var StopRecording: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        StopRecording.hidden = true
        recordButton.enabled = true
        NowRecording.text = "Tap to Record"
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        NowRecording.text = "Recording..."
        StopRecording.hidden = false
        
        // Recording Audio Code
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        }catch _ {
            NowRecording.text = "Oops, Internal Error"
        }
        
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func StopRecording(sender: UIButton) {
        //    NowRecording.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance();
        do{
            try audioSession.setActive(false)
        }catch _ {
            NowRecording.text = "Oops, Internal Error"
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            let session = AVAudioSession.sharedInstance()
            do{
                try session.setCategory(AVAudioSessionCategoryPlayback)
            }catch _ {
                NowRecording.text = "Oops, Recording Error"
            }
            recordedAudio = RecordedAudio(filePathUrl:recorder.url, title:recorder.url.lastPathComponent)
            
            performSegueWithIdentifier("stopRecording", sender:recordedAudio)
            
        }else{
            print("Recording was not successful")
            recordButton.enabled = true
            StopRecording.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="stopRecording"){
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            playSoundsVC.receievedAudio = data
        }
    }
    
}