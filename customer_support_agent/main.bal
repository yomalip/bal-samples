import ballerina/http;
import ballerinax/ai.agent;
import ballerina/os;

// Get API key from environment variable
string apiKey = os:getEnv("OPENAI_API_KEY");

// Configure OpenAI model
final agent:Model model = check new agent:OpenAiModel(apiKey);

// Create the AI agent
final agent:Agent supportAgent = check new (
    systemPrompt = {
        role: "Customer Support Assistant",
        instructions: "You are a helpful customer support assistant for a tech company. " +
            "Answer customer questions about our products. " +
            "Use the tools to check product information and availability."
    },
    model = model,
    tools = [getProductInfo, checkAvailability],
    verbose = true
);

// Define tools for the agent to use
@agent:Tool {
    description: "Get information about a product by its name"
}
function getProductInfo(string productName) returns string {
    // In a real application, this would query a database
    match productName {
        "laptop" => {
            return "Our standard laptop features 16GB RAM, 512GB SSD, and an Intel i5 processor. Price: $999";
        }
        "smartphone" => {
            return "Our flagship smartphone has a 6.5-inch OLED display, 128GB storage, and 48MP camera. Price: $799";
        }
        "tablet" => {
            return "Our tablet comes with a 10-inch display, 64GB storage, and 10-hour battery life. Price: $499";
        }
        _ => {
            return "Product not found in our catalog";
        }
    }
}

@agent:Tool {
    description: "Check if a product is available in stock"
}
function checkAvailability(string productName) returns string {
    // In a real application, this would check inventory system
    match productName {
        "laptop" => {
            return "In stock: 12 units available for immediate shipping";
        }
        "smartphone" => {
            return "Limited stock: 5 units available. Order soon!";
        }
        "tablet" => {
            return "Out of stock. Expected restock in 2 weeks";
        }
        _ => {
            return "Product not found in our inventory system";
        }
    }
}

// Define HTTP service to handle customer inquiries
service on new http:Listener(8080) {
    resource function post support(@http:Payload agent:ChatReqMessage request) returns agent:ChatRespMessage|error {
        string response = check supportAgent->run(request.message, memoryId = request.sessionId);
        return {message: response};
    }
}
