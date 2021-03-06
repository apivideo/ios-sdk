//
//  Pagination.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 27/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public class Pagination{
    private var tokenType: String!
    private var key: String!
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    public init(tokenType: String, key: String){
        self.tokenType = tokenType
        self.key = key
    }
    
    public func getNbOfItems(apiPath: String, completion: @escaping (Int, Response?) ->()){
        var nbOfItems = 0
        let request = RequestsBuilder().getUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
        
        let group = DispatchGroup()
        group.enter()
        
        let session = RequestsBuilder().urlSessionBuilder()
        TasksExecutor().execute(session: session, request: request, group: group){(data, response) in
            if(data != nil){
                let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
                let pagination = json!["pagination"] as! Dictionary<String, AnyObject>
                let itemsTotal = pagination["pagesTotal"]
                nbOfItems = itemsTotal as! Int
                completion(nbOfItems, nil)
            }else{
                completion(nbOfItems, response)
            }
        }
        group.wait()
    }
}
