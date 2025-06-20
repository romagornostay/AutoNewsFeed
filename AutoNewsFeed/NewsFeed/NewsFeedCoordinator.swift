//
//  NewsFeedCoordinator.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 20.06.2025.
//

import UIKit

protocol Coordinator {
  func start()
}

final class NewsFeedCoordinator: Coordinator {
  private let navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let feedVC = NewsFeedViewController()
    navigationController.pushViewController(feedVC, animated: false)
  }
}

