@testable import ProductsList

final class MockPlistReader: PlistReaderProtocol {
    
    var capturedFile: String?
    var capturedType: Any.Type?
    var readCallCount = 0
    
    var error: PlistReaderError?
    var mockData: Any?
    
    func read<T>(file: String, as type: T.Type) throws -> T where T : Decodable {
        capturedFile = file
        capturedType = type
        readCallCount += 1
        
        if let error {
            throw error
        }
        
        guard let data = mockData as? T else {
            throw PlistReaderError.decodingFailed
        }
        
        return data
    }
}
