import ballerina/http;
import ballerina/io;

http:Client clientEndpoint = check new ("https://api.chucknorris.io/jokes/");

// This function performs a `get` request to the Chuck Norris API and returns a random joke
// with the name replaced by the provided name or an error if the API invocation fails.
function getRandomJoke(string name) returns string|error {

    http:Response response = check clientEndpoint->/random;

    if response.statusCode != http:STATUS_OK {
        string errorMsg = "error occurred while sending GET request";
        io:println(errorMsg, ", status code: ", response.statusCode, ", payload: ", response.getJsonPayload());
        return error(errorMsg);
    }

    json payload = check response.getJsonPayload().ensureType();
    string joke = check payload.value;
    string replacedText = re `Chuck Norris`.replaceAll(joke, name);
    return replacedText;
}