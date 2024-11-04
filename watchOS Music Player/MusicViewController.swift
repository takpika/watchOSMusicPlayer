//
//  MusicViewController.swift
//  watchOS Music Player
//
//  Created by takumi saito on 2018/11/19.
//  Copyright © 2018 takpika. All rights reserved.
//

import UIKit
import AVFoundation
import WatchConnectivity

class MusicViewController: UIViewController, AVAudioPlayerDelegate, WCSessionDelegate{
    @IBOutlet weak var SendingLabel: UILabel!
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    var audioPlayer : AVAudioPlayer!
    var FileName = ""
    var FilePath = ""
    var path = URL(fileURLWithPath: "")
    let manager = FileManager.default
    @IBOutlet weak var MusicLabel: UILabel!
    @IBOutlet weak var TestCtrl : UIControl!
    
    @IBOutlet weak var SendBT: UIBarButtonItem!
    @IBOutlet weak var SendBT2: UIButton!
    @IBOutlet weak var PushedView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        SendBT2.layer.cornerRadius = 25.0
        PushedView.layer.cornerRadius = 25.0
        PushedView.layer.borderColor = UIColor.black.cgColor
        PushedView.layer.borderWidth = 1.0
        MusicLabel.text = FileName
        FilePath = "\(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true).last!)/\(FileName)"
        path = URL(fileURLWithPath: FilePath)
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }catch{
            print("Error")
        }
        let session = WCSession.default
        if WCSession.isSupported(){
            if session.isPaired{
                SendBT2.isEnabled = true
            }else{
                SendBT2.isEnabled = false
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var PlayBT: UIButton!
    @IBAction func PlayButton(_ sender: Any) {
        if audioPlayer.isPlaying{
            audioPlayer.stop()
            PlayBT.setTitle("▶︎", for: .normal)
        }else{
            audioPlayer.play()
            PlayBT.setTitle("■", for: .normal)
        }
    }
    
    func SendData(){
        let session = WCSession.default
        session.delegate = self
        session.activate()
        if WCSession.isSupported(){
            if session.isPaired{
                session.transferFile(path, metadata: nil)
                print(session.isReachable)
            }else{
                let alert: UIAlertController = UIAlertController(title: "接続が切れました", message: "Apple Watchとの接続が切れたため通信できませんでした。", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func sendButton(_ sender: Any) {
        
    }
    @IBAction func SendButton2(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
                self.PushedView.alpha = 1
            }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveLinear, animations: {
                self.PushedView.alpha = 0
        }, completion: nil)
        SendData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        audioPlayer.stop()
    }
    
    @IBAction func DeleteButton(_ sender: Any) {
        do{
            try manager.removeItem(atPath: FilePath)
            performSegue(withIdentifier: "toFileManager", sender: nil)
        }catch{
            print("Can't Remove")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
