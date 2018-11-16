//
//  ArticleManageTests.swift
//  NYTimesMVVMTests
//
//  Created by Narendra on 16/11/18.
//  Copyright © 2018 Cognizant. All rights reserved.
//

import XCTest
@testable import NYTimesMVVM

class ArticleManageTests: XCTestCase {

    var apiService: ArticleManager?

    
    override func setUp() {
        super.setUp()
        apiService = ArticleManager()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        apiService = nil
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func test_fetch_popular_news() {
        
        // Given A apiservice
        let service = self.apiService!
        
        // When fetch popular news
        let expect = XCTestExpectation(description: "callback")
        
        service.fetchArticles(from: .mostPopular) {  result in
            expect.fulfill()
            
           
        }
       
        wait(for: [expect], timeout: 3.1)
    }
    
}
