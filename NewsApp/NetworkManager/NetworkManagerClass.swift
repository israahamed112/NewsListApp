//
//  NetworkManagerClass.swift
//  NewsApp
//
//  Created by Esraa Hamed on 23/04/2022.
//

import Foundation
import RxSwift
import RxAlamofire
import RxCocoa
import Alamofire
import UIKit

class NetworkManagerClass {
    
    func getResponseObseravable<T: Codable>(requestURL: URLConvertible, method: Alamofire.HTTPMethod,  parameters: [String: Any]? = nil) -> Observable<T>
    {
        return Observable.create { observer in
            _ = AF.request(requestURL, method: method, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    do
                    {
                        if response.response?.statusCode == 200 {
                            let dataObject = try JSONDecoder().decode(T.self, from: response.data!)
                            
                            observer.onNext(dataObject)
                            observer.onCompleted()
                        } else {
                            let error = NSError(domain: "Unable to fetch valid data from server. Please try again later.", code: response.response?.statusCode ?? 400)
                            observer.onError(error)
                        }
                    } catch let JSONError {
                        let error = NSError(domain: "Unable to fetch valid data from server. Please try again later.", code: response.response?.statusCode ?? 400)
                        observer.onError(error)
                        print(JSONError)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
