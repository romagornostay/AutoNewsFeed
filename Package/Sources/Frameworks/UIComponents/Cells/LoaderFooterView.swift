//
//  LoaderFooterView.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 24.06.2025.
//

import UIKit

public final class LoaderFooterView: UICollectionReusableView {
  public override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(spinner)
    NSLayoutConstraint.activate([
      spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  required init?(coder: NSCoder) { fatalError() }
  
  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .medium)
    spinner.hidesWhenStopped = true
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
  }()
  public static let reuseId = "LoaderFooterView"
  
  public func configure(isLoading: Bool) {
    isLoading ? spinner.startAnimating() : spinner.stopAnimating()
  }
}
