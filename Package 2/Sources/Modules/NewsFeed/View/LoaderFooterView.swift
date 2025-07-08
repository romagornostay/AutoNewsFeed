//
//  LoaderFooterView.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 24.06.2025.
//

import UIKit

final class LoaderFooterView: UICollectionReusableView {
  static let reuseId = "LoaderFooterView"
  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .medium)
    spinner.hidesWhenStopped = true
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(spinner)
    NSLayoutConstraint.activate([
      spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  func configure(isLoading: Bool) {
    isLoading ? spinner.startAnimating() : spinner.stopAnimating()
  }
}
