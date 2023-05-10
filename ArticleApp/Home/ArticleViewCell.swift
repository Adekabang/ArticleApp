//
//  ArticleViewCell.swift
//  ArticleApp
//
//  Created by Raska Mohammad on 08/05/23.
//

import UIKit

protocol ArticleViewCellDelegate: AnyObject {
    func ArticleViewCellBookmarkButtonTapped(_ cell: ArticleViewCell)
}

class ArticleViewCell: UITableViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    weak var delegate: ArticleViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup() {
        thumbImageView.layer.cornerRadius = 8
        thumbImageView.layer.masksToBounds = true
    }
    
    @IBAction func bookmarkButtonTapped(_ sender: Any) {
        delegate?.ArticleViewCellBookmarkButtonTapped(self)
    }
    
}
