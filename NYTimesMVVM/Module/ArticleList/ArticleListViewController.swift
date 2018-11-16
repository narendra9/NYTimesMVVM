//
//  ArticleListViewController.swift
//  NYTimesMVVM
//
//  Created by Narendra on 15/11/18.
//  Copyright © 2018 Cognizant. All rights reserved.
//

import UIKit
import SDWebImage


let kEstimatedRowHeight:CGFloat = 100.0


class ArticleListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var viewModel: ArticleListViewModel = {
        return ArticleListViewModel()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init the static view
        initView()
        
        // init view model
        initViewModel()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func initView() {
        self.navigationItem.title = "Popular Articles"
        tableView.estimatedRowHeight = kEstimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    

    func initViewModel() {
        
        // Naive binding
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 0.0
                    })
                }else {
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.initFetch()
        
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "articleCellIdentifier", for: indexPath) as? ArticleListTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }

        let cellVM = viewModel.getCellViewModel( at: indexPath )
        
        cell.nameLabel.text = cellVM.titleText
        cell.descriptionLabel.text = cellVM.byline
        cell.mainImageView?.sd_setImage(with: URL( string: cellVM.imageUrl ), completed: nil)
        cell.dateLabel.text = cellVM.dateText
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        self.viewModel.userPressed(at: indexPath)
        if viewModel.isAllowSegue {
            return indexPath
        }else {
            return nil
        }
    }
    
}

extension ArticleListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ArticleDetailViewController,
            let article = viewModel.selectedArticle {
            vc.articleImageUrl = article.imageUrl
            vc.detailNews = article.title
        }
    }
}

class ArticleListTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCellUI()
    {
//        self.mainImageView?.image = #imageLiteral(resourceName: "date_icon")
        self.nameLabel?.textColor = kPrimaryTextColor
        self.descriptionLabel?.textColor = kSecondryTextColor
        self.dateLabel?.textColor = kSecondryTextColor
    }
}

