//
//  FavoritesViewController.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import UIKit

final class FavoritesViewController: UIViewController {
    // MARK: - Properties
    var viewModel: FavoritesViewModel!
    weak var coordinator: FavoritesCoordinator?

    // MARK: - UI Properties
    private var favoriteCollectionView: UICollectionView!
    private var favoriteDataSource: UICollectionViewDiffableDataSource<Int, Food>!

    private lazy var emptyStateVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Constant.Layout.emptyStackSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var emptyIconImageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(
            pointSize: Constant.Layout.emptyIconSize,
            weight: .light
        )
        let imageView = UIImageView(
            image: UIImage(
                systemName: Constant.Image.emptyIcon,
                withConfiguration: config
            )
        )
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var emptyMessageLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.Text.emptyMessage
        label.font = .systemFont(
            ofSize: Constant.Layout.emptyLabelFontSize,
            weight: .medium
        )
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        applySnapshot()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
        applySnapshot()
    }
}

// MARK: - UI Setup
private extension FavoritesViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        title = Constant.Text.title
        setupCollectionView()
        setupEmptyState()
    }

    func setupCollectionView() {
        var config = UICollectionLayoutListConfiguration(
            appearance: .plain
        )
        config.trailingSwipeActionsConfigurationProvider = {
            [weak self] indexPath in
            self?.swipeActions(for: indexPath)
        }
        let layout = UICollectionViewCompositionalLayout.list(
            using: config
        )
        favoriteCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        favoriteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        favoriteCollectionView.delegate = self
        view.addSubview(favoriteCollectionView)
        NSLayoutConstraint.activate([
            favoriteCollectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            favoriteCollectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            favoriteCollectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            favoriteCollectionView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }

    func setupEmptyState() {
        emptyStateVerticalStackView.addArrangedSubview(
            emptyIconImageView
        )
        emptyStateVerticalStackView.addArrangedSubview(
            emptyMessageLabel
        )
        view.addSubview(emptyStateVerticalStackView)
        NSLayoutConstraint.activate([
            emptyStateVerticalStackView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            emptyStateVerticalStackView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )
        ])
    }

    func swipeActions(
        for indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: Constant.Text.deleteAction
        ) { [weak self] _, _, completion in
            self?.viewModel.removeFavorite(at: indexPath.item)
            completion(true)
        }
        return UISwipeActionsConfiguration(
            actions: [deleteAction]
        )
    }
}

// MARK: - DiffableDataSource
private extension FavoritesViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<FavoriteFoodCell, Food> { cell, _, food in
            cell.configure(with: food)
        }
        favoriteDataSource = UICollectionViewDiffableDataSource<Int, Food>(
            collectionView: favoriteCollectionView
        ) { collectionView, indexPath, food in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: food
            )
        }
    }

    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Food>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.favorites)
        favoriteDataSource.apply(
            snapshot,
            animatingDifferences: true
        )
        updateEmptyState()
    }

    func updateEmptyState() {
        emptyStateVerticalStackView.isHidden = !viewModel.isEmpty
        favoriteCollectionView.isHidden = viewModel.isEmpty
    }
}

// MARK: - UICollectionViewDelegate
extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(
            at: indexPath,
            animated: true
        )
        guard let food = viewModel.food(at: indexPath.item) else {
            return
        }
        coordinator?.showFoodDetail(food: food)
    }
}

// MARK: - FavoritesViewModelDelegate
extension FavoritesViewController: FavoritesViewModelDelegate {
    func didUpdateFavorites() {
        guard isViewLoaded else { return }
        applySnapshot()
    }
}

// MARK: - Constants
extension FavoritesViewController {
    enum Constant {
        enum Layout {
            static let estimatedRowHeight: CGFloat = 100
            static let emptyLabelFontSize: CGFloat = 18
            static let emptyIconSize: CGFloat = 60
            static let emptyStackSpacing: CGFloat = 12
        }

        enum Image {
            static let emptyIcon = "heart.slash"
        }

        enum Text {
            static let title = "Favoriler"
            static let emptyMessage = "Henüz favori eklenmedi."
            static let deleteAction = "Sil"
        }
    }
}
