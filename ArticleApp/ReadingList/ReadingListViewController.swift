//
//  ReadingListViewController.swift
//  ArticleApp
//
//  Created by Raska Mohammad on 10/05/23.
//

import UIKit
import SafariServices

class ReadingListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var readingList: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "ArticleViewCell", bundle: nil), forCellReuseIdentifier: "custom_article_cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadReadingList()
    }
    

    func loadReadingList() {
        readingList = CoreDataStorage.shared.getReadingList()
    }
}

// MARK: - UITableViewDataSource
extension ReadingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom_article_cell", for: indexPath) as! ArticleViewCell
        let article = readingList[indexPath.row]
        
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
        
        cell.bookmarkButton.isHidden = true
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ReadingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = readingList[indexPath.row]
        if let url = URL(string: article.url) {
            let controller = SFSafariViewController(url:url)
            present(controller, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            let article = self.readingList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            CoreDataStorage.shared.deleteReadingList(url: article.url)
            completion(true)
        }
        if #available(iOS 13.0, *) {
            deleteAction.image = UIImage(systemName: "trash")
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
