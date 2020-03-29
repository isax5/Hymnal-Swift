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
                performSegue(withIdentifier: "showHymn", sender: hymn)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showHymn":
            if let navVC = segue.destination as? UINavigationController {
                if let destination = navVC.viewControllers.first as? HymnViewController {
                    destination.hymn = sender as? Hymn ?? nil
                }
            }
        default:
            return
        }
        
//        switch segue.destination {
//        case let destination as HymnViewController:
//            destination.hymn = sender as? Hymn ?? nil
//            break
//        default:
//            break
//        }
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
