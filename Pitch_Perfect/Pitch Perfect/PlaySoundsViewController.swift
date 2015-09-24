//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Paul Christenson on 9/14/15.
//  Copyright (c) 2015 Paul Christenson. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var receievedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading:receievedAudio.filePathUrl)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func PlayAudioSlow(sender: UIButton) {
        PlayAudioWithPitch(8.0, rate:0.5)
    }

    @IBAction func PlayAudioFast(sender: UIButton) {
        PlayAudioWithPitch(8.0, rate:2.0)
    }
    
    @IBAction func PlayChipmunkSound(sender: UIButton) {
        PlayAudioWithPitch(1000, rate:1.0)
    }
    
    @IBAction func PlayVaderSound(sender: UIButton) {
        PlayAudioWithPitch(-1000, rate:1.0)
    }
    @IBAction func StopAudio(sender: UIButton) {
        audioEngine.stop()
    }

    func PlayAudioWithPitch(pitch:Float, rate:Float){
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode =  AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        
        changePitchEffect.pitch = pitch
        changePitchEffect.rate = rate
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to:audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        }catch _ {
            print("Play Audio was not Successful")
        }
        audioPlayerNode.play()
    }
}