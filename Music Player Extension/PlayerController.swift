//
//  PlayerController.swift
//  Music Player Extension
//
//  Created by takumi saito on 2018/10/26.
//  Copyright © 2018 takpika. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation

class PlayerController: WKInterfaceController {

    @IBOutlet weak var BTgroup: WKInterfaceGroup!
    @IBOutlet weak var BTFwd: WKInterfaceButton!
    @IBOutlet weak var BTPlayPause: WKInterfaceButton!
    @IBOutlet weak var BTNext: WKInterfaceButton!
    @IBOutlet weak var MusicNameLabel: WKInterfaceLabel!
    @IBOutlet weak var PlayingLabel: WKInterfaceLabel!
    var engine = AVAudioEngine()
    var audioPlayerNode = AVAudioPlayerNode()
    var audioFile : AVAudioFile!
    //let main = InterfaceController()
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if(context != nil){
            print(context as Any)
            MusicNameLabel.setText(context as? String)
            let documentDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true).last!
            let fullpath = "\(documentDir)/\(context as! String)"
            let Filepath = URL(fileURLWithPath: fullpath)
            // Configure interface objects here.
            audioFile = try! AVAudioFile(forReading: Filepath)
            engine.attach(audioPlayerNode)
            engine.connect(audioPlayerNode, to: engine.mainMixerNode, format: audioFile!.processingFormat)
            try! engine.start()
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func PushPlayButton() {
        do{
            if audioPlayerNode.isPlaying{
                audioPlayerNode.pause()
                PlayingLabel.setText("一時停止")
                //setTitle("一時停止")
                BTNext.setTitle("▶︎")
            }else{
                audioPlayerNode.scheduleFile(audioFile!, at: nil, completionHandler: nil)
                audioPlayerNode.play()
                PlayingLabel.setText("再生中")
                //setTitle("再生中")
                BTNext.setTitle("■")
                
            }
        }catch{
            print("PlayError")
        }
    }
    
    @IBAction func PushFwdButton() {
        let AVTime:AVAudioTime = AVAudioTime.init(hostTime: 0)
        if audioPlayerNode.isPlaying{
            audioPlayerNode.play(at: AVTime)
            BTNext.setTitle("■")
        }else{
            audioPlayerNode.play(at: AVTime)
            audioPlayerNode.pause()
            BTNext.setTitle("▶︎")
        }
    }
}
