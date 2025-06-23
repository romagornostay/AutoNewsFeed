//
//  NewsItem.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 23.06.2025.
//

import Foundation

struct NewsItem: Decodable {
  let id: Int
  let title: String
  let description: String
  let publishedDate: String
  let fullUrl: String
  let titleImageUrl: String
  let categoryType: String
}
