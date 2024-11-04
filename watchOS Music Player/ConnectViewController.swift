//
//  ConnectViewController.swift
//  watchOS Music Player
//
//  Created by takumi saito on 2018/10/29.
//  Copyright © 2018 takpika. All rights reserved.
//

import UIKit
import WatchConnectivity

class ConnectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var ls : [String] = []
    @IBOutlet weak var TView: UITableView!
    @IBOutlet weak var NoneFileLabel: UILabel!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel!.text = ls[indexPath.row]
        //cell.textLabel!.text = "test"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toMusic", sender: ls[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMusic"{
            let MusicVC = segue.destination as! MusicViewController
            MusicVC.FileName = sender as! String
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let manager = FileManager.default
        let documentDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true).last!
        do{
            let list = try manager.contentsOfDirectory(atPath: documentDir)
            //print(list)
            for path in list{
                let strpath = path as String
                if(strpath.localizedCaseInsensitiveContains(".mp3") || strpath.localizedCaseInsensitiveContains(".m4a") || strpath.localizedCaseInsensitiveContains(".wav")){
                    ls += ["\(strpath)"]
                }
            }
            print(ls)
        }catch{
            print("Error")
        }
        if ls.count == 0{
            TView.isHidden = true
            NoneFileLabel.isHidden = false
        }else{
            TView.isHidden = false
            NoneFileLabel.isHidden = true
        }

        // Do any additional setup after loading the view.
    }
    @IBAction func SendBT(_ sender: Any) {
        if WCSession.isSupported(){
            let session = WCSession.default
            if session.isPaired{
                let transferFile: NSURL = NSURL(fileURLWithPath: "")
                WCSession.default.transferFile(transferFile as URL, metadata: nil)
            }else{
                let alert: UIAlertController = UIAlertController(title: "接続が切れました", message: "Apple Watchとの接続が切れたため通信できませんでした。", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    self.performSegue(withIdentifier: "toMain", sender: nil)
                }))
                present(alert, animated: true, completion: nil)
                performSegue(withIdentifier: "toMain", sender: nil)
            }
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
