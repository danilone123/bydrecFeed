//
//  ViewController.swift
//  SocialFeed
//
//  Created by daniel velasco on 01/12/2019.
//  Copyright © 2019 daniel velasco. All rights reserved.
//

import UIKit

class FeedListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate var feedInformationList: [Feed]? = []
    fileprivate var activityIndicator = UIActivityIndicatorView()
    fileprivate let indicatorContainerView = UIView()
    //simulates the number of pages
    fileprivate let numberPages = 2
    fileprivate var currentPage: Int = 1
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate struct Constants {
        static let cellIdentifier = "feedCell"
        static let cellNibName = "FeedInformationCell"
        static let heightRow: CGFloat = 130.0
        static let alphaColor: CGFloat = 0.5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureIndicatorView()
        startRequest(pagenumber: currentPage)
    }
    
    fileprivate func configureIndicatorView() {
        indicatorContainerView.backgroundColor = UIColor.gray.withAlphaComponent(Constants.alphaColor)
        indicatorContainerView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style =
            UIActivityIndicatorView.Style.large
        activityIndicator.center = view.center
        activityIndicator.color = UIColor.gray
        activityIndicator.startAnimating()
        indicatorContainerView.addSubview(activityIndicator)
    }
    
    fileprivate func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = 24
        tableView.estimatedRowHeight = Constants.heightRow
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = true
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
    }
}

// Connection
extension FeedListViewController {
    fileprivate func startRequest(pagenumber: Int) {
        view.addFullSizeSubview(indicatorContainerView)
        
        SocialFeedConnection.getFeedResults(pageNumber: pagenumber) { [weak self] (feeds) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.loadTable(feeds: feeds)
        }
    }
    
    fileprivate func loadTable(feeds: [Feed]?) {
        guard let feedList = feeds else {
            print("feed information is empty")
            DispatchQueue.main.async {
                self.indicatorContainerView.removeFromSuperview()
            }
            return
        }
        
        if var feedInformation = feedInformationList {
            feedInformation += feedList
            feedInformationList = feedInformation
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.indicatorContainerView.removeFromSuperview()
        }
    }
}

// TableView delegate
extension FeedListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedInformationList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let feedCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? FeedInformationCell, let feedInformation = feedInformationList?[indexPath.row] else {
            let emptyCell = UITableViewCell()
            return emptyCell
        }
        feedCell.configureWithFeed(feedInformation: feedInformation)
        feedCell.selectionStyle = .none
        return feedCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard  let feedInformation = feedInformationList?[indexPath.row], let urlFeedText = feedInformation.link, let url = URL(string: urlFeedText) else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == tableView.numberOfSections - 1 &&
            indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            if (currentPage + 1) <= numberPages {
                currentPage += 1
                startRequest(pagenumber: currentPage)
            }
        }
    }
}

