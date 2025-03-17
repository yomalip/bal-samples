import ballerina/http;
import ballerina/io;

configurable string apiKey = ?;
configurable string deploymentId = ?;

service / on new http:Listener(9090) {

    // This function responds with `string` value `Hello, World!` to HTTP GET requests.
    resource function get greeting() returns string {
        io:println(apiKey);
        io:println(deploymentId);
        return "Hello, World!";
    }
}
