//
//  ArticleEndPoint.swift
//  NYTimesMVVM
//
//  Created by Narendra on 15/11/18.
//  Copyright © 2018 Cognizant. All rights reserved.
//

import Foundation

protocol Endpoint {
    
    var base: String { get }
    var path: String { get }
}

extension Endpoint {
    
    var apiKey: String {
        return ".json?api-key=\(APIKey)"
    }
    
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.query = apiKey
        return components
    }
    
    var request: URLRequest {
        let url = URL(string: NEWS_API_URL)  //urlComponents.url!
        return URLRequest(url: url!)
    }
}

enum NewsFeed {
    case mostPopular
}

extension NewsFeed: Endpoint {
    
    var base: String {
        return API_BASE_URL
    }
    
    var path: String {
        switch self {
        case .mostPopular: return ""
        }
    }
}

