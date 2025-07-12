//
//  UIImageView + URL.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 23.06.2025.
//

import UIKit
import ObjectiveC

public protocol ImageLoadable: AnyObject {
  func setImage(_ image: UIImage?, for url: URL)
  func cancelImageLoad()
}

// MARK: - UIImageView + ImageLoadable

private var imageURLKey: UInt8 = 0

extension UIImageView: ImageLoadable {
  private var currentURL: URL? {
    get { objc_getAssociatedObject(self, &imageURLKey) as? URL }
    set { objc_setAssociatedObject(self, &imageURLKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }
  
  public func load(from url: URL) {
    currentURL = url
    ImageLoader.shared.load(from: url, into: self)
  }
  
  public func setImage(_ image: UIImage?, for url: URL) {
    guard currentURL == url else {
      print("⚠️ Ignored outdated image for \(url.lastPathComponent)")
      return
    }
    self.image = image
    tintColor = nil
    contentMode = .scaleAspectFill
  }
  
  public func cancelImageLoad() {
    currentURL = nil
    image = nil
    tintColor = nil
    contentMode = .scaleAspectFill
    ImageLoader.shared.cancel(for: self)
  }
}
