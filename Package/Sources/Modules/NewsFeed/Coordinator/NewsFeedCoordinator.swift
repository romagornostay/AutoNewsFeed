//
//  NewsFeedCoordinator.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 20.06.2025.
//

import AppNavigation
import Models
import NewsDetail
import UIKit

public final class NewsFeedCoordinator: Coordinator {
  private let navigationController: UINavigationController
  
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  public func start() {
    let viewModel = NewsFeedViewModel()
    let feedVC = NewsFeedViewController(viewModel: viewModel)
    
    viewModel.onOpenNews = { [weak self] newsItem in
      self?.startNewsDetailCoordinator(with: newsItem)
    }
    
    navigationController.pushViewController(feedVC, animated: false)
  }
  
  private func startNewsDetailCoordinator(with item: NewsItem) {
    let coordinator = NewsDetailCoordinator(
      navigationController: navigationController,
      newsItem: item
    )
    coordinator.start()
  }
}
