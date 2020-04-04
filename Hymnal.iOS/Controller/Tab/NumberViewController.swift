//
//  NumberViewController.swift
//  Hymnal.iOS
//
//  Created by Isaac Rebolledo Leal on 28-03-20.
//

import UIKit

class NumberViewController: UIViewController {
    @IBOutlet weak var numberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func openButtonPressed(_ sender: UIButton) {
        if let number = numberTextField.text {
            
            if number.isEmpty {
                numberTextField.becomeFirstResponder()
            }
            else {
                let hymn = Hymn(Number: Int(number) ?? 0, Title: "Titulo de prueba", Content: "Contenido de prueba")
                performSegue(withIdentifier: K.Segue.ShowHymnal, sender: hymn)
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case K.Segue.ShowHymnal:
            if let navVC = segue.destination as? UINavigationController,
                let destination = navVC.viewControllers.first as? HymnViewController,
                let h = sender as? Hymn {
                
                destination.hymn = h
            }
            
        default:
            break
        }
        
    }

}
