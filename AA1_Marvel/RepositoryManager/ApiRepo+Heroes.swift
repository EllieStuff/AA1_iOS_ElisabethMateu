//
//  ApiRepo+Heroes.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 28/4/23.
//

import Foundation

extension ApiRepository {
    
    public struct HeroError: Error {
        public enum HeroErrors: String {
            case CantCreateUrlWithString = "Can't create url with string"
            case CantCreateUrl = "Can't create url"
            case Unknown = "Unknown Error"
        }
        
        let error: HeroErrors
    }
    
    static func GetHeroes(offset: Int = 0, limit: Int = 20, filter: String = "", onSuccess: @escaping ([Hero]) -> (), onError: @escaping (HeroError)->() = {_ in } )
    {
        guard var urlComponents = BaseComponents else {
            onError(HeroError(error: .CantCreateUrlWithString))
            return
        }
        
        urlComponents.queryItems?.append(URLQueryItem(name: "offset", value: String(offset)))
        urlComponents.queryItems?.append(URLQueryItem(name: "limit", value: String(limit)))
        
        guard let url = urlComponents.url else {
            onError(HeroError(error: .CantCreateUrl))
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("d39e81e4c5b9c338766dcf605bfe6501", forHTTPHeaderField: "apikey")
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    onError(HeroError(error: .Unknown))
                }
                return
            }
            
            if let data = data {
                
                guard let heroesResponse = try? JSONDecoder().decode(HeroesResponse.self, from: data) else { return }
                
                DispatchQueue.main.async {
                    onSuccess(heroesResponse.data.results)
                }
            
            }
        }
            
        task.resume()
    }
    
    static func GetComics(heroreName: String, limit: Int = 20, onSuccess: @escaping ([Hero]) -> (), onError: @escaping (HeroError)->() = {_ in } )
    {
        guard var urlComponents = BaseComponents else {
            onError(HeroError(error: .CantCreateUrlWithString))
            return
        }
        
        urlComponents.queryItems?.append(URLQueryItem(name: "characters", value: heroreName))
        urlComponents.queryItems?.append(URLQueryItem(name: "limit", value: String(limit)))
        
        guard let url = urlComponents.url else {
            onError(HeroError(error: .CantCreateUrl))
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("d39e81e4c5b9c338766dcf605bfe6501", forHTTPHeaderField: "apikey")
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    onError(HeroError(error: .Unknown))
                }
                return
            }
            
            if let data = data {
                
                guard let heroesResponse = try? JSONDecoder().decode(HeroesResponse.self, from: data) else { return }
                debugPrint(heroesResponse)
                
                DispatchQueue.main.async {
                    onSuccess(heroesResponse.data.results)
                }
            
            }
        }
            
        task.resume()
    }
    
}
