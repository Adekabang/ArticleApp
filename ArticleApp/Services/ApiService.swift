//
//  ApiService.swift
//  ArticleApp
//
//  Created by Raska Mohammad on 08/05/23.
//

import Foundation
import Alamofire

class ApiService {
    static let shared: ApiService = ApiService()
    private init() { }
    
    private let BASE_URL = "https://api.lil.software"
    
    func loadLatestArticle(completion: @escaping (Result<[Article], Error>) -> Void) {
        let urlString = "\(BASE_URL)/news"
        AF.request(urlString, method: HTTPMethod.get).validate()
            .responseDecodable(of: ArticleResponse.self) { response in
                switch response.result {
                case .success(let articleResponse):
                    completion(.success(articleResponse.articles))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
