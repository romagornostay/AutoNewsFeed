//
//  UIImageView + URL.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 23.06.2025.
//

import UIKit

extension UIImageView {
  func load(url: URL) {
    let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
      guard let data, let image = UIImage(data: data) else { return }
      DispatchQueue.main.async {
        self?.image = image
      }
    }
    task.resume()
  }
  
  func load(from url: URL) {
    ImageLoader.shared.load(from: url, into: self)
  }
  
  func cancelImageLoad() {
    ImageLoader.shared.cancel(for: self)
  }
}
