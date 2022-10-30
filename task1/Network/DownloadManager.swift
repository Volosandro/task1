//
//  DownloadManager.swift
//  task1
//
//  Created by Volosandro on 30.10.2022.
//

import Foundation

final class DownloadManager {

    // MARK: - Variables And Properties
    var activeDownload: Download? = nil
    var downloadsSession: URLSession!
  
    // MARK: - Methods
    func cancelDownload()
    {
        guard let download = activeDownload else {
            return
        }
      
        download.task?.cancel()
        self.activeDownload = nil
    }
  
    func pauseDownload()
    {
        guard
            let download = self.activeDownload,
            download.isDownloading
        else
        {
            return
        }
    
        download.task?.cancel(byProducingResumeData: { data in
            download.resumeData = data
        })

        download.isDownloading = false
    }
  
    func resumeDownload()
    {
        guard let download = activeDownload else {
            return
        }
    
        if let resumeData = download.resumeData {
            download.task = downloadsSession.downloadTask(withResumeData: resumeData)
        }
        else
        {
            download.task = downloadsSession.downloadTask(with: download.url)
        }
    
        download.task?.resume()
        download.isDownloading = true
    }
  
    func startDownload(url: URL)
    {
        let download = Download(url: url)
        download.task = downloadsSession.downloadTask(with: url)
        download.task?.resume()
        download.isDownloading = true
        self.activeDownload = download
    }
}
