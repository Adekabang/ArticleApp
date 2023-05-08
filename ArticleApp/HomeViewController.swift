//
//  HomeViewController.swift
//  ArticleApp
//
//  Created by Raska Mohammad on 08/05/23.
//

import UIKit
import SDWebImage
import SafariServices

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    weak var refreshControl: UIRefreshControl!
    
    var latestArticleList: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        refreshControl.beginRefreshing()
        loadLatestArticle()
    }
    
    @objc func refresh(_ sender: Any) {
        loadLatestArticle()
    }
    
    func loadLatestArticle() {
        ApiService.shared.loadLatestArticle { result in
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let articleList):
                self.latestArticleList = articleList
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return latestArticleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom_article_cell", for: indexPath) as! ArticleViewCell
        
        let article = latestArticleList[indexPath.row]
//        cell.textLabel?.text = "\(indexPath.row + 1). \(article.title)"
        cell.titleLabel.text = article.title
        
        let dateString = article.date
        let dateFormatter = DateFormatter()
    
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" //2023-05-06T18:25:28Z
        var articleDate = ""
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM dd, yyyy" //May 06, 2023
            let readableDateString = dateFormatter.string(from: date)
            articleDate = readableDateString
        }

        cell.dateLabel.text = "\(articleDate) · \(article.source)"
        
        let url = article.image
        if !url.isEmpty {
            cell.thumbImageView.sd_setImage(with: URL(string: url))
        } else {
            cell.thumbImageView.image = nil
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article =  latestArticleList[indexPath.row]
        
//        let alert = UIAlertController(title: article.title, message: article.description, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Okay", style: .default))
//        present(alert, animated: true)
        
        if let url = URL(string: article.url) {
            let controller = SFSafariViewController(url:url)
            present(controller, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
