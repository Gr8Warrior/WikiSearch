//
//  Constants.swift
//  MoneyTapAssignment
//
//  Created by Shailendra Suriyal on 28/07/18.
//  Copyright © 2018 Shailendra Suriyal. All rights reserved.
//

import UIKit

struct Constants {
    static var baseURL = "http://en.wikipedia.org//w/api.php?"
                        + "action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch"
                        + "&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=150&pilim"
                        + "it=10&wbptterms=description&gpslimit=10&gpssearch="

    static var placeholderImageURL = "https://educationaltechnology.net/wp-content/uploads/2017/09/wiki.gif"
    static var profileURL = "https://en.wikipedia.org/w/api.php?action=query&prop=info&inprop=url&format=json&pageids="
    
}
