//
//  Repo.swift
//  MoneyTapAssignment
//
//  Created by Shailendra Suriyal on 28/07/18.
//  Copyright © 2018 Shailendra Suriyal. All rights reserved.
//

import UIKit
struct Repo {
    let id: Int
    let name: String
    let language: String
    let thumbnailUrl: String
    let wikiUrl: String
    
    init?(object: [String: Any]) {
        guard let id = object["pageid"] as? Int,
            let name = object["title"] as? String,
            let language = object["title"] as? String,
            let thumbnail = (object["thumbnail"] as? [String: Any]),
            let thumbnailUrl = thumbnail["source"] as? String else {
                return nil
        }
        self.id = id
        self.name = name
        self.language = language
        self.thumbnailUrl = thumbnailUrl
        self.wikiUrl = "https://en.wikipedia.org/w/api.php?action=query&prop=info&inprop=url&format=json&pageids=\(self.id)"
    }
    
    init(_ id: Int, _ name: String, _ language: String, _ thumbnailUrl: String, _ wikiUrl:String ) {
        self.id = id
        self.name = name
        self.language = language
        self.thumbnailUrl = thumbnailUrl
        self.wikiUrl = wikiUrl
    }
}

