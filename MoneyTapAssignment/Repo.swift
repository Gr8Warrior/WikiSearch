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
        self.thumbnailUrl = thumbnailUrl;
    }
    
    init(_ id: Int, _ name: String, _ language: String, _ thumbnailUrl: String) {
        self.id = id
        self.name = name
        self.language = language
        self.thumbnailUrl = thumbnailUrl
    }
}

