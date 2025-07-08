//
//  NewsFeedCoordinator.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 20.06.2025.
//

import UIKit

public protocol Coordinator {
  func start()
}

public final class NewsFeedCoordinator: Coordinator {
  private let navigationController: UINavigationController
  
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  public func start() {
    let feedVC = NewsFeedViewController()
    navigationController.pushViewController(feedVC, animated: false)
  }
}

