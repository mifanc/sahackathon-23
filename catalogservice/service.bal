import ballerina/graphql;
//import ballerina/http;
import ballerinax/mysql;
import ballerina/sql;
import ballerinax/mysql.driver as _;    

configurable string user = ?;
configurable string password = ?;
configurable string host = ?;
configurable int port = ?;
configurable string database = ?;

public type Item record {
    int id;
    string name;
    string description;
    decimal price;
    string intendedFor;
    string color;
};

# A service representing a network-accessible API
# bound to port `9090`.
# 
# create a graphql api in ballerina
service /catalog on new graphql:Listener(9090) {
    private mysql:Client dbClient;

    function init() returns error? {
        self.dbClient = check new (user, password, database, host, port);
    }

    resource function get all () returns Item[]|error? {
        //retrieve all items from the database
        stream<Item, sql:Error?> resultStream =  self.dbClient->query(`SELECT * FROM Items`);
        //process the stream and convert results to Item or return error
        return from Item item in resultStream 
                select item;


    }
    resource function get test() returns string {
        return "test";
    }
         
}
