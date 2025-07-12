//
//  ImageLoader.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 23.06.2025.
//

import UIKit

final class ImageLoader {
  static let shared = ImageLoader()
  
  private let memoryCache = NSCache<NSURL, UIImage>()
  private var tasks = [UIImageView: URLSessionDataTask]()
  private let fileManager: FileManager
  private let diskCacheURL: URL
  
  private init() {
    self.fileManager = .default
    
    let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
    diskCacheURL = urls[0].appendingPathComponent("ImageLoaderCache", isDirectory: true)
    
    try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
  }
  
  func load(from url: URL, into imageView: UIImageView) {
    imageView.startLoading()
    tasks[imageView]?.cancel()
    
    if let cached = memoryCache.object(forKey: url as NSURL) {
      imageView.image = cached
      tasks[imageView] = nil
      imageView.stopLoading()
      return
    }
    
    if let diskImage = loadImageFromDisk(for: url) {
      memoryCache.setObject(diskImage, forKey: url as NSURL)
      imageView.image = diskImage
      tasks[imageView] = nil
      imageView.stopLoading()
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { [weak self, weak imageView] data, _, _ in
      guard let self, let data, let image = UIImage(data: data), let imageView else { return }
      
      memoryCache.setObject(image, forKey: url as NSURL)
      saveImageToDisk(image, for: url)
      
      DispatchQueue.main.async {
        imageView.setImage(image, for: url)
        imageView.stopLoading()
        self.tasks[imageView] = nil
      }
    }
    
    tasks[imageView] = task
    task.resume()
  }
  
  func cancel(for imageView: UIImageView) {
    tasks[imageView]?.cancel()
    tasks[imageView] = nil
  }
  
  func getCacheSizeInMB() -> Double {
    let contents = (try? fileManager.contentsOfDirectory(
      at: diskCacheURL,
      includingPropertiesForKeys: [.fileSizeKey],
      options: .skipsHiddenFiles
    )) ?? []
    
    var currentSize = 0
    for fileURL in contents {
      let resource = try? fileURL.resourceValues(forKeys: [.fileSizeKey])
      currentSize += resource?.fileSize ?? 0
    }
    return Double(currentSize) / 1024.0 / 1024.0
  }
  
  func clearDiskCache() {
    let contents = (try? fileManager.contentsOfDirectory(
      at: diskCacheURL,
      includingPropertiesForKeys: nil,
      options: .skipsHiddenFiles
    )) ?? []

    for fileURL in contents {
      try? fileManager.removeItem(at: fileURL)
    }
  }


    
  private func filePath(for url: URL) -> URL {
    let filename = url.absoluteString.addingPercentEncoding(
      withAllowedCharacters: .alphanumerics
    ) ?? UUID().uuidString
    return diskCacheURL.appendingPathComponent(filename)
  }
  
  private func loadImageFromDisk(for url: URL) -> UIImage? {
    let path = filePath(for: url)
    guard let data = try? Data(contentsOf: path) else { return nil }
    return UIImage(data: data)
  }
  
  private func saveImageToDisk(_ image: UIImage, for url: URL) {
    guard let data = image.pngData() else { return }
    let path = filePath(for: url)
    try? data.write(to: path)
  }
}
