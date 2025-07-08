//
//  NewsFeedViewModel.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 20.06.2025.
//

import Foundation
import Models
import Services

@MainActor
final class NewsFeedViewModel {
  private(set) var items: [NewsItem] = []
  private var currentPage = 1
  private let pageSize = 14
  private(set) var isLoading = false {
    didSet { onUpdate?() } // 🚀 Notify on state change
  }
  private var hasMorePages = true
  
  private let service: NewsService
  var onUpdate: (() -> Void)?
  
  init(service: NewsService = DefaultNewsService()) {
    self.service = service
  }

  func loadInitial() async {
    guard !isLoading else { return }
    self.isLoading = true
    
    do {
      let news = try await service.fetch(page: currentPage, count: pageSize)
      items = news
      hasMorePages = news.count == pageSize
    } catch {
      print("❌ Error loading news:", error)
    }
    self.isLoading = false
  }
  
  func fetchNextPage() async {
    guard !isLoading, hasMorePages else { return }
    isLoading = true
    currentPage += 1

    do {
      let news = try await service.fetch(page: currentPage, count: pageSize)
      items += news
      hasMorePages = news.count == pageSize
    } catch {
      print("❌ Error fetching next page:", error)
      currentPage -= 1
    }

    isLoading = false
  }

  func item(at index: Int) -> NewsItem? {
    guard index < items.count else { return nil }
    return items[index]
  }

  var count: Int { items.count }
}
