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
            title = "#\(h.Number)"
            hymnNumber.text = "\(h.Number)"
            hymnTitle.text = h.Title
            hymnContent.text = h.Content
        }

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closePressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func musicSheetPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.Segue.ShowMusicSheet, sender: hymn)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case K.Segue.ShowMusicSheet:
            if let destination = segue.destination as? MusicSheetViewController, let h = sender as? Hymn {
                
                destination.hymn = h
            }
            
        default:
            break
        }
    }

}
