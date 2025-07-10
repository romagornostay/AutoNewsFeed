//
//  NewsFeedViewController.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 20.06.2025.
//

import UIKit
import Models

final class NewsFeedViewController: UIViewController {
  
  init(viewModel: NewsFeedViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private var collectionView: UICollectionView!
  private let viewModel: NewsFeedViewModel
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "News"
    view.backgroundColor = .systemBackground
    
    setupNavigationMenu()
    setupCollectionView()
    
    viewModel.onUpdate = { [weak self] in
      self?.collectionView.reloadData()
    }
    Task {
      await viewModel.loadInitial()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

      navigationItem.largeTitleDisplayMode = .always
      navigationController?.navigationBar.prefersLargeTitles = true

//      let appearance = UINavigationBarAppearance()
//      appearance.configureWithDefaultBackground()
//      appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
//      appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
//
//      navigationItem.standardAppearance = appearance
//      navigationItem.scrollEdgeAppearance = appearance
  }
  
  private func setupNavigationMenu() {
    let oldAction = UIAction(
      title: "Old Design",
      image: UIImage(systemName: "square")
    ) { [weak self] _ in
      self?.viewModel.setDesign(.old)
    }
    
    let newAction = UIAction(
      title: "New Design",
      image: UIImage(systemName: "rectangle.3.offgrid")
    ) { [weak self] _ in
      self?.viewModel.setDesign(.new)
    }
    
    let menu = UIMenu(title: "Select Design", options: .displayInline, children: [oldAction, newAction])
    
    let menuButton = UIBarButtonItem(
      title: nil,
      image: UIImage(systemName: "slider.horizontal.3"),
      primaryAction: nil,
      menu: menu
    )
    
    navigationItem.rightBarButtonItem = menuButton
  }
  
  private func setupCollectionView() {
    let layout = UICollectionViewCompositionalLayout { _, _ in
      return NewsFeedLayout.section()
    }
    
    let newLayout = NewsFeedLayout.makeLayout()
    
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: newLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .systemBackground
    collectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.reuseId)
    collectionView.register(NewsCardCell.self, forCellWithReuseIdentifier: NewsCardCell.reuseId)
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

extension NewsFeedViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.didSelectItem(at: indexPath.item)
  }
}

extension NewsFeedViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let item = viewModel.item(at: indexPath.item) else { fatalError("Could not get Item") }
    switch viewModel.design {
    case .old:
      guard let cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: NewsCell.reuseId, for: indexPath) as? NewsCell
      else { fatalError("Could not dequeue NewsCell") }
      cell.configure(with: item)
      return cell
      
    case .new:
      guard let cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: NewsCardCell.reuseId, for: indexPath) as? NewsCardCell
      else { fatalError("Could not dequeue NewsCardCell") }
      cell.configure(with: item)
      return cell
    }
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
