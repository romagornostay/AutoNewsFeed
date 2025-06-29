//
//  AppCoordinator.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 20.06.2025.
//

import NewsFeed
import UIKit

public final class AppCoordinator {
  private let window: UIWindow
  private let rootNav = UINavigationController()
  private var newsCoordinator: NewsFeedCoordinator?
  
  public init(window: UIWindow) {
    self.window = window
    rootNav.navigationBar.prefersLargeTitles = true
  }
  
  public func start() {
    let coordinator = NewsFeedCoordinator(navigationController: rootNav)
    self.newsCoordinator = coordinator
    window.rootViewController = rootNav
    window.makeKeyAndVisible()
    coordinator.start()
  }
}
