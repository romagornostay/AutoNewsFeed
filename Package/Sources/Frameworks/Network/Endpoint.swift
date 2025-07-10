//
//  Endpoint.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 23.06.2025.
//

import Foundation

public protocol Endpoint {
  var host: String { get }
  var path: String { get }
  var queryItems: [URLQueryItem] { get }
  var url: URL? { get }
}

extension Endpoint {
  var scheme: String { "https" }
  
  public var url: URL? {
    var components = URLComponents()
    components.scheme = scheme
    components.host = host
    components.path = path
    components.queryItems = queryItems
    return components.url
  }
}
