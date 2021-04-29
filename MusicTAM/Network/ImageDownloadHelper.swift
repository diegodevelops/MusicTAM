//
//  ImageDownloadHelper.swift
//  MusicTAM
//
//  Created by Diego A. Perez Pares on 4/29/21.
//


import UIKit

class ImageDownloadHelper {
        
    func loadMedia(urlString: String, timestampString: String, completion: @escaping (_ image: UIImage?) -> Void) {
        var dataIsTheSame = false
        if let dataTimestampFromCache = dataTimestampCache.object(forKey:  urlString as NSString) {
            let s = dataTimestampFromCache as String
            dataIsTheSame = s == timestampString
        }
        if let dataFromCache = dataCache.object(forKey: urlString as NSString) {
            if dataIsTheSame {
                completion(UIImage(data: dataFromCache as Data))
                return
            }
        }
        if let url = URL(string: urlString) {
            performBackgroundTask {
                let dataTask = URLSession.shared.dataTask(with: url) {
                    (data,urlResponse,error) in
                    if error == nil, data != nil {
                        dataCache.setObject(data! as NSData, forKey: urlString as NSString)
                        dataTimestampCache.setObject(timestampString as NSString, forKey: urlString as NSString)
                        completion(UIImage(data: data! as Data))
                    }
                }
                dataTask.resume()
            }
        }
    }
    
}

