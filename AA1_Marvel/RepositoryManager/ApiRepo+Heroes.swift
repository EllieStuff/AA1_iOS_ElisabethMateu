//
//  ApiRepo+Heroes.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 28/4/23.
//

import Foundation

extension MarvelRepository {
    
    public struct HeroError: Error {
        public enum HeroErrors: String {
            case CantCreateUrlWithString = "Can't create url with string"
            case CantCreateUrl = "Can't create url"
            case Unknown = "Unknown Error"
            case CantParseData = "Can't Parse Data"
        }
        
        let error: HeroErrors
    }
    
    func GetHeroes(offset: Int = 0, limit: Int = 20, filter: String = "", onSuccess: @escaping (HeroesResponse) -> (), onError: @escaping (HeroError)->() = {_ in } )
    {
        let marvelComponents = MarvelURLComponents()
        
        marvelComponents
            .AddToPath(.Characters)
            .AddOffset(offset: offset)
            .AddLimit(limit: limit)
        if(filter != "") { marvelComponents.AddFilter(filter: filter) }
        
        MarvelRepository.GetApiData(urlComponent: marvelComponents, onSuccess: onSuccess, onError: onError)
        
    }
    
}


struct HeroesResponse: Decodable, Encodable {
    let code: Int
    let status: String
    let data: HeroesData
}

struct HeroesData: Decodable, Encodable {
    let results: [Hero]
    let total: Int
}

struct Hero: Decodable, Encodable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: MarvelRepository.Thumbnail?
}

