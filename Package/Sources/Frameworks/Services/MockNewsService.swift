//
//  MockNewsService.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 25.06.2025.
//

import Foundation
import Models

public final class MockNewsService: NewsService {
  private let totalPages: Int
  private let pageSize: Int

  public init(totalPages: Int = 10, pageSize: Int = 15) {
    self.totalPages = totalPages
    self.pageSize = pageSize
  }

  public func fetch(page: Int, count: Int) async throws -> [NewsItem] {
    guard page <= totalPages else { return [] }
    try await Task.sleep(nanoseconds: 2_000_000_000)
    return (1...count).map {
      NewsItem(
        id: UUID().hashValue,
        title: "Новость #\((page - 1) * count + $0)",
        description: "воу новость 😃\((page + 10) * count + $0)🚀",
        publishedDate: Date().description,
        fullUrl: "",
        titleImageUrl: "",
        categoryType: ""
      )
    }
  }
}
