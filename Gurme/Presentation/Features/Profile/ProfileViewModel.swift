//
//  ProfileViewModel.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Foundation

// MARK: - ProfileMenuItem
struct ProfileMenuItem {
    let icon: String
    let title: String
    let tintColor: ProfileMenuItemColor
    let hasBadge: Bool

    init(
        icon: String,
        title: String,
        tintColor: ProfileMenuItemColor = .dark,
        hasBadge: Bool = false
    ) {
        self.icon = icon
        self.title = title
        self.tintColor = tintColor
        self.hasBadge = hasBadge
    }
}

enum ProfileMenuItemColor {
    case dark
    case orange
    case red
}

// MARK: - ProfileViewModelDelegate
protocol ProfileViewModelDelegate: AnyObject {
    func didLogout()
}

// MARK: - ProfileViewModel
final class ProfileViewModel {
    weak var delegate: ProfileViewModelDelegate?

    var userName: String {
        "emre_kocak"
    }

    var menuItems: [ProfileMenuItem] {
        [
            ProfileMenuItem(
                icon: "person.crop.circle",
                title: "Kullanıcı Bilgilerim",
                tintColor: .orange
            ),
            ProfileMenuItem(
                icon: "mappin.circle",
                title: "Adreslerim"
            ),
            ProfileMenuItem(
                icon: "creditcard",
                title: "Kayıtlı Kartlarım"
            ),
            ProfileMenuItem(
                icon: "tag",
                title: "İndirim Kuponlarım",
                tintColor: .orange
            ),
            ProfileMenuItem(
                icon: "envelope",
                title: "E-Posta Değişikliği"
            ),
            ProfileMenuItem(
                icon: "bell",
                title: "Duyuru Tercihlerim"
            ),
            ProfileMenuItem(
                icon: "checkmark.square",
                title: "Gurme Seni Dinliyor",
                hasBadge: true
            ),
            ProfileMenuItem(
                icon: "checkmark.shield",
                title: "Güvenlik"
            ),
            ProfileMenuItem(
                icon: "ellipsis.circle",
                title: "Daha Fazla"
            ),
            ProfileMenuItem(
                icon: "rectangle.portrait.and.arrow.right",
                title: "Çıkış Yap",
                tintColor: .red
            )
        ]
    }

    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "v\(version) (\(build))"
    }

    func selectItem(at index: Int) {
        let item = menuItems[index]
        if item.title == "Çıkış Yap" {
            logout()
        }
    }

    func logout() {
        delegate?.didLogout()
    }
}
