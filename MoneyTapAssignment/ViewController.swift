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

class ViewController: UIViewController {

    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var emptyView: UILabel!
    
    var wikis:[Repo?]?
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         bindUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

      var api = "http://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=SachinT&gpslimit=10"
    
    var apiMapToURL = "https://en.wikipedia.org/w/api.php?action=query&prop=info&pageids=35319387&inprop=url"
    
    func bindUI() {
        // observe text, form request, bind table view to result
        searchBar.rx.text
            .orEmpty
            .filter { query in
                return query.count > 2
            }
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map { query in
                //var apiUrl = URLComponents(string: "https://api.github.com/search/repositories")!
                let apiUrl = URLComponents(string: self.api)!
                //apiUrl.queryItems = [URLQueryItem(name: "gpssearch=", value: query)]
                return URLRequest(url: apiUrl.url!)
            }
            .flatMapLatest { request in
                return URLSession.shared.rx.json(request: request)
                    .catchErrorJustReturn([])
            }
            .map { json -> [Repo] in
                guard let json = json as? [String: Any],
                    let items = json["query"] as? [String: Any], let queries = items["pages"] as? [[String: Any]]  else {
                        return []
                }
                return queries.flatMap(Repo.init)
            }
            .map({ (repos) -> [Repo] in
                
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel!.text = repo.name
                cell.detailTextLabel?.text = repo.language
                return cell
            }
            .disposed(by: bag)
        
        resultsTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.resultsTableView.cellForRow(at: indexPath) as? UITableViewCell
                print("PageId \(self?.wikis![indexPath.row]?.id ) \(cell?.textLabel?.text)")
            }) .disposed(by: bag)
    }
    
    
}

