//
//  AppDateFormatters.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 11.07.2025.
//

import Foundation

public enum AppDateFormatters {
  static let custom: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter
  }()
  
  static let isoLike: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter
  }()
  
  static func parseDate(from string: String) -> Date {
    isoLike.date(from: string) ?? Date()
  }
  
  public static func formattedMedium(from string: String) -> String {
    let date = parseDate(from: string)
    return custom.string(from: date)
  }
}
