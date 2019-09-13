import UIKit

struct Item {
    var name: String
    var quantityStock: Int
    var availability: Int
    var price: Int
    var category: Categories
}

struct ShoppingCart {
    var items: [Item]
    var totalPrice: Int
}

struct Order {
    var orderId: String
    var datePurchased: Date
    var items: [Item]
}

enum Categories: String {
    case HomeFurnishing
    case BeautyCosmetics
    case SchoolSupplies
}


protocol InventoryLog {
    func printListOfItemsGivenCategory(category: Categories)
    func addItemStockToInventory(item: Item)
}

protocol ShoppingLog {
    func addItemsToCart(item: Item, amount: Int)
    func printShoppingCartItems()
    func checkout()
}

class Store: InventoryLog, ShoppingLog, CustomStringConvertible {
    
    var stockInventory: [Item] = []
    var shoppingCart: ShoppingCart
    
    init(stockInventory: [Item], shoppingCart: ShoppingCart) {
        self.stockInventory = stockInventory
        self.shoppingCart = shoppingCart
    }
    
    var description: String {
        var description = ""
        description += "stock: \(self.stockInventory)\n"
        return description
    }
    
    func printListOfItemsGivenCategory(category: Categories) {
        
        let filteredItem = self.stockInventory.filter {$0.category == category}
        
        //Setup the data
        let data: [(category: Categories, item: String)] = filteredItem.map {
            ($0.category, $0.name)
        }
        //Header column length
        let categoryWidth = 20
        let itemWidth = 20
        
        //Define header
        let headerString = "Category".padding(toLength: categoryWidth, withPad: " ", startingAt: 0) + "Item(s)".padding(toLength: itemWidth, withPad: " ", startingAt: 0)
        
        //Line separator
        let lineString = "".padding(toLength: headerString.count, withPad: "-", startingAt: 0)
        
        print("\(headerString)\n\(lineString)")
        
        data.forEach {
            print($0.category.rawValue + "".padding(toLength: (categoryWidth - $0.category.rawValue.count), withPad: " ", startingAt: 0) +
                $0.item + "".padding(toLength: (itemWidth - $0.item.count), withPad: " ", startingAt: 0))
        }
        
    }
    
    func addItemStockToInventory(item: Item) {
        guard item.name != "" else{
            return
        }
        stockInventory.append(item)
        
    }
    
    func addItemsToCart(item: Item, amount: Int) {
        //check if the item from stock is available
        let availableStocks = stockInventory.map { $0.name == item.name && $0.availability >= amount }
        
        for stock in availableStocks {
            if stock == true {
                shoppingCart.items.append(Item(name: item.name, quantityStock: amount, availability: (item.availability - amount), price: (item.price)*amount, category: item.category))
                
                stockInventory.removeAll { (itemBought) -> Bool in
                    itemBought.name == item.name
                }
                
                stockInventory.append(Item(name: item.name, quantityStock: (item.quantityStock - amount), availability: (item.availability - amount), price: item.price, category: item.category))
            }
        }

    }
    
    func printShoppingCartItems() {
        let data = self.shoppingCart.items
        
        let shoppingList: [(item: String, price: Int)] = data.map{
            ($0.name, $0.price)
        }
        
        let itemWidth = 20
        
        //Define header
        let headerString = "Shopping Cart".padding(toLength: itemWidth, withPad: " ", startingAt: 0)
        
        //Line separator
        let lineString = "".padding(toLength: headerString.count, withPad: "-", startingAt: 0)
        
        print("\(headerString)\n\(lineString)")
        
        shoppingList.forEach {
            print($0.item + "".padding(toLength: (itemWidth - $0.item.count), withPad: " ", startingAt: 0) + String($0.price))
        }

    }
    
    func randomString(length: Int) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func checkout() {
        guard shoppingCart.items.count > 0 else {
            print("No items in shopping cart")
            return
        }
        
        let order = Order(orderId: randomString(length: 5), datePurchased: Date(), items: self.shoppingCart.items)
        print(order)
        
        self.shoppingCart.items.removeAll()
    }
    
}

extension String {
    init?<T : CustomStringConvertible>(_ value : T?) {
        guard let value = value else { return nil }
        self.init(describing: value)
    }
}

/* Uncomment to utilize the predifined items and store
var item1 = Item(name: "Pencil", quantityStock: 4, availability: 4, price: 10000, category: .SchoolSupplies)

var item2 = Item(name: "Lipstick", quantityStock: 3, availability: 3, price: 12000, category: .BeautyCosmetics)

var item3 = Item(name: "", quantityStock: 0, availability: 0, price: 0, category: .BeautyCosmetics)

var item4 = Item(name: "Brush", quantityStock: 1, availability: 1, price: 10000, category: .BeautyCosmetics)

var myStore = Store(stockInventory: [], shoppingCart: ShoppingCart(items: [], totalPrice: 0))

print(myStore)
 */
