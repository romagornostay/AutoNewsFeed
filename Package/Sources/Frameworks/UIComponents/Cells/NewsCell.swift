//
//  NewsCell.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 20.06.2025.
//

import Formatters
import Models
import SupportKit
import UIKit

public final class NewsCell: UICollectionViewCell {
  public static let reuseId = "NewsCell"
  
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let dateLabel = UILabel()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .systemGray6
    contentView.layer.cornerRadius = 12
    contentView.layer.masksToBounds = true
    setupUI()
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    imageView.cancelImageLoad()
    imageView.image = nil
  }
  
  public override func preferredLayoutAttributesFitting(
    _ layoutAttributes: UICollectionViewLayoutAttributes
  ) -> UICollectionViewLayoutAttributes {
    setNeedsLayout()
    layoutIfNeeded()
    print("🔍 Calculating size for item with height: \(layoutAttributes.size.height)")
    let targetSize = CGSize(width: layoutAttributes.size.width, height: UIView.layoutFittingCompressedSize.height)
    let autoLayoutSize = contentView.systemLayoutSizeFitting(
      targetSize,
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .fittingSizeLevel
    )
    
    var updatedFrame = layoutAttributes.frame
    updatedFrame.size.height = autoLayoutSize.height
    layoutAttributes.frame = updatedFrame
    return layoutAttributes
  }
  
  private func setupUI() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 8
    imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
    let height = imageView.heightAnchor.constraint(equalToConstant: 80)
    height.priority = .defaultHigh
    height.isActive = true
    
    titleLabel.font = .boldSystemFont(ofSize: 14)
    titleLabel.numberOfLines = 2
    
    subtitleLabel.font = .systemFont(ofSize: 12)
    subtitleLabel.textColor = .secondaryLabel
    subtitleLabel.numberOfLines = 2
    
    dateLabel.font = .systemFont(ofSize: 10)
    dateLabel.textColor = .tertiaryLabel
    
    let titleSubtitleStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    titleSubtitleStack.axis = .vertical
    titleSubtitleStack.spacing = 4
    titleSubtitleStack.translatesAutoresizingMaskIntoConstraints = false
    
    let spacer = UIView()
    spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
    
    let textStack = UIStackView(arrangedSubviews: [titleSubtitleStack, spacer, dateLabel])
    textStack.axis = .vertical
    textStack.spacing = 4
    textStack.translatesAutoresizingMaskIntoConstraints = false
    
    let mainStack = UIStackView(arrangedSubviews: [imageView, textStack])
    mainStack.axis = .horizontal
    mainStack.spacing = 12
    mainStack.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(mainStack)
    
    NSLayoutConstraint.activate([
      mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
      mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
      mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
    ])
  }
  
  public func configure(with item: NewsItem) {
    titleLabel.text = item.title
    subtitleLabel.text = item.description
    dateLabel.text = AppDateFormatters.formattedMedium(from: item.publishedDate)
    
    if let urlString = item.titleImageUrl, let url = URL(string: urlString) {
      imageView.load(from: url)
    } else {
      imageView.image = UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
      imageView.tintColor = .lightGray
      imageView.contentMode = .scaleAspectFit
    }
  }
}
