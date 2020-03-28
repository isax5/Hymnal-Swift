//
//  HymnViewController.swift
//  Hymnal.iOS
//
//  Created by Isaac Rebolledo Leal on 28-03-20.
//

import UIKit

class HymnViewController: UIViewController {
    @IBOutlet weak var hymnNumber: UILabel!
    @IBOutlet weak var hymnTitle: UILabel!
    @IBOutlet weak var hymnContent: UILabel!
    
    var hymn: Hymn?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let h = hymn {
            hymnNumber.text = "\(h.Number)"
            hymnTitle.text = h.Title
            hymnContent.text = h.Content
        }

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closePressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
