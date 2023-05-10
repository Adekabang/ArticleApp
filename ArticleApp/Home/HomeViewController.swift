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
    
    weak var pageControl: UIPageControl?
    weak var collectionView: UICollectionView?
    
    var latestArticleList: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "ArticleViewCell", bundle: nil), forCellReuseIdentifier: "custom_article_cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.readingListDeleted(_:)), name: .deleteReadingList, object: nil)
        
        refreshControl.beginRefreshing()
        loadLatestArticle()
    }
    
    @objc func readingListDeleted(_ sender: Any){
        tableView.reloadData()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return latestArticleList.count > 0 ? 1 : 0
        } else if section == 1 {
            return latestArticleList.count > 0 ? 1 : 0
        } else {
            return latestArticleList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "announcement_cell", for: indexPath) as! AnnouncementViewCell
            let mainText = NSMutableAttributedString(
                string: "Covid-19 News: ",
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold),
                    NSAttributedString.Key.foregroundColor: UIColor.systemBlue.cgColor
            ])
            
            if #available(iOS 13.0, *) {
                mainText.append(NSAttributedString(
                    string: "See the latest coverage about Covid-19",
                    attributes: [
                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular),
                        NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel.cgColor
                    ])
                )
            } else {
                mainText.append(NSAttributedString(
                    string: "See the latest coverage about Covid-19",
                    attributes: [
                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular),
                        NSAttributedString.Key.foregroundColor: UIColor.systemGray.cgColor
                    ])
                )
            }
            cell.announcementLabel.attributedText = mainText
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "top_article_list_cell", for: indexPath) as! TopArticleListViewCell
            
            cell.titleLabel.text = "Articles for You"
            cell.subtitleLabel.text = "Top \(latestArticleList.count) Articles for You"
            cell.pageControl.numberOfPages = latestArticleList.count
            self.pageControl = cell.pageControl
            
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.reloadData()
            
            self.collectionView = cell.collectionView
            cell.delegate = self
            
            return cell
        } else {
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
            
            if CoreDataStorage.shared.isAddedToReadingList(url: article.url){
                if #available(iOS 13.0, *) {
                    cell.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                }
                cell.bookmarkButton.isEnabled = false
            } else {
                if #available(iOS 13.0, *) {
                    cell.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
                }
                cell.bookmarkButton.isEnabled = true
            }
            
            cell.delegate = self
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 2 else {
            return
        }
        
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

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return latestArticleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "top_article_cell", for: indexPath) as! TopArticleViewCell
        let article = latestArticleList[indexPath.row]
        
        let url = article.image
        if !url.isEmpty {
            cell.thumbImageView.sd_setImage(with: URL(string: url))
        } else {
            cell.thumbImageView.image = nil
        }
        
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
        cell.subtitleLabel.text = "\(articleDate) · \(article.source)"
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout { 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 256)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView != self.tableView {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
            pageControl?.currentPage = page
        }
    }
}

// MARK: - TopArticleListViewCellDelegate
extension HomeViewController: TopArticleListViewCellDelegate {
    func topArticleListViewCellPageControlValueChanged(_ cell: TopArticleListViewCell) {
        let page = cell.pageControl.currentPage
        collectionView?.scrollToItem(at: IndexPath(item: page, section: 0), at: .centeredHorizontally, animated: true)
    }
}

// MARK: - ArticleViewCellDelegate
extension HomeViewController: ArticleViewCellDelegate {
    func ArticleViewCellBookmarkButtonTapped(_ cell: ArticleViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let article = latestArticleList[indexPath.row]
            print(article.title)
            
            CoreDataStorage.shared.addReadingList(article: article)
            
            if #available(iOS 13.0, *) {
                cell.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
            cell.bookmarkButton.isEnabled = false
            
            let dataArticle = CoreDataStorage.shared.getReadingList()
            print(dataArticle.count)
        }
    }
    
}
