//
//  AppSettings.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 11.07.2025.
//

import Foundation
import Models

public enum AppSettings {
  @UserDefaultEnum(key: "cellsDesign", defaultValue: .old)
  public static var newsCellDesign: NewsCellDesign
  
  // MARK: - Disk Cache Info
  
  public static var imageCacheSizeMB: Double {
    ImageLoader.shared.getCacheSizeInMB()
  }
  
  public static func clearImageCache() {
    ImageLoader.shared.clearDiskCache()
  }
}
