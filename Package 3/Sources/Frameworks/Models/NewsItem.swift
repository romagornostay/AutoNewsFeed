//
//  NewsItem.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 23.06.2025.
//

import Foundation

public struct NewsItem: Decodable {
  public init(
    id: Int,
    title: String,
    description: String,
    publishedDate: String,
    fullUrl: String,
    titleImageUrl: String?,
    categoryType: String
  ) {
    self.id = id
    self.title = title
    self.description = description
    self.publishedDate = publishedDate
    self.fullUrl = fullUrl
    self.titleImageUrl = titleImageUrl
    self.categoryType = categoryType
  }
  
  public let id: Int
  public let title: String
  public let description: String
  public let publishedDate: String
  public let fullUrl: String
  public let titleImageUrl: String?
  public let categoryType: String
}
