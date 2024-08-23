//
//  AvatarPreview.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/08/2024.
//

import Foundation


class AvatarPreview {
//    Get all avatar in assets
    
    static let instance = AvatarPreview()
    private init() {}

        let games: [GameAvatar] = [
            GameAvatar(id: 0, name: "Marvel's Spider" , imageName: "Spiderman1"),
            GameAvatar(id: 1, name: "Marvel's Spider" , imageName: "Spiderman2"),
            GameAvatar(id: 2, name: "Marvel's Spider" , imageName: "Spiderman3"),
            GameAvatar(id: 3, name: "Marvel's Spider" , imageName: "Spiderman4"),
            GameAvatar(id: 4, name: "Hogwarts Legacy" , imageName: "Hogwarts1"),
            GameAvatar(id: 5, name: "Hogwarts Legacy" , imageName: "Hogwarts2"),
            GameAvatar(id: 6, name: "Hogwarts Legacy" , imageName: "Hogwarts3"),
            GameAvatar(id: 7, name: "Hogwarts Legacy" , imageName: "Hogwarts4"),
            GameAvatar(id: 8, name: "God of War: Ragnarök" , imageName: "Ragnarok1"),
            GameAvatar(id: 9, name: "God of War: Ragnarök" , imageName: "Ragnarok2"),
            GameAvatar(id: 10, name: "God of War: Ragnarök" , imageName: "Ragnarok3"),
            GameAvatar(id: 11, name: "God of War: Ragnarök" , imageName: "Ragnarok4"),
            GameAvatar(id: 12, name: "Diablo IV" , imageName: "Diablo1"),
            GameAvatar(id: 13, name: "Diablo IV" , imageName: "Diablo2"),
            GameAvatar(id: 14, name: "Diablo IV" , imageName: "Diablo3"),
            GameAvatar(id: 15, name: "Diablo IV" , imageName: "Diablo4"),
            GameAvatar(id: 16, name: "Final Fantasy XVI" , imageName: "Fantasy1"),
            GameAvatar(id: 17, name: "Final Fantasy XVI" , imageName: "Fantasy2"),
            GameAvatar(id: 18, name: "Final Fantasy XVI" , imageName: "Fantasy3"),
            GameAvatar(id: 19, name: "Final Fantasy XVI" , imageName: "Fantasy4"),
            GameAvatar(id: 20, name: "Star Wars Jedi: Survivor" , imageName: "StarWars1"),
            GameAvatar(id: 21, name: "Star Wars Jedi: Survivor" , imageName: "StarWars2"),
            GameAvatar(id: 22, name: "Star Wars Jedi: Survivor" , imageName: "StarWars3"),
            GameAvatar(id: 23, name: "Star Wars Jedi: Survivor" , imageName: "StarWars4")
        ]
}


struct GamesAvatarModel {
    var games: [GameAvatar]
}

struct GameAvatar: Equatable {
    var id: Int
    var name: String
    var imageName: String
}
