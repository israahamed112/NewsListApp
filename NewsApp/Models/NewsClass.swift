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
    
    func saveArticles(articles: [Article]) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(articles), forKey:"articles")
    }

    func getArticles() -> [Article] {
        if let data = UserDefaults.standard.value(forKey:"articles") as? Data {
            let savedArticles = (try? PropertyListDecoder().decode(Array<Article>.self, from: data)) ?? []
            return savedArticles
        }
        
        return []
    }
}
