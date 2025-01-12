//
//  VideoPlayerModel.swift
//  TikTokDemo
//
//  Created by Bishal Ram on 15/12/24.
//

import Foundation

struct VideoPlayerModel: Codable {
    let videos: [Video]
}

struct Video: Codable {
    let id: Int
    let userID: Int
    let username: String
    let profilePicURL: String
    let description: String
    let topic: String
    let viewers: Int
    let likes: Int
    let video: String
    let thumbnail: String
}
