//
//  ArticleResponse.swift
//  ArticleApp
//
//  Created by Raska Mohammad on 08/05/23.
//

import Foundation

struct ArticleResponse: Decodable {
    let articles: [Article]
    
    enum CodingKeys: String, CodingKey {
        case articles
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.articles = try container.decodeIfPresent([Article].self, forKey: .articles) ?? []
    }
}
