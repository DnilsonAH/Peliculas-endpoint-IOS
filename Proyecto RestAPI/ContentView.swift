//
//  ContentView.swift
//  Proyecto RestAPI
//
//  Created by MAC14 on 9/06/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject var peliculasVM = ViewModelPeliculas()
    @State private var showSearchAlert = false
    @State private var searchInput: String = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(peliculasVM.filteredPeliculas, id: \.self) { pelicula in
                    NavigationLink(destination: VistaEditarPelicula(peliculasVM: peliculasVM, pelicula: pelicula)) {
                        HStack {
                            VistaImagen(urlImagen: pelicula.imagen)
                            VStack(alignment: .leading) {
                                Text(pelicula.nombre)
                                    .bold(true)
                                Text(pelicula.categoria)
                                Text("\(pelicula.duracion) min")
                            }
                        }
                        .padding(5)
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            peliculasVM.eliminarPelicula(id: pelicula.id)
                        } label: {
                            Label("Borrar", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                }
            }
            .navigationBarTitle("Peliculas")
            .onAppear {
                peliculasVM.listarPeliculas()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button {
                            showSearchAlert = true
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                        NavigationLink(destination: VistaAgregarPelicula()) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .alert("Buscar Película", isPresented: $showSearchAlert) {
                TextField("Nombre de la película", text: $peliculasVM.searchText)
                Button("Buscar") { }
                Button("Cancelar", role: .cancel) {
                    peliculasVM.searchText = "" // Clear search on cancel
                }
            } message: {
                Text("Ingrese el nombre de la película a buscar")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
