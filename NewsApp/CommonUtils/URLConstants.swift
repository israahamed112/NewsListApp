//
//  URLConstants.swift
//  NewsApp
//
//  Created by Esraa Hamed on 23/04/2022.
//

import Foundation
struct URLConstants {
    static let baseUrl = "https://newsapi.org/v2"
    static let apiKey = "8f3692bea4ac47bca13ba490e30322bf"
}
enum Apis_Urls: String {
    case topHeadLines = "/top-headlines?"
    
    func getURLfor() -> URL {
        return URL(string: "\(URLConstants.baseUrl)\(self.rawValue)")!
    }
}
