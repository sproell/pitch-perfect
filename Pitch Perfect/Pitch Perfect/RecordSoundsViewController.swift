//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Steve Proell on 3/12/15.
//  Copyright (c) 2015 Steve Proell. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var paused:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        resetView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        println("in recordAudio")
        
        if (paused) {
            // if we're paused and the user tapped record, we're no longer paused
            paused = false
        }
        else {
            // if we're not in paused state, we need to initialize the recorder
            prepareRecorder()
        }
        
        updateViewForRecording()
        audioRecorder.record()
    }
    
    @IBAction func pauseAudio(sender: UIButton) {
        println("in pauseAudio")
        
        // update the view to reflect our paused state
        paused = true
        pauseButton.enabled = false
        recordButton.enabled = true
        recordingLabel.text = "Tap mic to resume"
        
        audioRecorder.pause()
    }

    @IBAction func stopAudio(sender: UIButton) {
        // Stop recording and deactivate audio session
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

    func updateViewForRecording() {
        // show and activate the stop button
        stopButton.enabled = true
        stopButton.hidden = false
        
        // show and activate the pause button
        pauseButton.enabled = true
        pauseButton.hidden = false
        
        // disable the record button
        recordButton.enabled = false
        
        // tell the user we're recording
        recordingLabel.text = "Recording..."
    }
    
    // set view to its initial ready-to-record state
    func resetView() {
        stopButton.hidden = true
        pauseButton.hidden = true
        recordButton.enabled = true
        recordingLabel.text = "Tap to Record"
    }
    
    func prepareRecorder() {
        println("in prepareRecorder")
        
        // Create file path where audio file will be saved.
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // Setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Create audio recorder and start recording
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(fromFilePathUrl: recorder.url, withTitle: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopAudio", sender: recordedAudio)
        }
        else {
            println("Recording was not successful")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopAudio") {
            
            // set recorded audio object on play sounds view controller
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}

