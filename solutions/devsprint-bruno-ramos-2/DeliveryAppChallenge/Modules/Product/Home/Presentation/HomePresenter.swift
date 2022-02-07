//
//  HomePresenter.swift
//  DeliveryAppChallenge
//
//  Created by Leonardo Mendes on 30/01/22.
//

import Foundation

/// Protocol used to intermediate communication from Interactor to Presenter ( Interactor ----`response` ----> Presenter )
protocol HomePresentationLogic {
    func presentHomeData(response: HomeUseCase.FetchData.Response)
}

/// Class used to handle data from Interactor, preparing (and deciding how) data to be displated by ViewController
/// Interactor passes a request response to Presenter
/// Presenter hadle this response separating and formating data to be displayed
/// Presenter pass a viewModel with data that User need see to ViewController
final class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?

    func presentHomeData(response: HomeUseCase.FetchData.Response) {
        switch response {
        case .success(let homeRestaurants):
            prepareDisplaySuccess(homeRestaurants)
        case .failure(let error):
            print("Log: \(error.localizedDescription)")

            viewController?.displayHome(viewModel: .failure(error: "Desculpe não conseguimos carregar os dados."))
        }
    }

    private func prepareDisplaySuccess(_ homeRestaurants: Home) {
        let restaurants: [HomeView.RestaurantViewModel] = homeRestaurants.compactMap {
            let subtitle = "\($0.category) \($0.deliveryTime.min)-\($0.deliveryTime.max) min"
            return HomeView.RestaurantViewModel(logo: "restaurant-logo", title: $0.name, subtitle: subtitle)
        }

        viewController?.displayHome(viewModel: .success(HomeView.ViewModel(restaurants: restaurants)))
    }
}
