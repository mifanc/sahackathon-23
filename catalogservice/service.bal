// import ballerina/graphql;
// //import ballerina/http;
// import ballerinax/mysql;
// import ballerina/sql;
// import ballerinax/mysql.driver as _;    
// import ballerina/io;

// configurable string user = ?;
// configurable string password = ?;
// configurable string host = ?;
// configurable int port = ?;
// configurable string database = ?;

// type Item record {
//     int id;
//     string name;
//     string description;
//     decimal price;
//     string intendedFor;
//     string color;
// };

// # A service representing a network-accessible API
// # bound to port `9090`.
// # 
// # create a graphql api in ballerina
// service /catalog on new graphql:Listener(9090) {
//     private mysql:Client dbClient;
    

//     function init() returns error? {
//         mysql:Options mysqlOptions = {
//         // SSL configuration
//             ssl: {
//                 mode: mysql:SSL_PREFERRED
//             }
//         };
//         io:print("user: " + user + " password: " + password + " host: " + host + " database: " + database);
//         self.dbClient = check new (user = user, password = password, host = host, port = port, database = database, options = mysqlOptions, connectionPool={maxOpenConnections: 3});
//         io:println("Connected to MySQL");

//     }

//     resource function get all () returns Item[]|error? {
//         //retrieve all items from the database
//         stream<Item, sql:Error?> resultStream =  self.dbClient->query(`SELECT * FROM Items`);
//         //process the stream and convert results to Item or return error
//         return from Item item in resultStream 
//                 select item;


//     }
//     resource function get test() returns string {
//         return "test";
//     }
         
// }
