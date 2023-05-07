//
//  HomeViewController.swift
//  ArticleApp
//
//  Created by Raska Mohammad on 08/05/23.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var latestArticleList: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        loadLatestArticle()
    }
    
    func loadLatestArticle() {
        ApiService.shared.loadLatestArticle { result in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "article_cell", for: indexPath)
        
        let article = latestArticleList[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1). \(article.title)"
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article =  latestArticleList[indexPath.row]
        
        let alert = UIAlertController(title: article.title, message: article.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alert, animated: true)
    }
}
