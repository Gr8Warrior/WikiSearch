//
//  ViewController.swift
//  MoneyTapAssignment
//
//  Created by Shailendra Suriyal on 28/07/18.
//  Copyright © 2018 Shailendra Suriyal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var emptyView: UILabel!
    
    var wikis:[WikiObjects?]?
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsTableView.rowHeight = 150
         bindUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

      var api = "http://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpslimit=10&gpssearch="
 
    func bindUI() {
        // observe text, form request, bind table view to result
        searchBar.rx.text
            .orEmpty
            .filter { query in
                return query.count > 0
            }
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map { query in
                let url = self.api.appending(query)
                let apiUrl = URLComponents(string: url)!
                return URLRequest(url: apiUrl.url!)
            }
            .flatMapLatest { request in
                return URLSession.shared.rx.json(request: request)
                    .catchErrorJustReturn([])
            }
            .map { json -> [WikiObjects] in
                guard let json = json as? [String: Any],
                    let items = json["query"] as? [String: Any], let queries = items["pages"] as? [[String: Any]]  else {
                        return []
                }
                return queries.flatMap(WikiObjects.init)
            }
            .map({ (repos) -> [WikiObjects] in
                
                DispatchQueue.main.async {
                    if(repos.count == 0) {
                        self.emptyView.isHidden = false;
                        self.resultsTableView.isHidden = true;
                    } else {
                        self.emptyView.isHidden = true;
                        self.resultsTableView.isHidden = false;
                    }
                }
                self.wikis = repos
                return repos
            })
            .bind(to: resultsTableView.rx.items) { tableView, row, repo in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ProfileTableViewCell
                cell?.profileTitle.text = repo.name
                cell?.profileImage.kf.setImage(with: URL(string: repo.thumbnailUrl))
                cell?.profileDescription?.text = repo.profildesc
                return cell!
            }
            .disposed(by: bag)
        
        resultsTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                
                let url = URL(string: (self?.wikis![indexPath.row]?.wikiUrl)!)!
                
                URLSession.shared.dataTask(with:url, completionHandler: {(data, response, error) in
                    guard let data = data, error == nil else { return }
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                        let posts = json["query"] as? [String: Any]
                        let pages = posts!["pages"] as? [String: Any]
                        guard let id = self?.wikis![indexPath.row]?.id else {
                            return
                        }
                        let profile = pages!["\(id)"] as? [String: Any]
                        guard let url = URL(string: profile!["fullurl"] as! String) else {
                            return 
                        }
                        DispatchQueue.main.async {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }).resume()
                
                
            }) .disposed(by: bag)
    }
    
    
}

