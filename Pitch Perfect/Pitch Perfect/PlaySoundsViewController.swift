//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Steve Proell on 3/15/15.
//  Copyright (c) 2015 Steve Proell. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    var audioPlayer: AVAudioPlayer!
    var echoPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize the audio player and audio engine using the recorded audio file
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        // initialize second player for echo effect
        echoPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        echoPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func slowPlayback(sender: UIButton) {
        println("in slowPlayback")
        play(0.5, false)
    }
    
    @IBAction func fastPlayback(sender: UIButton) {
        println("in fastPlayback")
        play(2.0, false)
    }
    
    @IBAction func chipmunkPlayback(sender: UIButton) {
        println("in chipmunkPlayback")
        playWithVariablePitch(1000)
    }
    
    @IBAction func vaderPlayback(sender: UIButton) {
        println("in vaderPlayback")
        playWithVariablePitch(-1000)
    }
    
    @IBAction func echoPlayback(sender: UIButton) {
        println("in echoPlayback")
        play(1.0, true)
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        println("in stopPlayback")
        stopAndResetAudio()
    }
    
    // play audio with desired rate
    func play(rate: Float, _ playWithEcho: Bool) {
        stopAndResetAudio()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0
        audioPlayer.play()
        
        if (playWithEcho) {
            var playbackDelay:NSTimeInterval = 0.1 + echoPlayer.deviceCurrentTime
            echoPlayer.rate = rate
            echoPlayer.currentTime = 0
            echoPlayer.playAtTime(playbackDelay)
        }
    }
    
    // play audio with desired pitch
    func playWithVariablePitch(pitch: Float) {
        stopAndResetAudio()

        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    // ensure both player and engine are stopped and reset
    func stopAndResetAudio() {
        audioPlayer.stop()
        echoPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}
