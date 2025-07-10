class_name ShoppingCartSteps

var steps: Dictionary = {
    # Background steps
    "the store has the following items:":
    func (t: GogotteTest) -> void:
        # Initialize the store inventory from the datatable
        t.ctx['inventory'] = {}
        # Skip the header row (index 0)
        for i in range(1, t.datatable.size()):
            var row: Array = t.datatable[i]
            var item_name: String = row[0]
            var item_price: float = float(row[1])
            var item_stock: int = int(row[2])
            t.ctx['inventory'][item_name] = {
                "price": item_price,
                "stock": item_stock
            }
        t.assert_true(t.ctx['inventory'].size() > 0, "Store inventory should not be empty"),

    "I have an empty shopping cart":
    func (t: GogotteTest) -> void:
        t.ctx['cart'] = {}
        t.ctx['cart_total'] = 0.0
        t.ctx['error'] = null,

    # Given steps
    "{item} has {count} items in stock":
    func (t: GogotteTest, item: String, count: String) -> void:
        var item_name: String = item.replace("\"", "")
        t.assert_true(t.ctx['inventory'].has(item_name), "Item should exist in inventory")
        t.ctx['inventory'][item_name]["stock"] = int(count),

    # When steps
    "I add {count} {item} to my cart":
    func (t: GogotteTest, count: String, item: String) -> void:
        var item_name: String = item.replace("\"", "")
        var quantity: int = int(count)

        t.assert_true(t.ctx['inventory'].has(item_name), "Item should exist in inventory")
        t.assert_true(t.ctx['inventory'][item_name]["stock"] >= quantity, "Not enough stock")

        # Update inventory
        t.ctx['inventory'][item_name]["stock"] -= quantity

        # Update cart
        if t.ctx['cart'].has(item_name):
            t.ctx['cart'][item_name] += quantity
        else:
            t.ctx['cart'][item_name] = quantity

        # Update cart total
        t.ctx['cart_total'] += t.ctx['inventory'][item_name]["price"] * quantity,

    "I remove {count} {item} from my cart":
    func (t: GogotteTest, count: String, item: String) -> void:
        var item_name: String = item.replace("\"", "")
        var quantity: int = int(count)

        t.assert_true(t.ctx['cart'].has(item_name), "Item should exist in cart")
        t.assert_true(t.ctx['cart'][item_name] >= quantity, "Not enough items in cart to remove")

        # Update inventory
        t.ctx['inventory'][item_name]["stock"] += quantity

        # Update cart
        t.ctx['cart'][item_name] -= quantity
        if t.ctx['cart'][item_name] == 0:
            t.ctx['cart'].erase(item_name)

        # Update cart total
        t.ctx['cart_total'] -= t.ctx['inventory'][item_name]["price"] * quantity,

    "I try to add {count} {item} to my cart":
    func (t: GogotteTest, count: String, item: String) -> void:
        var item_name: String = item.replace("\"", "")
        var quantity: int = int(count)

        t.assert_true(t.ctx['inventory'].has(item_name), "Item should exist in inventory")

        # Check if enough stock
        if t.ctx['inventory'][item_name]["stock"] < quantity:
            t.ctx['error'] = "Out of stock"
        else:
            # If enough stock, add to cart
            t.ctx['inventory'][item_name]["stock"] -= quantity

            if t.ctx['cart'].has(item_name):
                t.ctx['cart'][item_name] += quantity
            else:
                t.ctx['cart'][item_name] = quantity

            t.ctx['cart_total'] += t.ctx['inventory'][item_name]["price"] * quantity,

    "I import my wishlist with the following items:":
    func (t: GogotteTest) -> void:
        # Parse the JSON from the docstring
        var json: Array = JSON.parse_string(t.docstring)
        t.assert_not_null(json, "JSON should be valid")

        # Add each item to the cart
        for item: Dictionary in json:
            var item_name: String = item["name"]
            var quantity: int = item["quantity"]

            t.assert_true(t.ctx['inventory'].has(item_name), "Item should exist in inventory")
            t.assert_true(t.ctx['inventory'][item_name]["stock"] >= quantity, "Not enough stock for " + item_name)

            # Update inventory
            t.ctx['inventory'][item_name]["stock"] -= quantity

            # Update cart
            if t.ctx['cart'].has(item_name):
                t.ctx['cart'][item_name] += quantity
            else:
                t.ctx['cart'][item_name] = quantity

            # Update cart total
            t.ctx['cart_total'] += t.ctx['inventory'][item_name]["price"] * quantity,

    # Then steps
    "my cart should contain {count} {item}":
    func (t: GogotteTest, count: String, item: String) -> void:
        var item_name: String = item.replace("\"", "")
        var expected_quantity: int = int(count)

        t.assert_true(t.ctx['cart'].has(item_name), "Item should exist in cart")
        t.assert_eq(t.ctx['cart'][item_name], expected_quantity,
            "Cart should contain " + count + " " + item_name),

    "my cart total should be {amount}":
    func (t: GogotteTest, amount: String) -> void:
        var expected_total: float = float(amount)
        t.assert_eq(t.ctx['cart_total'], expected_total,
            "Cart total should be " + amount),

    "I should see an {error} error":
    func (t: GogotteTest, error: String) -> void:
        var error_message: String = error.replace("\"", "")
        t.assert_eq(t.ctx['error'], error_message,
            "Should see a " + error_message + " error"),

    "my cart should be empty":
    func (t: GogotteTest) -> void:
        t.assert_eq(t.ctx['cart'].size(), 0, "Cart should be empty"),
}
