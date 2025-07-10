//
//  NewsDetailCoordinator.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 10.07.2025.
//

import AppNavigation
import Models
import UIKit

public final class NewsDetailCoordinator: Coordinator {
  private let navigationController: UINavigationController
  private let newsItem: NewsItem
  
  public init(navigationController: UINavigationController, newsItem: NewsItem) {
    self.navigationController = navigationController
    self.newsItem = newsItem
  }
  
  public func start() {
    let vc = NewsDetailViewController(newsItem: newsItem)
    navigationController.pushViewController(vc, animated: true)
  }
}
