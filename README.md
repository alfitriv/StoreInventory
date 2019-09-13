# StoreInventory
An Object Oriented Programming exercise that covers a number of principles in OO design in the simulation of a store inventory.

# How-to:
- Create an empty store:
```
var myStore = Store(stockInventory: [], shoppingCart: ShoppingCart(items: [], totalPrice: 0))
```
- Create an item:
```
var item1 = Item(name: "Pencil", quantityStock: 4, availability: 4, price: 10000, category: .SchoolSupplies)
```
- Add an item to store:
```
myStore.addItemsToCart(item: item1, amount:1)
```
