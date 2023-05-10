//
//  CoreDataStorage.swift
//  ArticleApp
//
//  Created by Raska Mohammad on 10/05/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataStorage {
    static let shared: CoreDataStorage = CoreDataStorage()
    private init(){
        printCoreDataDBPath()
    }
    
    lazy var context: NSManagedObjectContext = {
        let appDelagate = UIApplication.shared.delegate as! AppDelegate
        return appDelagate.viewContext
    }()
    
    func printCoreDataDBPath() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
        
        print("Core Data DB Path :: \(path ?? "Not found")")
    }
    
    func addReadingList(article:Article){
        let articleData: ArticleData
        let fetchRequest = ArticleData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", article.url)
        if let data = try? context.fetch(fetchRequest).first {
            articleData = data
        } else {
            articleData = ArticleData(context: context)
        }
        
        articleData.articleDescription = article.description
        articleData.author = article.author
        articleData.date = article.date
        articleData.image = article.image
        articleData.source = article.source
        articleData.title = article.title
        articleData.url = article.url
                
        try? context.save()
    }
}
