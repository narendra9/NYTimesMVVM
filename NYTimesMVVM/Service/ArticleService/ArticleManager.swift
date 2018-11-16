//
//  ArticleManager.swift
//  NYTimesMVVM
//
//  Created by Narendra on 15/11/18.
//  Copyright © 2018 Cognizant. All rights reserved.
//

import Foundation
//MARK:- Service protocol
//protocol ArticleManagerProtocol {
//    func fetchArticles(_ completion: @escaping ((Result<ArticleData, APIError>) -> Void))
//}

//MARK:- Service enums

enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}

protocol ArticleManagerProtocol {
    func fetchArticles(from newsFeed: NewsFeed, completion: @escaping (Result<ArticleData?, APIError>) -> ())
    
}


class ArticleManager:APIClient,ArticleManagerProtocol {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    static let shared = ArticleManager()
    
//    let apiUrlStr = NEWS_API_URL
//    var task : URLSessionTask?
    
    
    func fetchArticles(from newsFeed: NewsFeed, completion: @escaping (Result<ArticleData?, APIError>) -> ()) {
        
        let endpoint = newsFeed
        let request = endpoint.request
        
        fetch(with: request, decode: { json -> ArticleData? in
            guard let articleData = json as? ArticleData else { return  nil }
            return articleData
        }, completion: completion)
    }
   
}
