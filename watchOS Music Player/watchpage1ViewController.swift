//
//  watchpage1ViewController.swift
//  watchOS Music Player
//
//  Created by takumi saito on 2018/11/19.
//  Copyright © 2018 takpika. All rights reserved.
//

import UIKit
import WatchConnectivity

class watchpage1ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    var Files:[String] = []
    @IBOutlet weak var PlusBT: UIBarButtonItem!
    @IBOutlet weak var TView: UITableView!
    @IBOutlet weak var NoneFileLabel: UILabel!
    @IBOutlet weak var ReloadBT: UIBarButtonItem!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Files.count
    }
    
    @IBAction func ReloadButton(_ sender: Any) {
        update()
        TView.reloadData()
    }
    
    /*func session(session: WCSession, didReceiveApplicationContext applicationContext: [String:String]){
        Files = []
        for (title,fileName) in applicationContext{
            Files.append(fileName)
        }
        TView.reloadData()
    }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if(Files.count != 0){
            cell.textLabel!.text = Files[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toFileViewer", sender: Files[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFileViewer"{
            let fileviewer = segue.destination as! watchFileViewController
            fileviewer.FileName = sender as! String
        }
    }
    
    func update(){
        if(WCSession.isSupported()){
            let session = WCSession.default
            session.delegate = self
            session.activate()
            if(session.isPaired){
                if(session.isReachable){
                    let Mes = ["GET":"Files"]
                    session.sendMessage(Mes, replyHandler: {(reply) -> Void in
                        print(reply)
                        self.Files.removeAll()
                        for (Name,_) in reply as! [String:String]{
                            self.Files.append(Name)
                            self.checkFiles()
                        }
                    }, errorHandler: {(Error) -> Void in
                        print(Error)
                    })
                    //checkFiles()
                }
            }
        }
    }
    
    func checkFiles(){
        if Files.count == 0{
            TView.isHidden = true
            NoneFileLabel.isHidden = false
        }else{
            TView.isHidden = false
            NoneFileLabel.isHidden = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        checkFiles()
        update()
        if WCSession.isSupported(){
            let session = WCSession.default
            if session.isPaired{
                PlusBT.isEnabled = true
                ReloadBT.isEnabled = true
            }else{
                PlusBT.isEnabled = false
                ReloadBT.isEnabled = false
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func PlusButton(_ sender: Any) {
        
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
