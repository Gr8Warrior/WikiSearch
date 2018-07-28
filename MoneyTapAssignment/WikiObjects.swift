//
//  Repo.swift
//  MoneyTapAssignment
//
//  Created by Shailendra Suriyal on 28/07/18.
//  Copyright © 2018 Shailendra Suriyal. All rights reserved.
//

import UIKit
struct WikiObjects {
    let id: Int
    let name: String
    let language: String
    let thumbnailUrl: String
    let wikiUrl: String
    let profildesc: String
    
    init?(object: [String: Any]) {
        
        let id = object["pageid"] as? Int
        let name = object["title"] as? String
        let language = object["title"] as? String
        let thumbnail = (object["thumbnail"] as? [String: Any]) ?? [" ": ""]
        let thumbnailUrl = thumbnail["source"] as? String ?? "https://style.anu.edu.au/_anu/4/images/placeholders/person.png"
        let terms = (object["terms"] as? [String: Any]) ?? [" ":" "]
        let desc = terms["description"] as? [String] ?? [" "]
        let profileDesc = desc[0]
        
        self.id = id!
        self.name = name!
        self.language = language!
        self.thumbnailUrl = thumbnailUrl
        self.wikiUrl = "https://en.wikipedia.org/w/api.php?action=query&prop=info&inprop=url&format=json&pageids=\(self.id)"
        self.profildesc = profileDesc
    }
    
    init(_ id: Int, _ name: String,
         _ language: String,
         _ thumbnailUrl: String,
         _ wikiUrl: String,
         _ profildesc: String) {
        self.id = id
        self.name = name
        self.language = language
        self.thumbnailUrl = thumbnailUrl
        self.wikiUrl = wikiUrl
        self.profildesc = profildesc
    }
}

