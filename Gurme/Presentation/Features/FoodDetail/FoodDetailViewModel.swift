//
//  FoodDetailViewModel.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Foundation

// MARK: - FoodDetailViewModelDelegate
protocol FoodDetailViewModelDelegate: AnyObject {
    func didUpdateUI(
        name: String,
        priceText: String,
        imageURL: URL?,
        detail: FoodDetail?
    )
    func didUpdateQuantity(_ quantity: Int, priceText: String)
    func didAddToCart()
    func didFailWithError(_ error: Error)
}

// MARK: - FoodDetailViewModel
final class FoodDetailViewModel {
    weak var delegate: FoodDetailViewModelDelegate?

    private let food: Food
    private let cartRepository: CartRepositoryInterface
    private var quantity = 1
    private let username = "emre_kocak"

    private static let detailList: [FoodDetail] = [
        FoodDetail(
            starRating: "4.7",
            description: "Ayran içtikçe ferahlayacak ve kendinizi yenilenmiş hissedeceksiniz.",
            prepareTime: "5 dk"
        ),
        FoodDetail(
            starRating: "4.9",
            description: "İnce yufkaların arasına tercihinize göre ceviz, antep fıstığı, badem veya fındık konarak yapılır.",
            prepareTime: "10 dk"
        ),
        FoodDetail(
            starRating: "4.8",
            description: "Meyve aromalı gazlı alkolsüz içeceklerden olan Fanta yemeklerinize eşlik etsin.",
            prepareTime: "0 dk"
        ),
        FoodDetail(
            starRating: "4.5",
            description: "Dumanı üstünde bu lezzet kaçmaz. Gurme şefler ile özel hazırlanan somon.",
            prepareTime: "35 dk"
        ),
        FoodDetail(
            starRating: "4.2",
            description: "Özel hazırlanmış bu efsane tavuğu kaçırma. Size özel hazırlanır.",
            prepareTime: "25 dk"
        ),
        FoodDetail(
            starRating: "4.1",
            description: "Katmanlarının arasına isteğe bağlı fıstık veya ceviz gibi maddeler konduktan sonra fırında kızartılır.",
            prepareTime: "30 dk"
        ),
        FoodDetail(
            starRating: "3.9",
            description: "En geleneksel kahve pişirme yöntemlerinden biri olan kumda kahve usul usul pişerek servis edilir.",
            prepareTime: "15 dk"
        ),
        FoodDetail(
            starRating: "4.8",
            description: "Kıymanın özel hazırlanması ile elde edilen efsane lezzet. Tam anne köftesi.",
            prepareTime: "20 dk"
        ),
        FoodDetail(
            starRating: "4.9",
            description: "Lazanya, peynir, domates sosu veya ragù ile yapılır.",
            prepareTime: "30 dk"
        ),
        FoodDetail(
            starRating: "5",
            description: "Geleneksel İtalyan mutfağının temel besini ve gurme şeflerin bu özel sosu ile kaçırılmaz lezzet.",
            prepareTime: "25 dk"
        ),
        FoodDetail(
            starRating: "4.9",
            description: "Pizza, domates, peynir ve çeşitli diğer malzemeler isteğe bağlı eklenebilir.",
            prepareTime: "30 dk"
        ),
        FoodDetail(
            starRating: "5",
            description: "Kaynağımız, yerleşim birimlerinden oldukça uzakta doğanın tam kalbinde yer alıyor.",
            prepareTime: "0 dk"
        ),
        FoodDetail(
            starRating: "4.9",
            description: "Türk mutfağında yer alan en yaygın sütlü tatlılardan. Başlıca malzemeleri pirinç, süt ve şekerdir.",
            prepareTime: "20 dk"
        ),
        FoodDetail(
            starRating: "4.3",
            description: "Tiramisu, ana malzemesi mascarpone peyniri ve çikolata olan İtalyan tatlısı.",
            prepareTime: "10 dk"
        )
    ]

    init(food: Food, cartRepository: CartRepositoryInterface) {
        self.food = food
        self.cartRepository = cartRepository
    }

    func loadDetail() {
        let idx = (Int(food.id) ?? 1) - 1
        let detail: FoodDetail?
        if idx >= 0, idx < Self.detailList.count {
            detail = Self.detailList[idx]
        } else {
            detail = nil
        }
        delegate?.didUpdateUI(
            name: food.name,
            priceText: "\(food.price) ₺",
            imageURL: food.imageURL,
            detail: detail
        )
    }

    func incrementQuantity() {
        quantity += 1
        updateQuantityDisplay()
    }

    func decrementQuantity() {
        guard quantity > 1 else { return }
        quantity -= 1
        updateQuantityDisplay()
    }

    func addToCart() {
        Task { @MainActor in
            do {
                try await cartRepository.addToCart(
                    foodName: food.name,
                    imageName: food.imageName,
                    price: food.priceValue,
                    orderCount: quantity,
                    username: username
                )
                delegate?.didAddToCart()
            } catch {
                delegate?.didFailWithError(error)
            }
        }
    }
}

// MARK: - Private Helpers
private extension FoodDetailViewModel {
    func updateQuantityDisplay() {
        let totalPrice = food.priceValue * quantity
        delegate?.didUpdateQuantity(
            quantity,
            priceText: "\(totalPrice) ₺"
        )
    }
}
