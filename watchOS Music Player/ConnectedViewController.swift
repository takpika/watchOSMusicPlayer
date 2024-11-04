//
//  ConnectedViewController.swift
//  watchOS Music Player
//
//  Created by takumi saito on 2018/10/27.
//  Copyright © 2018 takpika. All rights reserved.
//

import UIKit
//import WatchConnectivity

class ConnectedViewController: UIViewController/*, WCSessionDelegate*/ {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("接続画面起動")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SendBT(_ sender: Any) {
        print("Pushed Button")
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
