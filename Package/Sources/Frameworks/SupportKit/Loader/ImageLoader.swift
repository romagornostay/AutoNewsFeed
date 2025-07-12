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
  private let fileManager = FileManager.default
  private let diskCacheURL: URL
  private let diskCacheLimitBytes: Int = 100 * 1024 * 1024 // 100 MB
  
  private init() {
    let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
    diskCacheURL = urls[0].appendingPathComponent("ImageLoaderCache", isDirectory: true)
    
    try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
    cleanDiskIfNeeded()
  }
  
  func load(from url: URL, into imageView: UIImageView) {
    tasks[imageView]?.cancel()
    
    if let cached = memoryCache.object(forKey: url as NSURL) {
      imageView.image = cached
      tasks[imageView] = nil
      return
    }
    
    if let diskImage = loadImageFromDisk(for: url) {
      memoryCache.setObject(diskImage, forKey: url as NSURL)
      imageView.image = diskImage
      tasks[imageView] = nil
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { [weak self, weak imageView] data, _, _ in
      guard let self, let data, let image = UIImage(data: data) else { return }
      
      self.memoryCache.setObject(image, forKey: url as NSURL)
      self.saveImageToDisk(image, for: url)
      
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
  
  // MARK: - Disk Cache
  
  private func filePath(for url: URL) -> URL {
    let filename = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
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
    cleanDiskIfNeeded()
  }
  
  private func cleanDiskIfNeeded() {
    let contents = (try? fileManager.contentsOfDirectory(at: diskCacheURL, includingPropertiesForKeys: [.contentAccessDateKey, .fileSizeKey], options: .skipsHiddenFiles)) ?? []
    
    var files: [(url: URL, size: Int, accessDate: Date)] = []
    
    var currentSize = 0
    
    for fileURL in contents {
      let resource = try? fileURL.resourceValues(forKeys: [.contentAccessDateKey, .fileSizeKey])
      let size = resource?.fileSize ?? 0
      let accessDate = resource?.contentAccessDate ?? Date.distantPast
      currentSize += size
      files.append((fileURL, size, accessDate))
    }
    
    guard currentSize > diskCacheLimitBytes else { return }
    
    let sortedFiles = files.sorted { $0.accessDate < $1.accessDate }
    
    var sizeToFree = currentSize - diskCacheLimitBytes
    
    for file in sortedFiles {
      try? fileManager.removeItem(at: file.url)
      sizeToFree -= file.size
      if sizeToFree <= 0 { break }
    }
  }
}
