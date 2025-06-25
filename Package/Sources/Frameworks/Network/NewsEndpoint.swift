//
//  NewsEndpoint.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 23.06.2025.
//

import Foundation

enum NewsEndpoint: Endpoint {
  case getNews(page: Int, count: Int)
  
  var path: String {
    switch self {
    case .getNews(let page, let count):
      return "/api/news/\(page)/\(count)"
    }
  }
  
  var queryItems: [URLQueryItem] {
    return [] // пока нет query, но можно расширить
  }
}
