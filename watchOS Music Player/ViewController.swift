//
//  ViewController.swift
//  watchOS Music Player
//
//  Created by takumi saito on 2018/10/26.
//  Copyright © 2018 takpika. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    

    @IBOutlet weak var ConnectButton: UIButton!
    @IBAction func ConnectBT(_ sender: Any) {
        //performSegue(withIdentifier: "nextSegue", sender: nil)
    }
    @IBOutlet weak var ConnectionLabel: UILabel!
    @IBOutlet weak var ConnectionImage: UIImageView!
    @IBOutlet weak var DebugLabel1: UILabel!
    @IBOutlet weak var DebugLabel2: UILabel!
    @IBOutlet weak var DebugLabel3: UILabel!
    @IBOutlet weak var DebugLabel4: UILabel!
    let isDebug = false
    @IBAction func refleshButton(_ sender: Any) {
        if WCSession.isSupported(){
            let checkImage = UIImage(named: "Check.png")
            let pekeImage = UIImage(named: "Peke.png")
            let session = WCSession.default
            session.delegate = self
            session.activate()
            if isDebug{
                DebugLabel1.isHidden = false
                DebugLabel2.isHidden = false
                DebugLabel3.isHidden = false
                DebugLabel4.isHidden = false
                DebugLabel1.text = "isSupported: \(WCSession.isSupported())"
                DebugLabel2.text = "isPaired: \(session.isPaired)"
                DebugLabel3.text = "isWatchAppInstalled: \(session.isWatchAppInstalled)"
                DebugLabel4.text = "activationState.rawValue:\(session.activationState.rawValue)"
                print(DebugLabel1.text!)
                print(DebugLabel2.text!)
                print(DebugLabel3.text!)
                print(DebugLabel4.text!)
            }else{
                DebugLabel1.isHidden = true
                DebugLabel2.isHidden = true
                DebugLabel3.isHidden = true
                DebugLabel4.isHidden = true
            }
            if session.isWatchAppInstalled{
                ConnectionLabel.text = "Appはインストール済です。"
                ConnectionImage.image = checkImage
                ConnectButton.isHidden = false
                print("接続")
            }else{
                ConnectionLabel.text = "Appがインストールされていません。"
                ConnectionImage.image = pekeImage
                ConnectButton.isHidden = true
                print("未接続")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if WCSession.isSupported(){
            let checkImage = UIImage(named: "Check.png")
            let pekeImage = UIImage(named: "Peke.png")
            let session = WCSession.default
            session.delegate = self
            session.activate()
            if isDebug{
                DebugLabel1.isHidden = false
                DebugLabel2.isHidden = false
                DebugLabel3.isHidden = false
                DebugLabel4.isHidden = false
                DebugLabel1.text = "isSupported: \(WCSession.isSupported())"
                DebugLabel2.text = "isPaired: \(session.isPaired)"
                DebugLabel3.text = "isWatchAppInstalled:\(session.isWatchAppInstalled)"
                DebugLabel4.text = "activationState.rawValue:\(session.activationState.rawValue)"
                print(DebugLabel1.text!)
                print(DebugLabel2.text!)
                print(DebugLabel3.text!)
                print(DebugLabel4.text!)
            }else{
                DebugLabel1.isHidden = true
                DebugLabel2.isHidden = true
                DebugLabel3.isHidden = true
                DebugLabel4.isHidden = true
            }
            if session.isWatchAppInstalled{
                ConnectionLabel.text = "Appはインストール済です。"
                ConnectionImage.image = checkImage
                ConnectButton.isHidden = false
                print("接続")
            }else{
                ConnectionLabel.text = "Appがインストールされていません。"
                ConnectionImage.image = pekeImage
                ConnectButton.isHidden = true
                print("未接続")
            }
        }
        let manager = FileManager.default
        let documentDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true).last!
        let locate = "\(documentDir)/Inbox"
        //let locate = "/"
        print("Index of \(locate)")
        do{
            let list = try manager.contentsOfDirectory(atPath: locate)
            for path in list{
                print(path as String)
                let filelocate = URL(fileURLWithPath: "\(locate)/\(path as String)")
                let tofilelocate = URL(fileURLWithPath: "\(documentDir)/\(path as String)")
                try manager.moveItem(at: filelocate, to: tofilelocate)
            }
        }catch{
            print("Error")
        }
    }
}


