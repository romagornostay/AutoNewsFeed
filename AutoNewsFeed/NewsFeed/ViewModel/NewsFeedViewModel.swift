//
//  NewsFeedViewModel.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 20.06.2025.
//

import Foundation

@MainActor
final class NewsFeedViewModel {
    private let service: NewsService
    private(set) var items: [NewsItem] = []
    var onUpdate: (() -> Void)?

    init(service: NewsService = DefaultNewsService()) {
        self.service = service
    }

    func loadInitial() async {
        do {
            let news = try await service.fetch(page: 1, count: 15)
            self.items = news
            onUpdate?()
        } catch {
            print("❌ Error loading news:", error)
        }
    }

    func item(at index: Int) -> NewsItem {
        items[index]
    }

    var count: Int {
        items.count
    }
//  struct MockItem {
//    let title: String
//  }
//  
//  let items: [MockItem] = (1...20).map { MockItem(title: "Новость \($0)") }
}
