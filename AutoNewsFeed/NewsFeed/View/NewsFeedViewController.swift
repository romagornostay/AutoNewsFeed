//
//  NewsFeedViewController.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 20.06.2025.
//

import UIKit

final class NewsFeedViewController: UIViewController {
  private var collectionView: UICollectionView!
  private let viewModel = NewsFeedViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "News"
    view.backgroundColor = .systemBackground
    setupCollectionView()
    
    viewModel.onUpdate = { [weak self] in
      self?.collectionView.reloadData()
    }
    Task {
      await viewModel.loadInitial()
    }
  }
  
  private func setupCollectionView() {
    let layout = UICollectionViewCompositionalLayout { _, _ in
      return NewsFeedLayout.section()
    }
    
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .systemBackground
    collectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.reuseId)
    collectionView.dataSource = self
    collectionView.delegate = self
    
    collectionView.register(LoaderFooterView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: LoaderFooterView.reuseId)
    
    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

extension NewsFeedViewController: UICollectionViewDelegate { }

extension NewsFeedViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.reuseId, for: indexPath) as? NewsCell, let item = viewModel.item(at: indexPath.item) else {
      fatalError("Could not dequeue NewsCell")
    }
//    let item = viewModel.item(at: indexPath.item)
    cell.configure(with: item)
    return cell
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    guard kind == UICollectionView.elementKindSectionFooter else {
      return UICollectionReusableView()
    }
    let view = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: LoaderFooterView.reuseId,
      for: indexPath
    ) as! LoaderFooterView
    view.configure(isLoading: viewModel.isLoading)
    return view
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    Task {
      if indexPath.item == viewModel.items.count - 1 {
        await viewModel.fetchNextPage()
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
      }
    }
  }
}
