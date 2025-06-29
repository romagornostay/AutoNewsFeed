//
//  NewsService.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 23.06.2025.
//

import Foundation
import Models

public protocol NewsService {
  func fetch(page: Int, count: Int) async throws -> [NewsItem]
}
