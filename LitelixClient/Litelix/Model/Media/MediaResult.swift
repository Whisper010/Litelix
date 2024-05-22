//
//  TrendingResults.swift
//  Litelix
//
//  Created by Linar Zinatullin on 14/11/23.
//

import Foundation

struct MediaResult: Decodable {
    let page: Int
    let results: [Media]
    let total_pages: Int
    let total_results: Int
}

