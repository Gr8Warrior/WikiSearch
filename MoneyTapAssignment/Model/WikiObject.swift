//
//  WikiObject
//  MoneyTapAssignment
//
//  Created by Shailendra Suriyal on 28/07/18.
//  Copyright © 2018 Shailendra Suriyal. All rights reserved.
//

import UIKit
struct WikiObject {
    let pageId: Int
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
        let thumbnailUrl = thumbnail["source"] as? String ?? Constants.placeholderImageURL
        let terms = (object["terms"] as? [String: Any]) ?? [" ": " "]
        let desc = terms["description"] as? [String] ?? [" "]
        let profileDesc = desc[0]
        
        self.pageId = id!
        self.name = name!
        self.language = language!
        self.thumbnailUrl = thumbnailUrl
        self.wikiUrl = Constants.profileURL+"\(self.pageId)"
        self.profildesc = profileDesc
    }
    
    init(_ pageId: Int, _ name: String,
         _ language: String,
         _ thumbnailUrl: String,
         _ wikiUrl: String,
         _ profildesc: String) {
        self.pageId = pageId
        self.name = name
        self.language = language
        self.thumbnailUrl = thumbnailUrl
        self.wikiUrl = wikiUrl
        self.profildesc = profildesc
    }
}
