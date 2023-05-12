//
//  ApiRepo+Series.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 11/5/23.
//

import Foundation

extension MarvelRepository {
    
    func GetSeries(offset: Int = 0, limit: Int = 20, characterId: Int, onSuccess: @escaping (HeroesContentResponse) -> (), onError: @escaping (HeroError)->() = {_ in } )
    {
        let marvelComponents = MarvelURLComponents()
        
        marvelComponents
            .AddToPath(.Series)
            .AddOffset(offset: offset)
            .AddLimit(limit: limit)
            .AddCharacterId(characterId: characterId)
        
        
        MarvelRepository.GetApiData(urlComponent: marvelComponents, onSuccess: onSuccess, onError: onError)
        
    }

    
}

