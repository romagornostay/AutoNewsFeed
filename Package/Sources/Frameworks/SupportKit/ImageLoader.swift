//
//  ImageLoader.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 23.06.2025.
//

import UIKit

final class ImageLoader {
  static let shared = ImageLoader()
  
  private let cache = NSCache<NSURL, UIImage>()
  private var tasks = [UIImageView: URLSessionDataTask]()
  
  private init() {}
  
  func load(from url: URL, into imageView: UIImageView) {
    // Отменяем старую задачу (если была)
    tasks[imageView]?.cancel()
    
    if let cached = cache.object(forKey: url as NSURL) {
      imageView.image = cached
      tasks[imageView] = nil
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { [weak self, weak imageView] data, _, _ in
      guard let self, let data, let image = UIImage(data: data) else { return }
      
      self.cache.setObject(image, forKey: url as NSURL)
      
      DispatchQueue.main.async {
        imageView?.image = image
        self.tasks[imageView!] = nil
      }
    }
    
    tasks[imageView] = task
    task.resume()
  }
  
  func cancel(for imageView: UIImageView) {
    tasks[imageView]?.cancel()
    tasks[imageView] = nil
  }
}
