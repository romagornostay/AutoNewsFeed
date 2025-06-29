//
//  NewsCell.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 20.06.2025.
//

import UIKit
import Models

final class NewsCell: UICollectionViewCell {
  static let reuseId = "NewsCell"
  
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let dateLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .systemGray6
    contentView.layer.cornerRadius = 12
    contentView.layer.masksToBounds = true
    setupUI()
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.cancelImageLoad()
    imageView.image = nil
  }
  
  private func setupUI() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 8
    
    titleLabel.font = .boldSystemFont(ofSize: 14)
    titleLabel.numberOfLines = 2
    
    subtitleLabel.font = .systemFont(ofSize: 12)
    subtitleLabel.textColor = .secondaryLabel
    subtitleLabel.numberOfLines = 2
    
    dateLabel.font = .systemFont(ofSize: 10)
    dateLabel.textColor = .tertiaryLabel
    
    let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, dateLabel])
    textStack.axis = .vertical
    textStack.spacing = 4
    textStack.translatesAutoresizingMaskIntoConstraints = false
    
    let mainStack = UIStackView(arrangedSubviews: [imageView, textStack])
    mainStack.axis = .horizontal
    mainStack.spacing = 12
    mainStack.alignment = .center
    mainStack.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(mainStack)
    
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalToConstant: 80),
      imageView.heightAnchor.constraint(equalToConstant: 80),
      
      mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
      mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
      mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
    ])
  }
  
  func configure(with item: NewsItem) {
    titleLabel.text = item.title
    subtitleLabel.text = item.description
    dateLabel.text = dateFormatterMedium.string(from: dateFormateFromString(value: item.publishedDate))
    //dateLabel.text = formatDate(item.publishedDate)
    
    if let urlString = item.titleImageUrl, let url = URL(string: urlString) {
      imageView.load(from: url)
    } else {
      imageView.image = UIImage(systemName: "cloud.moon.bolt")
    }
  }
//  private func formatDate(_ iso: String) -> String {
//    let isoFormatter = ISO8601DateFormatter()
//    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
//    formatter.locale = Locale(identifier: "ru_RU")
//    return isoFormatter.date(from: iso).map { formatter.string(from: $0) } ?? ""
//  }
  private func formatDate(_ iso: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    formatter.locale = Locale(identifier: "ru_RU")
//    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateStyle = .medium
    
    let date = formatter.date(from: iso) ?? Date()
    let output = DateFormatter()
    output.dateFormat = "dd.MM.yyyy"
    return output.string(from: date)
  }
  
  func dateFormateFromString(value: String) -> Date {
    isoLikeFormatter.date(from: value) ?? Date()
  }
  
  let dateFormatterMedium: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter
  }()
  private let isoLikeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter
  }()
}
