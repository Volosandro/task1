//
//  Download.swift
//  task1
//
//  Created by Volosandro on 30.10.2022.
//

import Foundation

final class Download
{
    // MARK: - Variables
    var isDownloading = false
    var progress: Float = 0
    var resumeData: Data?
    var task: URLSessionDownloadTask?
    var url: URL
  
    // MARK: - Initialization
    init(url: URL)
    {
        self.url = url
    }
}
