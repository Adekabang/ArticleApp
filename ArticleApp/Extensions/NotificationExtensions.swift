//
//  NotificationExtensions.swift
//  ArticleApp
//
//  Created by Raska Mohammad on 11/05/23.
//

import Foundation
extension NSNotification.Name {
    static let addReadingList: NSNotification.Name = NSNotification.Name(rawValue: "kAddReadingList")
    static let deleteReadingList: NSNotification.Name = NSNotification.Name(rawValue: "kDeleteReadingList")
}
