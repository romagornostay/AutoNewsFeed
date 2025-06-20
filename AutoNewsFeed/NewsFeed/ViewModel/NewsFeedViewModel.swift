//
//  NewsFeedViewModel.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 20.06.2025.
//

import Foundation

final class NewsFeedViewModel {
  struct MockItem {
    let title: String
  }
  
  let items: [MockItem] = (1...20).map { MockItem(title: "Новость \($0)") }
}
