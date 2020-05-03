//
//  Constants.swift
//  Hymnal.iOS
//
//  Created by Isaac Rebolledo Leal on 04-04-20.
//

import UIKit

struct K {
    
    // Segues
    struct Segue {
        static let ShowHymn = "ShowHymn"
        static let ShowMusicSheet = "ShowMusicSheet"
    }
    
    // Cells
    struct Cell {
        static let HymnTextCellNibName = "HymnTextTableViewCell"
        static let HymnTextIdentifier = "HymnTextCellIdentifier"
        static let HymnTextHeight: CGFloat = 120
        
        static let HymnNumberCellNibName = "HymnNumberTableViewCell"
        static let HymnNumberIdentifier = "HymnNumberCellIdentifier"
    }
    
}
