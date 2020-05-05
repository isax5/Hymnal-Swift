//
//  NumberViewController.swift
//  Hymnal.iOS
//
//  Created by Isaac Rebolledo Leal on 28-03-20.
//

import UIKit

class NumberViewController: UIViewController {
    
    let hymnManager = HymnManager.sharedInstance
    
    @IBOutlet weak var numberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        numberTextField.delegate = self
    }
    
    
    @IBAction func openButtonPressed(_ sender: UIButton) {
        
        if let text = numberTextField.text, let number = Int(text) {
            
            // Fetch hymn
            hymnManager.FetchHymn(number: number, language: hymnManager.debugLanguage) { (hymn) in
                self.performSegue(withIdentifier: K.Segue.ShowHymn, sender: hymn)
            }
            
        } else {
            
            numberTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // TODO: Make standard segue preparetion for this specific implementation
        switch segue.identifier {
        case K.Segue.ShowHymn:
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

//MARK: - UITextFieldDelegate
extension NumberViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        let allowedCharacters = CharacterSet(charactersIn:"0123456789")
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

