//
//  CartViewModel.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Foundation

// MARK: - CartViewModelDelegate
protocol CartViewModelDelegate: AnyObject {
    func didUpdateCart()
    func didUpdateTotalPrice(_ totalText: String)
    func didConfirmOrder()
    func didFailWithError(_ error: Error)
}

// MARK: - CartViewModel
final class CartViewModel {
    weak var delegate: CartViewModelDelegate?

    private let cartRepository: CartRepositoryInterface
    private(set) var cartItems: [CartItem] = []

    private let username = "emre_kocak"

    init(cartRepository: CartRepositoryInterface) {
        self.cartRepository = cartRepository
    }

    var itemCount: Int {
        cartItems.count
    }

    var isEmpty: Bool {
        cartItems.isEmpty
    }

    func item(at index: Int) -> CartItem? {
        guard index >= 0, index < cartItems.count else {
            return nil
        }
        return cartItems[index]
    }

    func fetchCart() {
        Task { @MainActor in
            do {
                let items = try await cartRepository.fetchCartItems(
                    username: username
                )
                self.cartItems = items
                delegate?.didUpdateCart()
                calculateTotal()
            } catch {
                self.cartItems = []
                delegate?.didUpdateCart()
                calculateTotal()
            }
        }
    }

    func deleteItem(at index: Int) {
        guard let cartItem = item(at: index) else { return }
        Task { @MainActor in
            do {
                try await cartRepository.deleteFromCart(
                    cartItemId: cartItem.cartId,
                    username: username
                )
                cartItems.remove(at: index)
                delegate?.didUpdateCart()
                calculateTotal()
            } catch {
                delegate?.didFailWithError(error)
            }
        }
    }

    func deleteAllItems() {
        let items = cartItems
        Task { @MainActor in
            for cartItem in items {
                do {
                    try await cartRepository.deleteFromCart(
                        cartItemId: cartItem.cartId,
                        username: username
                    )
                } catch {
                    delegate?.didFailWithError(error)
                    return
                }
            }
            cartItems.removeAll()
            delegate?.didUpdateCart()
            calculateTotal()
        }
    }

    func confirmOrder() {
        guard !isEmpty else { return }
        delegate?.didConfirmOrder()
    }
}

// MARK: - Price Calculation
private extension CartViewModel {
    func calculateTotal() {
        let total = cartItems.reduce(0) { $0 + $1.totalPrice }
        delegate?.didUpdateTotalPrice("TOTAL: \(total) TL")
    }
}
