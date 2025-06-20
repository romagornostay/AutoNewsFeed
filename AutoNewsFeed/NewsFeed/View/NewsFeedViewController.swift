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
    
    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

extension NewsFeedViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.reuseId, for: indexPath) as? NewsCell else {
      fatalError("Could not dequeue NewsCell")
    }
    cell.configure(with: viewModel.items[indexPath.item])
    return cell
  }
}
