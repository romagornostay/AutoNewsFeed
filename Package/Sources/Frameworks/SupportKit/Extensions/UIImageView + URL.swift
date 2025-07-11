//
//  UIImageView + URL.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 23.06.2025.
//

import UIKit

public extension UIImageView {
  func load(from url: URL) {
    ImageLoader.shared.load(from: url, into: self)
  }
  
  func cancelImageLoad() {
    ImageLoader.shared.cancel(for: self)
  }
}
