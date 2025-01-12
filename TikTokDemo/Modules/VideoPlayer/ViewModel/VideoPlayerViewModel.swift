//
//  VideoPlayerViewModel.swift
//  TikTokDemo
//
//  Created by Bishal Ram on 15/12/24.
//

import Foundation
import Stevia
import RxRelay

protocol VideoPlayerViewModelProtocol {
    var videoDataSource: BehaviorRelay<[Video]> { get set }
    var comments: BehaviorRelay<[Comment]> { get set }
    func loadVideosAndComments()
}

class VideoPlayerViewModel: VideoPlayerViewModelProtocol {
    // MARK: Properties
    var videoDataSource = RxRelay.BehaviorRelay<[Video]>(value: [])
    var comments = RxRelay.BehaviorRelay<[Comment]>(value: [])
    
    // MARK: Methods
    func loadVideosAndComments() {
        if let url = Bundle.main.url(forResource: "Videos", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(VideoPlayerModel.self, from: data)
                    videoDataSource.accept(response.videos)
                } catch (let error) {
                    
                }
            }
        }
        
        if let url = Bundle.main.url(forResource: "Comments", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(Comments.self, from: data)
                    comments.accept(response.comments)
                } catch (let error) {
                    
                }
            }
        }
    }
}
