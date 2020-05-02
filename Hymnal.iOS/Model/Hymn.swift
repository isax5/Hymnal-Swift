//
//  Hymn.swift
//  Hymnal.iOS
//
//  Created by Isaac Rebolledo Leal on 28-03-20.
//

import Foundation

struct Hymn: Encodable, Decodable {
    let Number: Int
    let Title: String
    let Content: String
}
