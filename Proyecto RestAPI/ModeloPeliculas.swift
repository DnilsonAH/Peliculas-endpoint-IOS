//
//  ModeloPeliculas.swift
//  Proyecto RestAPI
//
//  Created by MAC14 on 9/06/25.
//

import SwiftUI

struct ModeloPeliculas: Hashable, Codable {
    let id: Int
    let nombre: String
    let categoria: String
    let duracion: Int
    let imagen: String
}
