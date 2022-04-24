//
//  NewsHeadlineDetailsViewController.swift
//  NewsApp
//
//  Created by Esraa Hamed on 22/04/2022.
//

import UIKit
import SDWebImage

class NewsHeadlineDetailsViewController: UIViewController {

    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    var articleModel: Article?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetup()
        initialSetup()
    }

    func initialSetup() {
        self.articleTitleLabel.text = articleModel?.title ?? ""
        self.descriptionLabel.text = articleModel?.articleDescription ?? ""
        
        if let authorName = articleModel?.author {
            self.authorLabel.text = "By: " + authorName
        } else {
            self.authorLabel.text = ""
        }
        
        if let sourceName = articleModel?.source?.name {
            self.sourceLabel.text = "Source: " + sourceName
        } else {
            self.sourceLabel.text = ""
        }
        
        articleImageView.layer.cornerRadius = 5
        if let url = URL(string: articleModel?.urlToImage ?? "") {
            self.articleImageView.sd_setImage(with: url, completed: {[weak self] (image, error, _, _) in
                guard let self = self else { return }
                if error != nil {
                    self.articleImageView.image = UIImage(named: "newsHeadLinePlaceHolder")
                }
            })
        } else {
            self.articleImageView.image = UIImage(named: "newsHeadLinePlaceHolder")
        }
    }
    
    func navigationBarSetup() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                
        self.navigationItem.setRightBarButton(addOpenArticleButton(), animated: true)
        
        self.title = "Headline Details"
    }
    
    func addOpenArticleButton() -> UIBarButtonItem {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "safari"), for: UIControl.State.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 32, height: 32)
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openArticleBtnPressed)))
        return UIBarButtonItem.init(customView: button)
    }
    
    @objc func openArticleBtnPressed() {
        if let url = URL(string: self.articleModel?.url ?? "") {
            UIApplication.shared.open(url)
        }
    }
}
