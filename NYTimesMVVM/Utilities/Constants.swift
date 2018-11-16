//
//  Constants.swift
//  NYTimesMVVM
//
//  Created by Narendra on 15/11/18.
//  Copyright © 2018 Cognizant. All rights reserved.
//

import Foundation
import UIKit




// API URLS
let APIKey = "328c8770deff4e44b77b935618667461"
let kAPIPeriods:Int = 7
let kAPISections = "all-sections"
let API_BASE_URL: String = "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/"

let NEWS_API_URL = API_BASE_URL + "/\(kAPISections)" + "/\(kAPIPeriods)" + ".json?api-key=\(APIKey)"

// Color constants
let kPrimaryTextColor = UIColor.black
let kSecondryTextColor = UIColor.darkGray
let kPrimaryBackGroundColor = UIColor.lightGray



