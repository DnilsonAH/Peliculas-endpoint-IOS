//
//  VistaEditarPelicula.swift
//  Proyecto RestAPI
//
//  Created by MAC14 on 9/06/25.
//

import SwiftUI

struct VistaEditarPelicula: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var peliculasVM: ViewModelPeliculas
    @State var pelicula: ModeloPeliculas

    @State private var nombre: String
    @State private var categoria: String
    @State private var duracion: String
    @State private var imagen: String
    let categorias = ["Otro", "Anime", "Comedia", "Drama"]

    init(peliculasVM: ViewModelPeliculas, pelicula: ModeloPeliculas) {
        self.peliculasVM = peliculasVM
        self._pelicula = State(initialValue: pelicula)
        self._nombre = State(initialValue: pelicula.nombre)
        self._categoria = State(initialValue: pelicula.categoria)
        self._duracion = State(initialValue: String(pelicula.duracion))
        self._imagen = State(initialValue: pelicula.imagen)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información General")) {
                    TextField("Nombre", text: $nombre)
                    Picker("Categoría", selection: $categoria) {
                        ForEach(categorias, id: \.self) { category in
                            Text(category)
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
                    Button("Guardar Cambios") {
                        guard let duracionInt = Int(duracion), !nombre.isEmpty, !imagen.isEmpty else {
                            print("Datos inválidos")
                            return
                        }
                        let updatedPelicula = ModeloPeliculas(id: pelicula.id, nombre: nombre, categoria: categoria, duracion: duracionInt, imagen: imagen)
                        peliculasVM.actualizarPelicula(pelicula: updatedPelicula)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Editar Película")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

