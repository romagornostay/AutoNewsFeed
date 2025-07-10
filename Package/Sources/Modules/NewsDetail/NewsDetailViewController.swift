//
//  NewsDetailViewController.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 10.07.2025.
//

import Models
import UIKit
import WebKit

public final class NewsDetailViewController: UIViewController {
  
  private let newsItem: NewsItem
  private var webView: WKWebView!
  
  public init(newsItem: NewsItem) {
    self.newsItem = newsItem
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func loadView() {
    webView = WKWebView()
    view = webView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    title = newsItem.title
    view.backgroundColor = .systemBackground
    
    if let url = URL(string: newsItem.fullUrl) {
      webView.load(URLRequest(url: url))
    } else {
      showError()
    }
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.title = ""
    navigationItem.largeTitleDisplayMode = .never
    
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .systemBackground
    appearance.shadowColor = nil
    
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
  }

  private func showError() {
    let label = UILabel()
    label.text = "cant load news"
    label.textAlignment = .center
    label.textColor = .secondaryLabel
    view = label
  }
}
