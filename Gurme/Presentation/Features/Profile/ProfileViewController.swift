//
//  ProfileViewController.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - Properties
    var viewModel: ProfileViewModel!
    weak var coordinator: ProfileCoordinator?

    // MARK: - UI Properties
    private lazy var menuTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(
            top: 0,
            left: Constant.Layout.separatorInset,
            bottom: 0,
            right: 0
        )
        tableView.rowHeight = Constant.Layout.rowHeight
        tableView.isScrollEnabled = true
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: Constant.Text.cellIdentifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.appVersion
        label.font = .systemFont(
            ofSize: Constant.Layout.versionFontSize
        )
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        return label
    }()

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - UI Setup
private extension ProfileViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        title = Constant.Text.title
        setupTableView()
        setupFooter()
    }

    func setupTableView() {
        view.addSubview(menuTableView)
        NSLayoutConstraint.activate([
            menuTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            menuTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            menuTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            menuTableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }

    func setupFooter() {
        let footerView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.bounds.width,
                height: Constant.Layout.footerHeight
            )
        )
        footerView.backgroundColor = .systemGroupedBackground
        footerView.addSubview(versionLabel)
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            versionLabel.centerXAnchor.constraint(
                equalTo: footerView.centerXAnchor
            ),
            versionLabel.topAnchor.constraint(
                equalTo: footerView.topAnchor,
                constant: Constant.Layout.versionTopPadding
            )
        ])
        menuTableView.tableFooterView = footerView
    }

    func tintColor(
        for itemColor: ProfileMenuItemColor
    ) -> UIColor {
        switch itemColor {
        case .dark:
            return .darkGray
        case .orange:
            return UIColor(
                named: Constant.Image.mainOrangeColor
            ) ?? .systemOrange
        case .red:
            return .systemRed
        }
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.menuItems.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constant.Text.cellIdentifier,
            for: indexPath
        )
        let item = viewModel.menuItems[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.image = UIImage(systemName: item.icon)
        content.text = item.title
        content.imageProperties.tintColor = tintColor(
            for: item.tintColor
        )
        content.textProperties.font = .systemFont(
            ofSize: Constant.Layout.menuFontSize
        )
        content.textProperties.color = item.tintColor == .red
            ? .systemRed
            : .label
        content.imageToTextPadding = Constant.Layout.iconTextSpacing

        cell.contentConfiguration = content
        cell.selectionStyle = .none

        if item.hasBadge {
            let badgeLabel = UILabel()
            badgeLabel.text = Constant.Text.badgeText
            badgeLabel.font = .boldSystemFont(
                ofSize: Constant.Layout.badgeFontSize
            )
            badgeLabel.textColor = .white
            badgeLabel.backgroundColor = .systemRed
            badgeLabel.textAlignment = .center
            badgeLabel.layer.cornerRadius = Constant.Layout.badgeCornerRadius
            badgeLabel.layer.masksToBounds = true
            badgeLabel.sizeToFit()
            let width = badgeLabel.intrinsicContentSize.width
                + Constant.Layout.badgeHorizontalPadding
            let height = badgeLabel.intrinsicContentSize.height
                + Constant.Layout.badgeVerticalPadding
            badgeLabel.frame = CGRect(
                x: 0,
                y: 0,
                width: width,
                height: height
            )
            cell.accessoryView = badgeLabel
        } else {
            cell.accessoryView = nil
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectItem(at: indexPath.row)
    }
}

// MARK: - ProfileViewModelDelegate
extension ProfileViewController: ProfileViewModelDelegate {
    func didLogout() {
        coordinator?.didLogout()
    }
}

// MARK: - Constants
extension ProfileViewController {
    enum Constant {
        enum Layout {
            static let rowHeight: CGFloat = 56
            static let separatorInset: CGFloat = 56
            static let menuFontSize: CGFloat = 16
            static let versionFontSize: CGFloat = 14
            static let badgeFontSize: CGFloat = 11
            static let badgeCornerRadius: CGFloat = 4
            static let badgeHorizontalPadding: CGFloat = 12
            static let badgeVerticalPadding: CGFloat = 4
            static let iconTextSpacing: CGFloat = 16
            static let footerHeight: CGFloat = 120
            static let versionTopPadding: CGFloat = 20
        }

        enum Image {
            static let mainOrangeColor = "MainOrangeColor"
        }

        enum Text {
            static let title = "Hesabım"
            static let cellIdentifier = "ProfileMenuCell"
            static let badgeText = "YENİ"
        }
    }
}
