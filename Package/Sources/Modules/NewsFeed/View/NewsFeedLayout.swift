//
//  NewsFeedLayout.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 20.06.2025.
//

import UIKit

enum NewsFeedLayout {
  static func section() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .estimated(100))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .estimated(100))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 12
    section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    
    // Footer (loader)
    let footer = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(44)
      ),
      elementKind: UICollectionView.elementKindSectionFooter,
      alignment: .bottom
    )
    section.boundarySupplementaryItems = [footer]
    return section
  }
  
  static func makeLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { sectionIndex, environment in
     // let isRegularWidth = environment.traitCollection.horizontalSizeClass == .regular
      let isPad = environment.traitCollection.userInterfaceIdiom == .pad
      let isLandscape = environment.container.effectiveContentSize.width > environment.container.effectiveContentSize.height
      
      let columns: Int
      if isPad {
        columns = isLandscape ? 3 : 2
      } else {
        columns = 1
      }
      
      let spacing: CGFloat = 16
      
      let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(300)
      )
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(300)
      )
      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: groupSize,
        subitem: item,
        count: columns
      )
      group.interItemSpacing = .fixed(spacing)
      
      let section = NSCollectionLayoutSection(group: group)
      section.interGroupSpacing = spacing
      section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
      
      // Footer (loader)
      let footer = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: .init(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .absolute(44)
        ),
        elementKind: UICollectionView.elementKindSectionFooter,
        alignment: .bottom
      )
      section.boundarySupplementaryItems = [footer]
      return section
    }
  }
}
