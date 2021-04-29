//
//  Cache.swift
//  MusicTAM
//
//  Created by Diego A. Perez Pares on 4/29/21.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()
let imageTimestampCache = NSCache<NSString, NSString>()

let dataCache = NSCache<NSString, NSData>()
let dataTimestampCache = NSCache<NSString, NSString>()
