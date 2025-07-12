//
//  NewsFeedViewController.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 20.06.2025.
//

import Models
import UIKit
import UIComponents

final class NewsFeedViewController: UIViewController {
  
  init(viewModel: NewsFeedViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var collectionView: UICollectionView = {
    let layout = NewsFeedLayout.makeLayout { [weak self] in
      self?.viewModel.design ?? .old
    }
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()
  
  private let viewModel: NewsFeedViewModel
  private var dataDisplayManager: NewsFeedDataDisplayManager!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "News"
    view.backgroundColor = .systemBackground
    
    setupNavigationMenu()
    setupCollectionView()
    
    dataDisplayManager = NewsFeedDataDisplayManager(
      collectionView: collectionView,
      viewModel: viewModel
    )
    
    viewModel.onUpdate = { [weak self] in
      self?.dataDisplayManager.applySnapshot()
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
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .systemBackground
    collectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.reuseId)
    collectionView.register(NewsCardCell.self, forCellWithReuseIdentifier: NewsCardCell.reuseId)
    collectionView.register(
      LoaderFooterView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: LoaderFooterView.reuseId
    )
    
    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}
