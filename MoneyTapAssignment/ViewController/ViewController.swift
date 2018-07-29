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

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var emptyView: UILabel!
    
    var wikis: [WikiObject?]?
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsTableView.rowHeight = 150
        self.searchBar.delegate = self
        bindUI()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    func bindUI() {
        searchBar.rx.text
            .orEmpty
            .filter { query in
                return query.count > 0
            }
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map { query in
                let url = Constants.baseURL.appending(query)
                let apiUrl = URLComponents(string: url)!
                return URLRequest(url: apiUrl.url!)
            }
            .flatMapLatest { request in
                return URLSession.shared.rx.json(request: request)
                    .catchErrorJustReturn([])
            }
            .map { json -> [WikiObject] in
                guard let json = json as? [String: Any],
                    let items = json["query"] as? [String: Any],
                    let queries = items["pages"] as? [[String: Any]]  else {
                        return []
                }
                return queries.flatMap(WikiObject.init)
            }
            .map({ (wikis) -> [WikiObject] in
                
                DispatchQueue.main.async {
                    if wikis.count == 0 {
                        self.emptyView.isHidden = false
                        self.resultsTableView.isHidden = true
                    } else {
                        self.emptyView.isHidden = true
                        self.resultsTableView.isHidden = false
                    }
                }
                self.wikis = wikis
                return wikis
            })
            .bind(to: resultsTableView.rx.items) { tableView, _, wiki in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ProfileTableViewCell
                cell?.profileTitle.text = wiki.name
                cell?.profileImage.kf.setImage(with: URL(string: wiki.thumbnailUrl))
                cell?.profileDescription?.text = wiki.profildesc
                return cell!
            }
            .disposed(by: bag)
        
        resultsTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                
                let url = URL(string: (self?.wikis![indexPath.row]?.wikiUrl)!)!
                
                URLSession.shared.dataTask(with: url, completionHandler: {(data, _, error) in
                    guard let data = data, error == nil else { return }
                    
                    do {
                        guard let json = try JSONSerialization
                                .jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                            return
                        }
                        let posts = json["query"] as? [String: Any]
                        let pages = posts!["pages"] as? [String: Any]
                        guard let id = self?.wikis![indexPath.row]?.pageId else {
                            return
                        }
                        let profile = pages!["\(id)"] as? [String: Any]
                        
                        guard let urlString = profile!["fullurl"] as? String, let url = URL(string: urlString) else {
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
