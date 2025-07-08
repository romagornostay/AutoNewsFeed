//
//  NewsEndpoint.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 23.06.2025.
//

import Foundation
import Network

public enum NewsEndpoint: Endpoint {
  case getNews(page: Int, count: Int)
  
  public var host: String { "webapi.autodoc.ru" }
  
  public var path: String {
    switch self {
    case .getNews(let page, let count):
      return "/api/news/\(page)/\(count)"
    }
  }
  
  public var queryItems: [URLQueryItem] {
    return [] // пока нет query, но можно расширить
  }
}
