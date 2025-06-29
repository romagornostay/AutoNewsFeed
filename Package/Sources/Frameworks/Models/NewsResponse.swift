//
//  NewsResponse.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 23.06.2025.
//

import Foundation

public struct NewsResponse: Decodable {
  public init(news: [NewsItem]) {
    self.news = news
  }
  
  public let news: [NewsItem]
}
