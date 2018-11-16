//
//  ArticalListViewController.swift
//  NYTimesMVVM
//
//  Created by Narendra on 15/11/18.
//  Copyright © 2018 Cognizant. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleDetailViewController: UIViewController {

    @IBOutlet weak var detailLabel:UILabel!
    @IBOutlet weak var articleImage:UIImageView!
    
    var detailNews:String?
    var articleImageUrl:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailLabel.text = detailNews

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadArticleImage()
    }
    
    
    deinit {
        articleImage.image = nil
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadArticleImage() {
        if let urlStr = articleImageUrl {
            let url = URL(string: urlStr)
            //Image Cache using SDWebImage
            articleImage.sd_setShowActivityIndicatorView(true)
            articleImage.sd_setIndicatorStyle(.gray)
            articleImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeHolder.png"), options: SDWebImageOptions.delayPlaceholder, completed: nil)
        }
    }
    
}
