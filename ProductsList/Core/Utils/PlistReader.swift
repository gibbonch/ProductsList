import Foundation

protocol PlistReaderProtocol {
    func read<T: Decodable>(file: String, as type: T.Type) throws -> T
}

final class PlistReader: PlistReaderProtocol {
    
    func read<T: Decodable>(file: String, as type: T.Type) throws -> T {
        guard let url = Bundle.main.url(forResource: file, withExtension: "plist") else {
            throw PlistReaderError.fileNotFound
        }
        guard let data = try? Data(contentsOf: url),
              let decodedData = try? PropertyListDecoder().decode(T.self, from: data)
        else {
            throw PlistReaderError.decodingFailed
        }
        return decodedData
    }
}

enum PlistReaderError: Error {
    case fileNotFound
    case decodingFailed
}
