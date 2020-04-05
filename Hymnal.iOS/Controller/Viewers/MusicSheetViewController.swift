//
//  MusicSheetViewController.swift
//  Hymnal.iOS
//
//  Created by Isaac Rebolledo Leal on 04-04-20.
//

import UIKit

class MusicSheetViewController: UIViewController {
    
    var hymn: Hymn?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let h = hymn {
            title = "#\(h.Number)"
        }
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
