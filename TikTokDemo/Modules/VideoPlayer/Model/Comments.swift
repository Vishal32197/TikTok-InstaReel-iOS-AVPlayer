//
//  Comments.swift
//  TikTokDemo
//
//  Created by Bishal Ram on 15/12/24.
//

struct Comments: Codable {
    var comments: [Comment]
}

struct Comment: Codable {
    let id: Int
    let username: String
    let picURL: String
    let comment: String
}
