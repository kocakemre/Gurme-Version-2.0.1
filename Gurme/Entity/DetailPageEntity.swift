//
//  DetailPageEntity.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Foundation

class DetailPageEntity {
    
    var star: String?
    var description: String?
    var prepareTime: String?
    
    init(star: String, description: String, prepareTime: String) {
        self.star = star
        self.description = description
        self.prepareTime = prepareTime
    }
}
