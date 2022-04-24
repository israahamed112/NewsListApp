//
//  NewsHeadlinesViewModel.swift
//  NewsApp
//
//  Created by Esraa Hamed on 23/04/2022.
//

import Foundation
import RxSwift
import RxAlamofire
import RxCocoa

class NewsHeadlinesViewModel {
    
    //this is a private publish subject because we want to put the data and can't be modified by the view
    private var articlesListSubject = PublishSubject<[Article]>()
    private var errorSubject = PublishSubject<String>()
    
    //this is public so the view can listen to it
    public var articlesListObservable : Observable<[Article]>?
    public var errorObservable: Observable<String>
    
    private var networkManager = NetworkManagerClass()
    
    let disposeBag = DisposeBag()
    
    init() {
        //they are equal so the data obseravable will have the same data that putted in dataSubject
        
        articlesListObservable = articlesListSubject.asObserver()
        errorObservable = errorSubject.asObserver()
    }
    
    //this method is to put the response which is the all articles of a choosing country and category  to the datasubject so the dataObseravable will have the same data because they  are equal
    //and then in view will listen to the dataObseravable
    func getTopHeadlinedByCountry() {
        let countryName = UserDefaults.standard.string(forKey: "countryCode") ?? ""
        let category = UserDefaults.standard.string(forKey: "category") ?? ""
        
        self.rx_getTopHeadlinesByCountryAndCategory(countryName: countryName, categoryName: category).subscribe(onNext: {[weak self] (response) in
            
            self?.articlesListSubject.onNext(response.articles ?? [])
            
        }, onError: {[weak self] (error) in
            self?.errorSubject.onNext(error.localizedDescription)
        }, onCompleted: {
        }).disposed(by: disposeBag)
    }
    
    func rx_getTopHeadlinesByCountryAndCategory(countryName: String, categoryName: String) -> Observable <NewsClass> {
        var url = URLComponents(string: Apis_Urls.topHeadLines.getURLfor().absoluteString) ?? URLComponents()
        
        url.queryItems = [
            URLQueryItem(name: "country", value: "\(countryName)"),
            URLQueryItem(name: "category", value: "\(categoryName)"),
            URLQueryItem(name: "apiKey", value: "\(URLConstants.apiKey)")
        ]
                
        return networkManager.getResponseObseravable(requestURL: url, method: .get, parameters: nil)
    }
}
