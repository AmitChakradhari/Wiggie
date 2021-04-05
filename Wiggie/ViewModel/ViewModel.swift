//
//  ViewModel.swift
//  Wiggie
//
//  Created by Amit  Chakradhari on 05/04/21.
//  Copyright © 2021 Amit  Chakradhari. All rights reserved.
//

import Foundation
import RxSwift

class ViewModel {
    var loading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var error: PublishSubject<Error> = PublishSubject()
    var movies: BehaviorSubject<[MovieItem]?> = BehaviorSubject(value: nil)
    
    func fetchMovies(searchText: String, page: Int) {
        loading.onNext(true)
        NetworkWorker.getMovies(keyword: searchText, page: page, completion: { movieResponses, error in
            
            self.loading.onNext(false)
            
            guard error == nil else {
                self.error.onNext(error!)
                return
            }
            
            self.movies.onNext(movieResponses?.Search)
        })
    }
}
