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
    
    func GetHeroes(offset: Int = 0, limit: Int = 20, filter: String = "", onSuccess: @escaping ([Hero]) -> (), onError: @escaping (HeroError)->() = {_ in } )
    {
        var marvelComponents = MarvelURLComponents()
        
        marvelComponents
            .AddToPath(.Characters)
            .AddOffset(offset: offset)
            .AddLimit(limit: limit)
        if(filter != "") { marvelComponents.AddFilter(filter: filter) }
        
        
        //MarvelRepository.GetApiData<Hero>(urlComponent: marvelComponents, onSuccess: onSuccess, onError: onError)
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
                debugPrint("Heroes Response:")
                //debugPrint(jsonStr)
                
                var jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                debugPrint(jsonDict)
                
                guard let heroesResponse = try? JSONDecoder().decode(HeroesResponse.self, from: data) else {
                    DispatchQueue.main.async {
                        onError(HeroError(error: .CantParseData))
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    //debugPrint("Heroes Response:")
                    //debugPrint(heroesResponse.data.results)
                    onSuccess(heroesResponse.data.results)
                }
            
            }
        }
            
        task.resume()
        
    }
    
}


struct HeroesResponse: Decodable, Encodable {
    let code: Int
    let status: String
    let data: HeroesData
}

struct HeroesData: Decodable, Encodable {
    let results: [Hero]
}

struct Hero: Decodable, Encodable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail?
}

struct Thumbnail : Codable {
    let path: String
    let `extension`: String
    
    var ImageUrl: String { get { return "\(path).\(`extension`)" } }
    var Url: URL? { get { return URL(string: ImageUrl) } }
}


