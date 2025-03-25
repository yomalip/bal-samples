import ballerina/http;

service / on new http:Listener(9090) {

    // This function responds with `string` value `Hello, World!` to HTTP GET requests.
    resource function get greeting() returns string {
        return "greeting!";
    }
}

service / on new http:Listener(9099) {

    // This function responds with `string` value `Hello, World!` to HTTP GET requests.
    resource function get xyz() returns string {
        return "xyz";
    }
}
