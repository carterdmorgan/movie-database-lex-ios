//
//  LexService.swift
//  movie-database-lex-ios
//
//  Created by Morgan, Carter on 2/24/18.
//  Copyright © 2018 Carter Morgan Personal. All rights reserved.
//

import Foundation

class LexService{
    let baseUrl = "http://54.90.10.159:8080/lexresponse?phrase=" // Online VM
//    let baseUrl = "http://192.168.0.5:8080/lexresponse?phrase=" // Mac IP Address
    
    func generateRequest(phrase: String) -> URLRequest{
        let test = baseUrl + phrase.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        print(test)
        let url = URL(string: test)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        return request
    }
    
    func sendRequestToLexService(request: URLRequest, completion: @escaping (String) -> ()){
        // Get JSON
        let getTask = URLSession.shared.dataTask(with: request){
            data,response,error in
            do{
                if let data = data{
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary{
                        print("Results: \(jsonResult)")
                        
                        if let text = jsonResult["content"] as? String{
                            return completion(text)
                        }else{
                            return completion("Something went wrong on our end.  Please try again later.")
                        }
                    }else{
                        return completion("Something went wrong on our end.  Please try again later.")
                    }
                }else{
                    return completion("Something went wrong on our end.  Please try again later.")
                }
            }catch let error as NSError{
                print("Error: \(error.localizedDescription)")
            }
            
        }
        getTask.resume()
    }
}
