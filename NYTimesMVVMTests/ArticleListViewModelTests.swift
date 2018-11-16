//
//  ArticleListViewModelTests.swift
//  NYTimesMVVMTests
//
//  Created by Narendra on 16/11/18.
//  Copyright © 2018 Cognizant. All rights reserved.
//

import XCTest
@testable import NYTimesMVVM

class ArticleListViewModelTests: XCTestCase {

    var sut: ArticleListViewModel!
    var mockAPIService: MockApiService!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        mockAPIService = MockApiService()
        sut = ArticleListViewModel(apiService: mockAPIService)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func test_fetch_photo() {
        // Given
        mockAPIService.completeArticles = [Article]()
        
        // When
        sut.initFetch()
        
        // Assert
        XCTAssert(mockAPIService!.isFetchPopularPhotoCalled)
    }

    func test_fetch_photo_fail() {
        
        // Given a failed fetch with a certain failure
        let error = APIError.requestFailed
        
        // When
        sut.initFetch()
        
        mockAPIService.fetchFail(error: error )
        
        // Sut should display predefined error message
        XCTAssertEqual( sut.alertMessage, error.localizedDescription )
        
    }
    
    func test_create_cell_view_model() {
        // Given
        let articles = StubGenerator().stubArticles()
        mockAPIService.completeArticles = articles
        let expect = XCTestExpectation(description: "reload closure triggered")
        sut.reloadTableViewClosure = { () in
            expect.fulfill()
        }
        
        // When
        sut.initFetch()
        mockAPIService.fetchSuccess()
        
        // Number of cell view model is equal to the number of photos
        XCTAssertEqual( sut.numberOfCells, articles.count )
        
        // XCTAssert reload closure triggered
        wait(for: [expect], timeout: 1.0)
        
    }
    
    func test_loading_when_fetching() {
        
        //Given
        var loadingStatus = false
        let expect = XCTestExpectation(description: "Loading status updated")
        sut.updateLoadingStatus = { [weak sut] in
            loadingStatus = sut!.isLoading
            expect.fulfill()
        }
        
        //when fetching
        sut.initFetch()
        
        // Assert
        XCTAssertTrue( loadingStatus )
        
        // When finished fetching
        mockAPIService!.fetchSuccess()
        XCTAssertFalse( loadingStatus )
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func test_user_press_for_article_item() {
        
        //Given a sut with fetched photos
        let indexPath = IndexPath(row: 0, section: 0)
        goToFetchPhotoFinished()
        
        //When
        sut.userPressed( at: indexPath )
        
        //Assert
        XCTAssertTrue( sut.isAllowSegue )
        XCTAssertNotNil( sut.selectedArticle )
        
    }
    
    func test_get_cell_view_model() {
        
        //Given a sut with fetched photos
        goToFetchPhotoFinished()
        
        let indexPath = IndexPath(row: 1, section: 0)
        let testPhoto = mockAPIService.completeArticles[indexPath.row]
        
        // When
        let vm = sut.getCellViewModel(at: indexPath)
        
        //Assert
        XCTAssertEqual( vm.titleText, testPhoto.title)
        
    }
    
//    func test_cell_view_model() {
//        //Given photos
//        let today = Date()
//
//        
//        let artcile = Article(url: "url", title: "Title", published_date: "2018-11-06", byline: "desc")
//        
//        
//        let artcileWithOutTitle = Article(url: "url", title: nil, published_date: "2018-12-30", byline: "desc", media: [media])
//        let artcileWithOutDate = Article(url: "url", title: "Title", published_date: nil, byline: "desc", media: [media])
//        let artcileWithOutDesc = Article(url: "url", title: "Title", published_date: "2018-12-30", byline: nil, media: [media] )
//
//
//        // When creat cell view model
//        let cellViewModel = sut!.createCellViewModel( article:artcile )
//        let cellViewModelWithOutTitle = sut!.createCellViewModel( article:artcileWithOutTitle)
//        let cellViewModelWithoutDate = sut!.createCellViewModel( article: artcileWithOutDate )
//        let cellViewModelWithoutDesc = sut!.createCellViewModel( article: artcileWithOutDesc )
//
//        // Assert the correctness of display information
//        XCTAssertEqual( artcile.title, cellViewModel.titleText )
//        XCTAssertEqual( photo.image_url, cellViewModel.imageUrl )
//
//        XCTAssertEqual(cellViewModel.descText, "\(photo.camera!) - \(photo.description!)" )
//        XCTAssertEqual(cellViewModelWithoutDesc.descText, photoWithoutDesc.camera! )
//        XCTAssertEqual(cellViewModelWithoutCamera.descText, photoWithoutCarmera.description! )
//        XCTAssertEqual(cellViewModelWithoutCameraAndDesc.descText, "" )
//
//        let year = Calendar.current.component(.year, from: today)
//        let month = Calendar.current.component(.month, from: today)
//        let day = Calendar.current.component(.day, from: today)
//
//        XCTAssertEqual( cellViewModel.dateText, String(format: "%d-%02d-%02d", year, month, day) )
//
//    }
    
    
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}


class MockApiService: ArticleManagerProtocol {
    
    
    var isFetchPopularPhotoCalled = false
    
    var completeArticles: [Article] = [Article]()

    var completeClosure: ((Result<ArticleData?, APIError>)  -> ())!
    
    
    func fetchArticles(from newsFeed: NewsFeed, completion: @escaping (Result<ArticleData?, APIError>) -> ()) {
        isFetchPopularPhotoCalled = true
        completeClosure = completion
    }
    
    
    func fetchSuccess() {
//        completion(genericModel, nil)
//        completeClosure(nil, nil)
    }

    func fetchFail(error: APIError?) {
//        completeClosure( nil, nil )
    }
    
}

extension ArticleListViewModelTests {
    private func goToFetchPhotoFinished() {
        mockAPIService.completeArticles = StubGenerator().stubArticles()
        sut.initFetch()
        mockAPIService.fetchSuccess()
    }
}


class StubGenerator {
    func stubArticles() -> [Article] {
        let path = Bundle.main.path(forResource: "content", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let articleData = try! decoder.decode(ArticleData.self, from: data)
        return articleData.results
    }
}
