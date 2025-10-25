-- config.lua

return {
    API_KEY = "YOUR_API_KEY", -- Replace with your actual API key
    AI_MODEL = "gpt-4", -- Specify the AI model to use
    API_ENDPOINT = "https://api.openai.com/v1/chat/completions", -- API endpoint
    MAX_TOKENS = 4096, -- Maximum number of tokens for the AI's response
    TEMPERATURE = 0.7, -- Controls the randomness of the AI's output
    DEFAULT_PROMPT = "You are a helpful AI assistant for Roblox Studio.", -- Default system prompt

    -- UI settings
    UI_THEME = {
        BACKGROUND_COLOR = Color3.fromRGB(40, 42, 54),
        TEXT_COLOR = Color3.fromRGB(248, 248, 242),
        PRIMARY_COLOR = Color3.fromRGB(189, 147, 249),
        SECONDARY_COLOR = Color3.fromRGB(98, 114, 164),
        FONT = Enum.Font.SourceSans
    },

    -- Chat history settings
    CHAT_HISTORY_ENABLED = true,
    MAX_CHAT_HISTORY = 50, -- Maximum number of messages to store in the history

    -- Tool settings
    TOOLS_ENABLED = true,
    TOOL_PREFIX = "!" -- Prefix to trigger a tool command
}
