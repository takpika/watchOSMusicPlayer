//
//  InterfaceController.swift
//  Music Player Extension
//
//  Created by takumi saito on 2018/10/26.
//  Copyright © 2018 takpika. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate{
    var ls : [String] = []
    let documentDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true).last!
    @IBOutlet weak var TableView: WKInterfaceTable!
    @IBOutlet weak var NoFileLabel: WKInterfaceLabel!
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    /*private func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : String]) {
        if(applicationContext == ["GET":"Files"]){
            var sendls : [String:String] = [:]
            do{
                for i in 0..<ls.count{
                    sendls["\(i)"] = ls[i]
                }
                try WCSession.default.updateApplicationContext(sendls)
            }catch{
                print("Error")
            }
        }
    }*/
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if(message as! [String:String] == ["GET":"Files"]){
            var sendls : [String:String] = [:]
            do{
                for i in 0..<ls.count{
                    sendls["\(ls[i])"] = "\(i)"
                }
                if(session.isReachable){
                    replyHandler(sendls)
                }
            }catch{
                print("Error")
            }
        }
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile)
    {
        //Test
        let manager = FileManager.default
        let documentDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true).last!
        let documenturl = URL(fileURLWithPath: "\(documentDir)/\(file.fileURL.lastPathComponent)")
        print(documentDir)
        print(documenturl)
        print(file.fileURL.absoluteURL)
        do{
            try manager.moveItem(at: file.fileURL.absoluteURL, to: documenturl)
            do{
                let list = try manager.contentsOfDirectory(atPath: documentDir)
                ls = []
                //print(list)
                for path in list{
                    let strpath = path as String
                    if(strpath.localizedCaseInsensitiveContains(".mp3") || strpath.localizedCaseInsensitiveContains(".m4a") || strpath.localizedCaseInsensitiveContains(".wav")){
                        ls += ["\(strpath)"]
                    }
                }
                print(ls)
            }catch{
                print("Error:2")
            }
            if ls.count != 0{
                setupTable()
            }else{
                NoFileLabel.setHidden(false)
            }
            //let data = NSData(contentsOf: file.fileURL)
        }catch{
            print("Error:1")
        }
        
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        let session = WCSession.default
        session.delegate = self
        session.activate()
        print(session.activationState.rawValue)
        let manager = FileManager.default
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
        if ls.count != 0{
            setupTable()
        }else{
            NoFileLabel.setHidden(false)
        }
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        presentController(withName: "PlayerController", context: "\(ls[rowIndex])")
        
    }
    
    func setupTable(){
        TableView.setNumberOfRows(ls.count, withRowType: "TableRow")
        NoFileLabel.setHidden(true)
        /*for i in 0..<ls.count{
            if let row = TableView.rowController(at: i) as? TableRowController{
                row.dataLabel.setText(ls[i])
            }
        }*/
        for index in 0..<self.TableView.numberOfRows{
            let row = self.TableView.rowController(at: index) as! TableRowController
            row.dataLabel.setText(self.ls[index])
        }
    }
}
