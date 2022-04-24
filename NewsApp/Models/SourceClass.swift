//
//  SourceClass.swift
//  NewsApp
//
//  Created by Esraa Hamed on 22/04/2022.
//

import Foundation
class Source: Codable {
    let id: String?
    let name: String
    
    init(id: String?, name: String) {
        self.id = id
        self.name = name
    }
}
