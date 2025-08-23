//
//  DownloadedAnimesFileNames.swift
//  AniCue
//
//  Created by Jorge Ramos on 23/08/25.
//
import Foundation

struct DownloadedAnimesFileNames {
    static let initialFileNames = ["top_1-400_anime", "top_401-800_anime", "top_801-1200_anime"]
    static let fileNames: [String] = {
        var names: [String] = []
        for i in stride(from: 1201, to: 12001, by: 400) {
            let start = i
            let end = i + 399
            names.append("top_\(start)-\(end)_anime")
        }
        return names
    }()
}
