//
//  NewsFeedViewModel.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 20.06.2025.
//

import Foundation
import Models
import Services
import SupportKit

final class NewsFeedViewModel {
  
  init(service: NewsService = DefaultNewsService()) {
    self.service = service
  }
  
  private(set) var items: [NewsItem] = []
  private var currentPage = 1
  private let pageSize = 12
  
  private(set) var design: NewsCellDesign = AppSettings.newsCellDesign {
    didSet { onUpdate?() }
  }
  
  private(set) var isLoading = false {
    didSet { onUpdate?() }
  }
  private var hasMorePages = true
  
  private let service: NewsService
  var onUpdate: (() -> Void)?
  var onOpenNews: ((NewsItem) -> Void)?
  
  func setDesign(_ design: NewsCellDesign) {
    self.design = design
    AppSettings.newsCellDesign = design
  }

  @MainActor
  func loadInitial() async {
    await fetchPage(reset: true)
  }
  
  @MainActor
  func fetchNextPage() async {
    await fetchPage(reset: false)
  }
  
  @MainActor
  private func fetchPage(reset: Bool) async {
    guard !isLoading else { return }
    
    isLoading = true
    if reset {
      currentPage = 1
    } else {
      guard hasMorePages else { return }
      currentPage += 1
    }
    
    do {
      let news = try await service.fetch(page: currentPage, count: pageSize)
      if reset {
        items = news
      } else {
        items += news
      }
      hasMorePages = news.count == pageSize
    } catch {
      print("❌ Error \(reset ? "loading initial" : "fetching next") page:", error)
      if !reset { currentPage -= 1 }
    }
    
    isLoading = false
  }
  
  func didSelectItem(at index: Int) {
      guard index < items.count else { return }
      let item = items[index]
      onOpenNews?(item)
  }

  func item(at index: Int) -> NewsItem? {
    guard index < items.count else { return nil }
    return items[index]
  }

  var count: Int { items.count }
}
