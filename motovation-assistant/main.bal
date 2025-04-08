import ballerina/http;

service / on new http:Listener(9090) {

    // This function responds with `string` value `Hello, World!` to HTTP GET requests. test123123
    resource function get greeting() returns string {
        return "greeting!";
    }
}

service / on new http:Listener(8089) {

    // This function responds with `string` value `Hello, World!` to HTTP GET requests.
    resource function get xyz() returns string {
        return "xyz";
    }
}
