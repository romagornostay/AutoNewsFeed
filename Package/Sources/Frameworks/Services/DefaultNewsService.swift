//
//  DefaultNewsService.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 23.06.2025.
//

import API
import Foundation
import Network
import Models

public final class DefaultNewsService: NewsService {
  private let client: APIClient
  
  public init(client: APIClient = DefaultAPIClient()) {
    self.client = client
  }
  
  public func fetch(page: Int, count: Int) async throws -> [NewsItem] {
    let response: NewsResponse = try await client.request(NewsEndpoint.getNews(page: page, count: count))
    return response.news
  }
}
