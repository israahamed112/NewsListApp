//
//  NewsHeadlineTableViewCell.swift
//  NewsApp
//
//  Created by Esraa Hamed on 22/04/2022.
//

import UIKit
import SDWebImage

class NewsHeadlineTableViewCell: UITableViewCell {

    @IBOutlet weak var headlineImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    
    @IBOutlet weak var headlineDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(headlineTxt: String, headlineDate: String, headlineImageURL: String) {
        headlineImageView.layer.cornerRadius = 5
        
        self.headlineLabel.text = headlineTxt
        self.headlineDateLabel.text = headlineDate
        
        if let url = URL(string: headlineImageURL) {
            self.headlineImageView.sd_setImage(with: url, completed: {[weak self] (image, error, _, _) in
                guard let self = self else { return }
                if error != nil {
                    self.headlineImageView.image = UIImage(named: "newsHeadLinePlaceHolder")
                }
            })
        } else {
            self.headlineImageView.image = UIImage(named: "newsHeadLinePlaceHolder")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.headlineImageView.image = nil
        self.headlineLabel.text = ""
        self.headlineDateLabel.text = ""
    }
}
