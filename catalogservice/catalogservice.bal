// //write a graphql service for a catalog of items
// import ballerina/graphql;

// service graphql:Service /graphql on new graphql:Listener(9090) {

//     //define a resource function for each operation type
//     resource function get getItems() returns Item[] {
//         //return the items
//     }

//     resource function get getItem(int id) returns Item {
//         //return the item with the given id
//     }

//     resource function post addItem(Item item) returns Item {
//         //add the item and return the added item
//     }

//     resource function put updateItem(int id, Item item) returns Item {
//         //update the item and return the updated item
//     }

//     resource function delete deleteItem(int id) returns boolean {
//         //delete the item and return true if the item is deleted
//     }
// }