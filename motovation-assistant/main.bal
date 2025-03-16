import ballerina/http;
import ballerinax/ai.agent;
import ballerina/random;

configurable string apiKey = ?;
configurable string deploymentId = ?;
configurable string apiVersion = ?;
configurable string serviceUrl = ?;

final agent:Model model = check new agent:AzureOpenAiModel(serviceUrl, apiKey, deploymentId, apiVersion);
final agent:Agent agent = check new (
    systemPrompt = {
        role: "Daily Motivation Assistant",
        instructions: "You provide short motivational quotes when asked."
    },
    model = model,
    tools = [getMotivationalQuote],
    verbose = true
);

@agent:Tool
isolated function getMotivationalQuote() returns string|error {
    // Returning a simple motivational quote
    string[] quotes = [
        "Believe in yourself and all that you are!",
        "The only limit to our realization of tomorrow is our doubts of today.",
        "Keep pushing forward. Every step counts!",
        "Success is not final, failure is not fatal: it is the courage to continue that counts."
    ];
    return quotes[check random:createIntInRange(0, quotes.length())];
}

service on new agent:Listener(8090) {
    resource function post chat(@http:Payload agent:ChatReqMessage request) 
        returns agent:ChatRespMessage|error {
        string response = check agent->run(request.message, memoryId = request.sessionId);
        return {message: response};
    }
}
