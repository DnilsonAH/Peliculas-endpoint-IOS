import SwiftUI

class ViewModelPeliculas: ObservableObject {
    @Published var peliculas: [ModeloPeliculas] = []
    @Published var searchText: String = ""

    var filteredPeliculas: [ModeloPeliculas] {
        if searchText.isEmpty {
            return peliculas
        } else {
            return peliculas.filter { $0.nombre.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func listarPeliculas() {
        guard let url = URL(string: "http://localhost:3000/peliculas") else { return }

        let tarea = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let peliculasJSON = try JSONDecoder().decode([ModeloPeliculas].self, from: data)
                DispatchQueue.main.async {
                    self?.peliculas = peliculasJSON
                }
            } catch {
                print(error)
            }
        }
        tarea.resume()
    }

    func agregarPelicula(nombre: String, categoria: String, duracion: Int, imagen: String) {
        guard let url = URL(string: "http://localhost:3000/peliculas") else { return }
        let nuevaPelicula = ModeloPeliculas(id: 0, nombre: nombre, categoria: categoria, duracion: duracion, imagen: imagen)

        guard let jsonData = try? JSONEncoder().encode(nuevaPelicula) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let tarea = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error en la solicitud: \(error)")
                return
            }

            guard let data = data else { return }

            do {
                let peliculaAgregada = try JSONDecoder().decode(ModeloPeliculas.self, from: data)
                DispatchQueue.main.async {
                    self?.peliculas.append(peliculaAgregada)
                }
            } catch {
                print("Error al decodificar respuesta: \(error)")
            }
        }
        tarea.resume()
    }

    func actualizarPelicula(pelicula: ModeloPeliculas) {
        guard let url = URL(string: "http://localhost:3000/peliculas/\(pelicula.id)") else { return }

        guard let jsonData = try? JSONEncoder().encode(pelicula) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let tarea = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error al actualizar película: \(error)")
                return
            }

            guard let data = data else { return }

            // Optionally, decode the updated movie and refresh the list
            do {
                let updatedPelicula = try JSONDecoder().decode(ModeloPeliculas.self, from: data)
                DispatchQueue.main.async {
                    if let index = self?.peliculas.firstIndex(where: { $0.id == updatedPelicula.id }) {
                        self?.peliculas[index] = updatedPelicula
                    }
                }
            } catch {
                print("Error al decodificar respuesta de actualización: \(error)")
            }
        }
        tarea.resume()
    }

    func eliminarPelicula(id: Int) {
        guard let url = URL(string: "http://localhost:3000/peliculas/\(id)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let tarea = URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            if let error = error {
                print("Error al eliminar película: \(error)")
                return
            }

            DispatchQueue.main.async {
                self?.peliculas.removeAll { $0.id == id }
            }
        }
        tarea.resume()
    }
}
