//
//  VistaAgregarPelicula.swift
//  Proyecto RestAPI
//
//  Created by MAC14 on 9/06/25.
//

import SwiftUI

struct VistaAgregarPelicula: View {
    @State private var nombre: String = ""
    @State private var categoria: String = "Otro"
    @State private var duracion: String = ""
    @State private var imagen: String = ""
    let categorias = ["Otro", "Anime", "Comedia", "Drama"]
    @Environment(\.presentationMode) var presentationMode
    @StateObject var peliculasVM = ViewModelPeliculas()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información General")) {
                    TextField("Nombre", text: $nombre)
                    Picker("Categoría", selection: $categoria) {
                        ForEach(categorias, id: \.self) { categoria in
                            Text(categoria)
                        }
                    }
                    TextField("Duración en minutos", text: $duracion)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Imagen")) {
                    TextField("URL de la Imagen", text: $imagen)
                        .keyboardType(.URL)
                    if let url = URL(string: imagen), !imagen.isEmpty {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Text("Ingrese una URL válida")
                            .foregroundColor(.gray)
                    }
                }

                Section {
                    Button("Guardar") {
                        guard let duracionInt = Int(duracion), !nombre.isEmpty,
                              !imagen.isEmpty else {
                            print("Datos inválidos")
                            return
                        }
                        peliculasVM.agregarPelicula(nombre: nombre, categoria: categoria, duracion: duracionInt, imagen: imagen)
                        
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Agregar Pelicula")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct VistaAgregarPelicula_Previews: PreviewProvider {
    static var previews: some View {
        VistaAgregarPelicula()
    }
}
