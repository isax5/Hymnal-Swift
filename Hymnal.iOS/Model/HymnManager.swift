//
//  HymnalManager.swift
//  Hymnal.iOS
//
//  Created by Isaac Rebolledo Leal on 04-04-20.
//

import UIKit
import Foundation

protocol HymnManagerDelegate {
    func hymnLoaded(_ hymn: [Hymn])
}

class HymnManager {
    
    let serialQueue = DispatchQueue(label: "Serial Queue") // custom dispatch queues are serial by default
    static var hymns: [Hymn]?
    
    var delegate: HymnManagerDelegate?
    
    
    static let sharedInstance: HymnManager = {
        return HymnManager()
    }()
    
    private init() {
        
    }
    
    //
    /**
     Data loader
     
     - Multi-thread work
     # @escaping is for when it works in differents thread
     * Probar que eso esa así
     
    - Throws: This needs to be `tested`
     
     - parameters:
     - recivedData: una cosa.
     - handler: llamada de execute
           
              
    - Returns: A call with the `hymns`

     - Version
     1.0
    */
    func LoadData(recivedData: Int, handler: @escaping (String) -> Void) {
        
        serialQueue.async {
            // Critical secction
            
            
        }

        // Call delegate or handler
        DispatchQueue.main.async {
            if let hs = HymnManager.hymns, let delegate = self.delegate {
                delegate.hymnLoaded(hs)
            }
            handler("")
        }
    }
    
    ///
    /// asdfads
    func testingFunction() {
        LoadData(recivedData: 3) { (recivedData) in
            if recivedData == "" {
                
            }
        }
    }
    
}
