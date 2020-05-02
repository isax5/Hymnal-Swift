//
//  HymnalLanguage.swift
//  Hymnal.iOS
//
//  Created by Isaac Rebolledo Leal on 04-04-20.
//

import Foundation

//
/**
 Hymnal Language
 
 - Version
 1.0
*/
struct HymnalLanguage: Encodable, Decodable {
    var Id: String
    var TwoLetterISOLanguageName: String
    var Name: String
    var Detail: String
    var HymnsFileName: String

    var ThematicHymnsFileName: String

    var SungMusic: String
    var InstrumentalMusic: String
    var HymnsSheetsFileName: String
}

