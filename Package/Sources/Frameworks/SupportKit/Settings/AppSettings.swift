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
}
