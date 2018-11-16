//
//  ArticleListViewModel.swift
//  NYTimesMVVM
//
//  Created by Narendra on 15/11/18.
//  Copyright © 2018 Cognizant. All rights reserved.
//

import Foundation

class ArticleListViewModel {
    
    let apiService: ArticleManagerProtocol
    
    private var articles: [Article] = [Article]()
    
    private var cellViewModels: [ArticleListCellViewModel] = [ArticleListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var isAllowSegue: Bool = false
    
    var selectedArticle: Article?
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init( apiService: ArticleManagerProtocol = ArticleManager()) {
        self.apiService = apiService
    }
    
    func initFetch() {
        
        self.isLoading = true

        apiService.fetchArticles(from: .mostPopular) { [weak self] result in
            self?.isLoading = false
            switch result {
            case let .success(response) :
                DispatchQueue.main.async {
                    guard let items = response?.results else {
                        return
                    }
                    self?.processFetchedPhoto(articles: items)
                }
                
            case let .failure(error) :
                self?.alertMessage = error.localizedDescription
            }
        }
    }
        
 
    
    func getCellViewModel( at indexPath: IndexPath ) -> ArticleListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( article: Article ) -> ArticleListCellViewModel {
      
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return ArticleListCellViewModel( titleText: article.title!,
                                       byline: article.byline!,
                                       imageUrl: article.imageUrl!,
                                       dateText: article.published_date!)
    }
    
    private func processFetchedPhoto( articles: [Article] ) {
        self.articles = articles // Cache
        var vms = [ArticleListCellViewModel]()
        for article in articles {
            vms.append( createCellViewModel(article: article) )
        }
        self.cellViewModels = vms
    }
    
}

extension ArticleListViewModel {
    func userPressed( at indexPath: IndexPath ){
        let article = self.articles[indexPath.row]
        self.isAllowSegue = true
        self.selectedArticle = article
    }
}

struct ArticleListCellViewModel {
    let titleText: String
    let byline: String
    let imageUrl: String
    let dateText: String

}
