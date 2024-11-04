//
//  watchFileViewController.swift
//  watchOS Music Player
//
//  Created by takumi saito on 2018/11/20.
//  Copyright © 2018 takpika. All rights reserved.
//

import UIKit

class watchFileViewController: UIViewController {
    
    var FileName = ""
    @IBOutlet weak var FileLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        FileLabel.text = FileName
        // Do any additional setup after loading the view.
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
