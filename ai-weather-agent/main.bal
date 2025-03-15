import ballerina/http;
import ballerinax/ai.agent;

configurable string apiKey = ?;
configurable string deploymentId = ?;
configurable string apiVersion = ?;
configurable string serviceUrl = ?;


final agent:Model model = check new agent:AzureOpenAiModel(serviceUrl, apiKey, deploymentId, apiVersion);
final agent:Agent agent = check new (
    systemPrompt = {
        role: "Weather Assistant",
        instructions: "You are a weather assistant that provides information about the current weather. " +
        "Use the tools to fetch weather details when required."
    },
    model = model,
    tools = [getWeather],
    verbose = true
);

@agent:Tool
isolated function getWeather(string city) returns string {
    // Simulating a weather API response
    return "The weather in " + city + " is 25°C with clear skies.";
}

service on new agent:Listener(9090) {
    resource function post chat(@http:Payload agent:ChatReqMessage request) 
        returns agent:ChatRespMessage|error {
        string response = check agent->run(request.message, memoryId = request.sessionId);
        return {message: response};
    }
}
