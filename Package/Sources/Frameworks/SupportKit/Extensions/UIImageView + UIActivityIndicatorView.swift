//
//  UIImageView + UIActivityIndicatorView.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 12.07.2025.
//

import UIKit

private var activityIndicatorKey: UInt8 = 0

extension UIImageView {
    private var loadingIndicator: UIActivityIndicatorView {
        if let existing = objc_getAssociatedObject(self, &activityIndicatorKey) as? UIActivityIndicatorView {
            return existing
        }
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        objc_setAssociatedObject(self, &activityIndicatorKey, indicator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return indicator
    }
    
    func startLoading() {
        loadingIndicator.startAnimating()
    }
    
    func stopLoading() {
        loadingIndicator.stopAnimating()
    }
}
