import Foundation

enum Strings {
    
    // MARK: - Splash
    
    enum Splash {
        static var title: String {
            NSLocalizedString("splash.title", comment: "")
        }
    }
    
    // MARK: - Products
    
    enum Products {
        enum Summaries {
            static var title: String {
                NSLocalizedString("products.summaries.title", comment: "")
            }
            
            static func transactions(_ count: Int) -> String {
                String(
                    format: NSLocalizedString("products.summaries.transactions", comment: ""),
                    count
                )
            }
        }
        
        enum Transactions {
            static func title(for id: String) -> String {
                String(
                    format: NSLocalizedString("products.transactions.title", comment: ""),
                    id
                )
            }
            
            static func total(_ amount: String) -> String {
                String(
                    format: NSLocalizedString("products.transactions.total", comment: ""),
                    amount
                )
            }
        }
    }
}

