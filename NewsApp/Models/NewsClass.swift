//
//  NewsClass.swift
//  NewsApp
//
//  Created by Esraa Hamed on 22/04/2022.
//

import Foundation
class NewsClass: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
    
    init(status: String?, totalResults: Int?, articles: [Article]?) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
    }
}
