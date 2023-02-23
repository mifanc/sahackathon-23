import ballerina/io;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/sql;


configurable string host = ?;
configurable string username = ?;
configurable string password = ?;
configurable string database = ?;
configurable int port = ?;

//todo: add to the table creation string. doesn't work yet!
final string USER_TABLE = "users";
final string ITEM_TABLE = "items";
final string ORDER_TABLE = "orders";
final string ORDER_ITEM_TABLE = "order_items";

configurable boolean log = ?;



public type User record {
    int id;
    string name;
    string email;
    string password;
    string phone;
    string address;
    string role;
    string status;
};

public type Item record {
    int id;
    string name;
    string description;
    decimal price;
    string intendedFor;
    string color;
};

public type ItemWithQuantity record {
    int id;
    string name;
    string description;
    decimal price;
    string intendedFor;
    string color;
    int quantity;
};

public type Order record {
    int id;
    string name;
    string address;
    string phone;
    string email;
    string status;
    string paymentMethod;
    string paymentStatus;
    string shippingMethod;
    string shippingStatus;
    string shippingAddress;
    string shippingPhone;
    string shippingEmail;
    string shippingNotes;
    string notes;
    string date;
    string time;
    string userId;
    ItemWithQuantity[] items;
};

public type OrderWithItems record {
    int id;
    string name;
    string address;
    string phone;
    string email;
    string status;
    string paymentMethod;
    string paymentStatus;
    string shippingMethod;
    string shippingStatus;
    string shippingAddress;
    string shippingPhone;
    string shippingEmail;
    string shippingNotes;
    string notes;
    string date;
    string time;
    string userId;
    ItemWithQuantity[] items;
};

public type OrderItem record {
    int id;
    int orderId;
    int itemId;
    int quantity;
};


final mysql:Options mysqlOptions = {
        // SSL configuration
            ssl: {
                mode: mysql:SSL_PREFERRED
            }
        };

final mysql:Client dbClient = check new (user = username, password = password, host = host, port = port, database = database, options = mysqlOptions, connectionPool={maxOpenConnections: 3});



public function log_message(string message) {
    if(log) {
        io:println(message);
    }
}

// public function main() returns error? {
//     // Create the database if it does not exist.
//     log_message("Creating database "+ database +" if it does not exist.");
//     //sql:ExecutionResult _ = check dbClient->execute(`CREATE DATABASE IF NOT EXISTS ${database}`);
//     log_message("Database created.");
//     log_message("user: " + username + " password: " + password + " host: " + host + " database: " + database);
//     // Create the tables if they do not exist.
//     log_message("Creating tables if they do not exist.");
//     log_message("Creating table " + USER_TABLE + " if it does not exist.");
//     sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), email VARCHAR(255), password VARCHAR(255), phone VARCHAR(255), address VARCHAR(255), role VARCHAR(255), status VARCHAR(255))`);
//     sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS items (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), description VARCHAR(255), price DECIMAL(10,2), intendedFor VARCHAR(255), color VARCHAR(255))`);
//     sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS orders (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), address VARCHAR(255), phone VARCHAR(255), email VARCHAR(255), status VARCHAR(255), paymentMethod VARCHAR(255), paymentStatus VARCHAR(255), shippingMethod VARCHAR(255), shippingStatus VARCHAR(255), shippingAddress VARCHAR(255), shippingPhone VARCHAR(255), shippingEmail VARCHAR(255), shippingNotes VARCHAR(255), notes VARCHAR(255), date VARCHAR(255), time VARCHAR(255), userId VARCHAR(255))`);
//     sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS order_items (id INT AUTO_INCREMENT PRIMARY KEY, orderId INT, itemId INT, quantity INT)`);
//     log_message("Tables created.");
//     // Insert some data into the tables.
//     log_message("Inserting data into tables.");
    
// }

public function init_store() returns error? {
    // Create the database if it does not exist.
    log_message("Creating database "+ database +" if it does not exist.");
    //sql:ExecutionResult _ = check dbClient->execute(`CREATE DATABASE IF NOT EXISTS ${database}`);
    log_message("Database created.");
    log_message("user: " + username + " password: " + password + " host: " + host + " database: " + database);
    // Create the tables if they do not exist.
    log_message("Creating tables if they do not exist.");
    log_message("Creating table " + USER_TABLE + " if it does not exist.");
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), email VARCHAR(255), password VARCHAR(255), phone VARCHAR(255), address VARCHAR(255), role VARCHAR(255), status VARCHAR(255))`);
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS items (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), description VARCHAR(255), price DECIMAL(10,2), intendedFor VARCHAR(255), color VARCHAR(255))`);
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS orders (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), address VARCHAR(255), phone VARCHAR(255), email VARCHAR(255), status VARCHAR(255), paymentMethod VARCHAR(255), paymentStatus VARCHAR(255), shippingMethod VARCHAR(255), shippingStatus VARCHAR(255), shippingAddress VARCHAR(255), shippingPhone VARCHAR(255), shippingEmail VARCHAR(255), shippingNotes VARCHAR(255), notes VARCHAR(255), date VARCHAR(255), time VARCHAR(255), userId VARCHAR(255))`);
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS order_items (id INT AUTO_INCREMENT PRIMARY KEY, orderId INT, itemId INT, quantity INT)`);
    log_message("Tables created.");
    // Insert some data into the tables.
    log_message("Inserting data into tables.");
    
}



//create get function for each table
public function get_users() returns User[]|error {
    log_message("Getting users.");
    stream<User, sql:Error?> resultStream = dbClient->query(`SELECT * FROM users`);
    User[] users = [];
    error? e = resultStream.forEach(function(User user) {
        users.push(user);
    });
    check e;
    return users;
}

public function get_items() returns Item[]|error {
    log_message("Getting items.");
    stream<Item, sql:Error?> resultStream = dbClient->query(`SELECT * FROM items`);
    Item[] items = [];
    error? e = resultStream.forEach(function(Item item) {
        items.push(item);
    });
    check e;
    return items;
}

public function get_orders() returns Order[]|error {
    log_message("Getting orders.");
    stream<Order, sql:Error?> resultStream = dbClient->query(`SELECT * FROM orders`);
    Order[] orders = [];
    error? e = resultStream.forEach(function(Order order) {
        orders.push(order);
    });
    check e;
    return orders;
}

public function get_order_items() returns OrderItem[]|error {
    log_message("Getting order items.");
    stream<OrderItem, sql:Error?> resultStream = dbClient->query(`SELECT * FROM order_items`);
    OrderItem[] orderItems = [];
    error? e = resultStream.forEach(function(OrderItem orderItem) {
        orderItems.push(orderItem);
    });
    check e;
    return orderItems;
}

//create add function for each table
public function add_user(User user) returns error? {
    log_message("Adding user.");
    sql:ParameterizedQuery query = `INSERT INTO users (name, email, password, phone, address, role, status) VALUES (${user.name}, ${user.email}, ${user.password}, ${user.phone}, ${user.address}, ${user.role}, ${user.status})`;
    sql:ExecutionResult result = check dbClient->execute(query);
    log_message("User added.");
}

public function add_item(Item item) returns error? {
    log_message("Adding item.");
    sql:ParameterizedQuery query = `INSERT INTO items (name, description, price, intendedFor, color) VALUES (${item.name}, ${item.description}, ${item.price}, ${item.intendedFor}, ${item.color})`;
    sql:ExecutionResult result = check dbClient->execute(query);
    log_message("Item added.");
}

public function add_order(Order order) returns error? {
    log_message("Adding order.");
    sql:ParameterizedQuery query = `INSERT INTO orders (name, address, phone, email, status, paymentMethod, paymentStatus, shippingMethod, shippingStatus, shippingAddress, shippingPhone, shippingEmail, shippingNotes, notes, date, time, userId) VALUES (${order.name}, ${order.address}, ${order.phone}, ${order.email}, ${order.status}, ${order.paymentMethod}, ${order.paymentStatus}, ${order.shippingMethod}, ${order.shippingStatus}, ${order.shippingAddress}, ${order.shippingPhone}, ${order.shippingEmail}, ${order.shippingNotes}, ${order.notes}, ${order.date}, ${order.time}, ${order.userId})`;
    sql:ExecutionResult result = check dbClient->execute(query);
    log_message("Order added.");
}

public function add_order_item(OrderItem orderItem) returns error? {
    log_message("Adding order item.");
    sql:ParameterizedQuery query = `INSERT INTO order_items (orderId, itemId, quantity) VALUES (${orderItem.orderId}, ${orderItem.itemId}, ${orderItem.quantity})`;
    sql:ExecutionResult result = check dbClient->execute(query);
    log_message("Order item added.");
}

//create update function for each table
public function update_user(User user) returns error? {
    log_message("Updating user.");
    sql:ParameterizedQuery query = `UPDATE users SET name = ${user.name}, email = ${user.email}, password = ${user.password}, phone = ${user.phone}, address = ${user.address}, role = ${user.role}, status = ${user.status} WHERE id = ${user.id}`;
    sql:ExecutionResult result = check dbClient->execute(query);
    log_message("User updated.");
}

public function update_item(Item item) returns error? {
    log_message("Updating item.");
    sql:ParameterizedQuery query = `UPDATE items SET name = ${item.name}, description = ${item.description}, price = ${item.price}, intendedFor = ${item.intendedFor}, color = ${item.color} WHERE id = ${item.id}`;
    sql:ExecutionResult result = check dbClient->execute(query);
    log_message("Item updated.");
}

public function update_order(Order order) returns error? {
    log_message("Updating order.");
    sql:ParameterizedQuery query = `UPDATE orders SET name = ${order.name}, address = ${order.address}, phone = ${order.phone}, email = ${order.email}, status = ${order.status}, paymentMethod = ${order.paymentMethod}, paymentStatus = ${order.paymentStatus}, shippingMethod = ${order.shippingMethod}, shippingStatus = ${order.shippingStatus}, shippingAddress = ${order.shippingAddress}, shippingPhone = ${order.shippingPhone}, shippingEmail = ${order.shippingEmail}, shippingNotes = ${order.shippingNotes}, notes = ${order.notes}, date = ${order.date}, time = ${order.time}, userId = ${order.userId} WHERE id = ${order.id}`;
    sql:ExecutionResult result = check dbClient->execute(query);
    log_message("Order updated.");
}

public function update_order_item(OrderItem orderItem) returns error? {
    log_message("Updating order item.");
    sql:ParameterizedQuery query = `UPDATE order_items SET orderId = ${orderItem.orderId}, itemId = ${orderItem.itemId}, quantity = ${orderItem.quantity} WHERE id = ${orderItem.id}`;
    sql:ExecutionResult result = check dbClient->execute(query);
    log_message("Order item updated.");
}

//create delete function for each table
public function delete_user(int id) returns error? {
    log_message("Deleting user.");
    sql:ParameterizedQuery query = `DELETE FROM users WHERE id = ${id}`;
    sql:ExecutionResult result = check dbClient->execute(query);
    log_message("User deleted.");
}

public function delete_item(int id) returns error? {
    log_message("Deleting item.");
    sql:ParameterizedQuery query = `DELETE FROM items WHERE id = ${id}`;
    sql:ExecutionResult result = check dbClient->execute(query);
    log_message("Item deleted.");
}

public function delete_order(int id) returns error? {
    log_message("Deleting order.");
    sql:ParameterizedQuery query = `DELETE FROM orders WHERE id = ${id}`;
    sql:ExecutionResult result = check dbClient->execute(query);
    log_message("Order deleted.");
}

public function delete_order_item(int id) returns error? {
    log_message("Deleting order item.");
    sql:ParameterizedQuery query = `DELETE FROM order_items WHERE id = ${id}`;
    sql:ExecutionResult result = check dbClient->execute(query);
    log_message("Order item deleted.");
}





        




