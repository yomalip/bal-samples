import ballerina/http;
import ballerinax/ai.agent;
import ballerina/os;

string apiKey = os:getEnv("API_KEY");
string deploymentId = "gpt4o";
string apiVersion = "2023-07-01-preview";
string serviceUrl = "https://ballerina-ai-eastus.openai.azure.com/openai";

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

service on new agent:Listener(8080) {
    resource function post chat(@http:Payload agent:ChatReqMessage request) 
        returns agent:ChatRespMessage|error {
        string response = check agent->run(request.message, memoryId = request.sessionId);
        return {message: response};
    }
}
