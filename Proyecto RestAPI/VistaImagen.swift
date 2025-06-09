//
//  VistaImagen.swift
//  Proyecto RestAPI
//
//  Created by MAC14 on 9/06/25.
//

import SwiftUI

struct VistaImagen: View {
    let urlImagen: String
    @State private var dato: Data?

    private func conseguirDato() {
        guard let url = URL(string: urlImagen) else { return }
        let tarea = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.dato = data
        }
        tarea.resume()
    }

    var body: some View {
        if let data = dato, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 130, height: 70)
                .background(Color.gray)
        } else {
            Image(systemName: "video")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 130, height: 70)
                .background(Color.gray)
                .onAppear {
                    conseguirDato()
                }
        }
    }
}

struct VistaImagen_Previews: PreviewProvider {
    static var previews: some View {
        VistaImagen(urlImagen: "")
    }
}
