//
//  SplashScreenVC.swift
//  Gurme
//
//  Created by Emre Kocak on 24.09.2022.
//

import Lottie
import UIKit

final class SplashScreenVC: UIViewController {

    // MARK: - UI Properties
    private let animationView: AnimationView = {
        let view = AnimationView(name: "burger")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Properties
    var onComplete: (() -> Void)?
    private var hasNavigated = false

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 300),
            animationView.heightAnchor.constraint(equalToConstant: 300)
        ])

        animationView.play()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !hasNavigated else { return }

        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
            guard let self, !self.hasNavigated else { return }
            self.hasNavigated = true
            // Defer to next run loop cycle so current call stack (and any UIKit
            // lifecycle finalization on this VC) completes before rootVC changes.
            DispatchQueue.main.async {
                self.onComplete?()
            }
        }
    }
}
