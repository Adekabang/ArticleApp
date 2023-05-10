//
//  AnnouncementViewCell.swift
//  ArticleApp
//
//  Created by Raska Mohammad on 11/05/23.
//

import UIKit

class AnnouncementViewCell: UITableViewCell {

    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var announcementLabel: UILabel!
    @IBOutlet weak var callToActionButton: UIButton!
    
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
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
//        containerView.frame.height = 100
        announcementLabel.text = "Covid-19 News: See the latest coverage about Covid-19"
    }

}
