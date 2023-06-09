//
//  TopArticleListViewCell.swift
//  ArticleApp
//
//  Created by Raska Mohammad on 10/05/23.
//

import UIKit

protocol TopArticleListViewCellDelegate : AnyObject{
    func topArticleListViewCellPageControlValueChanged(_ cell: TopArticleListViewCell)
}

class TopArticleListViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    weak var delegate: TopArticleListViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func pageControlValueChanged(_ sender: Any) {
        delegate?.topArticleListViewCellPageControlValueChanged(self)
    }
}
