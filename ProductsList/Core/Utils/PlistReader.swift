import Foundation

final class PlistReader {
    
    enum Error: Swift.Error {
        case fileNotFound
    }
    
    private let bundle: Bundle
    private let decoder: PropertyListDecoder
    
    init(bundle: Bundle = .main, decoder: PropertyListDecoder = PropertyListDecoder()) {
        self.bundle = bundle
        self.decoder = decoder
    }
    
    func read<T: Decodable>(file: String) throws -> [T] {
        guard let url = bundle.url(forResource: file, withExtension: "plist") else {
            throw Error.fileNotFound
        }
        guard let data = try? Data(contentsOf: url),
              let decodedData = try? decoder.decode([T].self, from: data)
        else {
            return []
        }
        return decodedData
    }
}
