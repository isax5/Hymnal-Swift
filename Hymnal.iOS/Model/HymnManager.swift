//
//  HymnalManager.swift
//  Hymnal.iOS
//
//  Created by Isaac Rebolledo Leal on 04-04-20.
//
//
// Documentation Keywords
//
//- Attention: Watch out for this!
//- Author: Tim Cook
//- Authors:
//  John Doe
//  Mary Jones
//- Bug: This may not work
//- Complexity: O(log n) probably
//- Copyright: 2016 Acme
//- Date: Jan 1, 2016
//- experiment: give it a try
//- important: know this
//- invariant: something
//- Note: Blah blah blah
//- Precondition: alpha should not be nil
//- Postcondition: happy
//- Remark: something else
//- Requires: iOS 9
//- seealso: something else
//- Since: iOS 9
//- Todo: make it faster
//- Version: 1.0.0
//- Warning: Don't do it

import UIKit
import Foundation

protocol HymnManagerDelegate {
    func hymnLoaded(_ hymn: [Hymn])
}

class HymnManager {
    private static var hymnal: [Hymn]?
    
    let debugLanguage = HymnalLanguage(Id: "", TwoLetterISOLanguageName: "", Name: "", Detail: "", HymnsFileName: "", ThematicHymnsFileName: "", SungMusic: "", InstrumentalMusic: "", HymnsSheetsFileName: "")
    
    private let serialQueue = DispatchQueue(label: "Serial Queue") // custom dispatch queues are serial by default
    
    private var delegate: HymnManagerDelegate?
    
    
    public static let sharedInstance: HymnManager = {
        return HymnManager()
    }()
    
    private init() {
        print("Creating a instance of: HymnManager")
    }
    
    
    
    //
    /**
     Data loader
     
     - Multi-thread work
     # @escaping is for when it works in differents thread
     ---
     
    - Throws: This needs to be `tested`
     
     - Parameters:
        - recivedData: una cosa.
        - handler: Llamada Execute
           
              
    - Returns: A call with the `hymns`

     - Version
     1.0
     
     # Usage
     ```
     FetchHymnal(language: language) { (hymnal) in
         // Do something
     }
     ```
    */
    func FetchHymnal(language: HymnalLanguage, handler: @escaping ([Hymn]) -> Void) {
        
        // Check Hymnal Data
        serialQueue.sync {
            self.CheckHymnal()
        }
        
        if let hs = HymnManager.hymnal {
            handler(hs)
        }
    }
    
    
    /// Get hymn
    /// - Parameters:
    ///   - number: Number of Hymn
    ///   - language: Language of Hymn
    ///   - handler: Result
    func FetchHymn(number: Int, language: HymnalLanguage, handler: @escaping (Hymn) -> Void) {
        
        FetchHymnal(language: language) { (hymnal) in
            if number <= hymnal.count && number > 0 {
                
                handler(hymnal[number - 1])
            }
            
        }
    }
    
    
    func CheckHymnal() {
        
        if HymnManager.hymnal != nil {
            return
        }
        
        if let path = Bundle.main.path(forResource: "Hymnal2009.es", ofType: "plist") {
            print("Data location: \(path)")
            
            let url = URL(fileURLWithPath: path)
            
            if let data = try? Data(contentsOf: url) {
                let decoder = PropertyListDecoder()
                do {
                    let data = try decoder.decode([Hymn].self, from: data)
                    HymnManager.hymnal = data
                    
                    print("Data fetched: \(HymnManager.hymnal?.count ?? 0) hymns addded")
                } catch {
                    print("Error decoding Hymn: \(error)")
                }
            }
            
        }
        
//        HymnManager.hymnal = [
//            Hymn(Number: 1, Title: "Praise to the Lord", Content: "1\n\nPraise to the Lord, the Almighty, the King of creation!\nO my soul, praise Him, for He is thy health and salvation!\nAll ye who hear, now to His temple draw near;\nJoin ye in glad adoration!\n\n2\nPraise to the Lord, Who o’er all things so wondrously reigneth,\nShieldeth thee under His wings, yea, so gently sustaineth!\nHast thou not seen how thy desires e’er have been\nGranted in what He ordaineth?\n\n3\nPraise to the Lord, who doth prosper thy work and defend thee;\nSurely His goodness and mercy here daily attend thee.\nPonder anew what the Almighty can do,\nIf with His love He befriend thee."),
//
//            Hymn(Number: 2, Title: "All Creatures of Our God and King", Content: "1\nAll creatures of our God and King\nLift up your voice and with us sing,\nAlleluia! Alleluia!\nO burning sun with golden beam\nAnd silver moon with softer gleam!\n\nRefrain\nO praise Him! O praise Him!\nAlleluia! Alleluia! Alleluia!\n\n2\nO rushing wind and breezes soft,\nO clouds that ride the winds aloft,\nO praise Him! Alleluia!\nO rising morn, in praise rejoice,\nO lights of evening, find a voice!\n\n3\nO flowing waters, pure and clear,\nMake music for your Lord to hear,\nO praise Him! Alleluia!\nO fire so masterful and bright,\nProviding us with warmth and light.\n\n4\nLet all things their Creator bless,\nAnd worship Him in humbleness,\nO praise Him! Alleluia!\n\nOh, praise the Father, praise the Son,\nAnd praise the Spirit, three in One!")
//        ]
    }
    
}

extension Array where Element == Hymn {
    
    func OrderByTitle() -> [Hymn] {
        // FIXME: situation with ´, !, ¿, etc.
        return self.sorted { $0.Title < $1.Title }
    }
    
    func OrderByNumber() -> [Hymn] {
        return self.sorted { $0.Number < $1.Number }
    }
    
}
