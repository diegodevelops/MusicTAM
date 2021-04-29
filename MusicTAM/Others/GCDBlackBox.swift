//
//  GCDBlackBox.swift
//  MusicTAM
//
//  Created by Diego A. Perez Pares on 4/29/21.
//

// This is for concurrency

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

func performBackgroundTask(_ updates: @escaping () -> Void) {
    DispatchQueue.global(qos: .background).async {
        updates()
    }
}
