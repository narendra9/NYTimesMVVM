//
//  ArticleResponseModel.swift
//  NYTimesMVVM
//
//  Created by Narendra on 15/11/18.
//  Copyright © 2018 Cognizant. All rights reserved.
//

import Foundation


struct Articles : Decodable {
    var url: String?
    var title : String?
    var published_date : String?
    var byline : String?
    var media : [Media]
    enum CodingKeys : String, CodingKey {
        case media = "media"
        case url = "url"
        case published_date = "published_date"
        case byline = "byline"
        case title = "title"
    }
}

struct ArticleData: Decodable {
    let results: [Article]
    enum CodingKeys : String, CodingKey {
        case results = "results"
    }
    
    
}
struct Media : Decodable {
    var mediaMetaData : [MediaMetaData]
    enum CodingKeys : String, CodingKey {
        case mediaMetaData = "media-metadata"
    }
}


struct MediaMetaData : Decodable {
    var url :String?
    var format:String?
}

class Article:Codable {
    var title : String?
    var published_date : String?
    var byline : String?
    var imageUrl :String?
    var format:String?

    required init(from decoder: Decoder) throws {
        let rawResponse = try Articles(from: decoder)

        title          = rawResponse.title
        published_date = rawResponse.published_date
        byline    = rawResponse.byline
        for media in rawResponse.media
        {
            for metaData in media.mediaMetaData
            {
                imageUrl = metaData.url
                format   = metaData.format
            }
        }

    }
}








