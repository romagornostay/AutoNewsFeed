//
//  NewsFeedLayout.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 20.06.2025.
//

import Models
import UIKit

enum NewsFeedLayout {
  static func makeLayout(design: @escaping () -> NewsCellDesign) -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { sectionIndex, environment in
      let currentDesign = design()
      return makeSection(for: sectionIndex, design: currentDesign, environment: environment)
    }
  }
  
  private static func makeSection(
    for section: Int,
    design: NewsCellDesign,
    environment: NSCollectionLayoutEnvironment
  ) -> NSCollectionLayoutSection {
    let isPad = environment.traitCollection.userInterfaceIdiom == .pad
    let effectiveContentSize = environment.container.effectiveContentSize
    let isLandscape = effectiveContentSize.width > effectiveContentSize.height
    
    let spacing: CGFloat = 16
    let columns: Int
    let height: CGFloat
    let useEstimated: Bool
    
    switch design {
    case .old:
      columns = 1
      height = 110
      useEstimated = true
    case .new:
      if isPad {
        columns = isLandscape ? 3 : 2
      } else {
        columns = isLandscape ? 2 : 1
      }
      useEstimated = (columns == 1)
      height = useEstimated ? 110 : 340
    }
    
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: useEstimated ? .estimated(height) : .absolute(height)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: useEstimated ? .estimated(height) : .absolute(height)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: columns
    )
    group.interItemSpacing = .fixed(spacing)
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = spacing
    section.contentInsets = NSDirectionalEdgeInsets(
      top: spacing,
      leading: spacing,
      bottom: spacing,
      trailing: spacing
    )
    
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
