//
//  ApiRepo+Comics.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 5/5/23.
//

import Foundation

extension MarvelRepository {
    
    func GetComics(offset: Int = 0, limit: Int = 20, heroName: String, onSuccess: @escaping ([Hero]) -> (), onError: @escaping (HeroeError)->() = {_ in } )
    {
        var marvelComponents = MarvelURLComponents()
        
        marvelComponents
            .AddToPath(.Comics)
            .AddOffset(offset: offset)
            .AddLimit(limit: limit)
            .AddComicCharacter(character: heroName)
        
        
        MarvelRepository.GetApiData(urlComponent: marvelComponents, onSuccess: onSuccess, onError: onError)
        
    }
    
}
