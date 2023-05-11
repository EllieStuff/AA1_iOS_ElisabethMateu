//
//  ApiRepo+Comics.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 5/5/23.
//

import Foundation

extension MarvelRepository {
    
    func GetComics(offset: Int = 0, limit: Int = 20, characterId: Int, onSuccess: @escaping ([HeroesContent]) -> (), onError: @escaping (HeroError)->() = {_ in } )
    {
        debugPrint("Character Id: " + String(characterId))
        var marvelComponents = MarvelURLComponents()
        
        marvelComponents
            .AddToPath(.Comics)
            .AddOffset(offset: offset)
            .AddLimit(limit: limit)
            .AddCharacterId(characterId: characterId)
        
        
        //MarvelRepository.GetApiData(urlComponent: marvelComponents, onSuccess: onSuccess, onError: onError)
        guard let url = marvelComponents.Components.url else {
            onError(HeroError(error: .CantCreateUrl))
            return
        }
        
        var request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                DispatchQueue.main.async {
                    onError(HeroError(error: .Unknown))
                }
                return
            }
            
            if let data = data , let jsonStr = String(data:data, encoding: .utf8){
                debugPrint("Comics Response:")
                //debugPrint(jsonStr)
                
                var jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                debugPrint(jsonDict)
                
                guard let comicsResponse = try? JSONDecoder().decode(HeroesContentResponse.self, from: data) else {
                    DispatchQueue.main.async {
                        onError(HeroError(error: .CantParseData))
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    //debugPrint("Heroes Response:")
                    //debugPrint(heroesResponse.data.results)
                    onSuccess(comicsResponse.data.results)
                }
            
            }
        }
            
        task.resume()
        
    }
    
}
