//
//  NewsHeadlinesViewController.swift
//  NewsApp
//
//  Created by Esraa Hamed on 22/04/2022.
//

import UIKit
import RxSwift

class NewsHeadlinesViewController: UIViewController {

    @IBOutlet weak var newsHeadlinesTableView: UITableView!
    var newsHeadlinesViewModel = NewsHeadlinesViewModel()
    let disposeBag = DisposeBag()
    var headlines: [Article] = []
    
    let searchController = UISearchController()
    var isSearchActive = false
    var headLinesForSearching: [Article] = []
    var spinner = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        initialSetup()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Headlines"
    }
    
    func initialSetup() {
        setTableViewDelegates()
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func setTableViewDelegates() {
        self.newsHeadlinesTableView.delegate = self
        self.newsHeadlinesTableView.dataSource = self
        
        newsHeadlinesTableView.estimatedRowHeight = 150
        newsHeadlinesTableView.rowHeight = newsHeadlinesTableView.rowHeight
    }
    
    func registerCells() {
        self.newsHeadlinesTableView.register(UINib(nibName: "NewsHeadlineTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsHeadlineTableViewCell")
        
    }
    
    func bindViewModel() {
        handlingHeadlinesResponse()
        handlingErrorsResponse()
        
        getArticles()
    }
    
    func showLoader() {
        DispatchQueue.main.async {
            self.spinner.center = self.view.center
            self.spinner.hidesWhenStopped = true
            self.spinner.startAnimating()
            self.view.addSubview(self.spinner)
        }
    }
    
    func handlingHeadlinesResponse() {
        self.newsHeadlinesViewModel.articlesListObservable?.subscribe(onNext: {[weak self] (response) in

            self?.headlines = response.sorted{$0.getDateFromPublishedAt() < $1.getDateFromPublishedAt()}
            self?.saveArticles(articles: response)
            print("Response", response)
            self?.newsHeadlinesTableView.reloadData()
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
            }

        }, onError: { (_) in

        }, onCompleted: {

        }).disposed(by: disposeBag)
    }
    
    func saveArticles(articles: [Article]) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(articles), forKey:"articles")
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "currentDate")

    }
    
    func getArticles() {
        
        let date = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "currentDate"))
        let timeInterval = Date() - date
        let numOfMinutes = timeInterval.minutes

        if numOfMinutes > 30 {
            showLoader()
            newsHeadlinesViewModel.getTopHeadlinedByCountry()
        } else {
            spinner.stopAnimating()
            if let data = UserDefaults.standard.value(forKey:"articles") as? Data {
                let savedArticles = (try? PropertyListDecoder().decode(Array<Article>.self, from: data)) ?? []
                self.headlines = savedArticles
                self.newsHeadlinesTableView.reloadData()
            }
        }
        
    }
    
    func handlingErrorsResponse() {
        newsHeadlinesViewModel.errorObservable.subscribe(onNext: { [weak self] (data) in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: data, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }, onError: { (_) in
            
        }, onCompleted: {
            
        }).disposed(by: disposeBag)
    }
}

extension NewsHeadlinesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearchActive {
            return headLinesForSearching.count
        } else {
            return headlines.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsHeadlineTableViewCell") as! NewsHeadlineTableViewCell
        if isSearchActive {
            cell.setData(headlineTxt: (headLinesForSearching[indexPath.row].title ?? ""), headlineDate: headLinesForSearching[indexPath.row].publishedAt ?? "", headlineImageURL: headLinesForSearching[indexPath.row].urlToImage ?? "")
        } else {
            cell.setData(headlineTxt: (headlines[indexPath.row].title ?? ""), headlineDate: headlines[indexPath.row].publishedAt ?? "", headlineImageURL: headlines[indexPath.row].urlToImage ?? "")
        }
              
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let newsDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsHeadlineDetailsViewController") as? NewsHeadlineDetailsViewController {
            if isSearchActive {
                newsDetails.articleModel = self.headLinesForSearching[indexPath.row]
            } else {
                newsDetails.articleModel = self.headlines[indexPath.row]
            }
            
            self.navigationController?.pushViewController(newsDetails, animated: true)
        }
    }
    
}

extension NewsHeadlinesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            isSearchActive = false
            self.newsHeadlinesTableView.reloadData()
            return
        }
        
        if searchText.isEmpty {
            isSearchActive = false
            self.newsHeadlinesTableView.reloadData()
        } else {
            isSearchActive = true
            let headlinesTempList = headlines
            headLinesForSearching = headlinesTempList.filter({
                ($0.title ?? "").lowercased().contains(searchText.lowercased())
            }).sorted {
                $0.getDateFromPublishedAt() < $1.getDateFromPublishedAt()
            }
            self.newsHeadlinesTableView.reloadData()
        }
    }
    
    
}
