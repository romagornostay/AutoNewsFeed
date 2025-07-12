//
//  NewsFeedDataDisplayManager.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 12.07.2025.
//

import Models
import UIKit
import UIComponents

final class NewsFeedDataDisplayManager: NSObject {
  enum Section {
    case main
  }
  
  private let collectionView: UICollectionView
  private var dataSource: UICollectionViewDiffableDataSource<Section, NewsItem>!
  private let viewModel: NewsFeedViewModel
  
  init(collectionView: UICollectionView, viewModel: NewsFeedViewModel) {
    self.collectionView = collectionView
    self.viewModel = viewModel
    super.init()
    setup()
  }
  
  private func setup() {
    collectionView.delegate = self
    
    dataSource = UICollectionViewDiffableDataSource<Section, NewsItem>(
      collectionView: collectionView
    ) { [weak self] collectionView, indexPath, item in
      guard let self = self else { return nil }
      
      switch self.viewModel.design {
      case .old:
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: NewsCell.reuseId,
          for: indexPath
        ) as! NewsCell
        cell.configure(with: item)
        return cell
        
      case .new:
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: NewsCardCell.reuseId,
          for: indexPath
        ) as! NewsCardCell
        cell.configure(with: item)
        return cell
      }
    }
    
    dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
      guard let self = self,
            kind == UICollectionView.elementKindSectionFooter else { return nil }
      
      let view = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: LoaderFooterView.reuseId,
        for: indexPath
      ) as! LoaderFooterView
      
      view.configure(isLoading: self.viewModel.isLoading)
      return view
    }
  }
  
  func applySnapshot() {
    var snapshot = NSDiffableDataSourceSnapshot<Section, NewsItem>()
    snapshot.appendSections([.main])
    snapshot.appendItems(viewModel.items)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
}

extension NewsFeedDataDisplayManager: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.didSelectItem(at: indexPath.item)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    if indexPath.item == viewModel.items.count - 1 {
      Task {
        await viewModel.fetchNextPage()
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
      }
    }
  }
}
