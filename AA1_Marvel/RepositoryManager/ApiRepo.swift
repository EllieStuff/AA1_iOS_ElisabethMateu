//
//  ApiRepository.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 28/4/23.
//

import Foundation
import CryptoKit

class ApiRepository {
    
    public static let privateKey = "4f3428829d1aa6ed4953af97d38f360b9891c464"
    public static let publicKey = "d39e81e4c5b9c338766dcf605bfe6501"
    
    public static var BaseComponents: URLComponents? {
        get {
            guard var urlComponents = URLComponents(string: "https://gateway.marvel.com:443/v1/public/characters")
            else { return nil }
            
            let ts = String(Date().timeIntervalSince1970)
            let hash = MD5(string: "\(ts)\(privateKey)\(publicKey)")
            
            urlComponents.queryItems = [
                URLQueryItem(name: "apikey", value: publicKey),
                URLQueryItem(name: "ts", value: ts),
                URLQueryItem(name: "hash", value: hash)
            ]
            
            return urlComponents
        }
    }
    
    
    static func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
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

