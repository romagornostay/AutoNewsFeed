//
//  NewsCardCell.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 10.07.2025.
//

import Formatters
import Models
import SupportKit
import UIKit

public final class NewsCardCell: UICollectionViewCell {
  public static let reuseId = "NewsCardCell"
  
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let dateLabel = UILabel()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .systemGray6
    contentView.layer.cornerRadius = 12
    contentView.layer.masksToBounds = true
    contentView.layer.borderColor = UIColor.separator.cgColor
    contentView.layer.borderWidth = 0.5
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
    imageView.layer.cornerRadius = 0
    
    titleLabel.font = .boldSystemFont(ofSize: 18)
    titleLabel.numberOfLines = 2
    
    subtitleLabel.font = .systemFont(ofSize: 14)
    subtitleLabel.textColor = .secondaryLabel
    subtitleLabel.numberOfLines = 2
    
    dateLabel.font = .systemFont(ofSize: 12)
    dateLabel.textColor = .tertiaryLabel
    
    let titleSubtitleStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    titleSubtitleStack.axis = .vertical
    titleSubtitleStack.spacing = 8
    titleSubtitleStack.translatesAutoresizingMaskIntoConstraints = false

    let spacer = UIView()
    spacer.setContentHuggingPriority(.defaultLow, for: .vertical)

    let textStack = UIStackView(arrangedSubviews: [titleSubtitleStack, spacer, dateLabel])
    textStack.axis = .vertical
    textStack.spacing = 4
    textStack.translatesAutoresizingMaskIntoConstraints = false
    
    // Обёртка с отступами для текстов
    let paddedTextView = UIView()
    paddedTextView.translatesAutoresizingMaskIntoConstraints = false
    paddedTextView.addSubview(textStack)
    
    NSLayoutConstraint.activate([
      textStack.topAnchor.constraint(equalTo: paddedTextView.topAnchor, constant: 12),
      textStack.leadingAnchor.constraint(equalTo: paddedTextView.leadingAnchor, constant: 12),
      textStack.trailingAnchor.constraint(equalTo: paddedTextView.trailingAnchor, constant: -12),
      textStack.bottomAnchor.constraint(equalTo: paddedTextView.bottomAnchor, constant: -12)
    ])
    
    let mainStack = UIStackView(arrangedSubviews: [imageView, paddedTextView])
    mainStack.axis = .vertical
    mainStack.spacing = 8
    mainStack.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(mainStack)
    
    NSLayoutConstraint.activate([
      mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
      mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      
      // соотношение 2:1
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5)
    ])
  }
  
  public func configure(with item: NewsItem) {
    titleLabel.text = item.title
    subtitleLabel.text = item.description
    dateLabel.text = AppDateFormatters.formattedMedium(from: item.publishedDate)
    
    if let urlString = item.titleImageUrl, let url = URL(string: urlString) {
      imageView.load(from: url)
    } else {
      imageView.image = UIImage(systemName: "photo")
    }
  }
}
