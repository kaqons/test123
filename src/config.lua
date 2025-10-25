-- config.lua

return {
    API_KEY = "YOUR_GEMINI_API_KEY", -- Replace with your actual Gemini API key from Google AI Studio
    AI_MODEL = "gemini-2.5-pro", -- Specify the Gemini model to use
    API_ENDPOINT = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent", -- Gemini API endpoint

    -- Gemini Thinking Configuration
    THINKING_CONFIG = {
        thinkingBudget = -1, -- -1 for dynamic, 0 to disable, or a specific token budget
        includeThoughts = false -- Set to true to get thought summaries
    },

    MAX_OUTPUT_TOKENS = 8192, -- Maximum number of tokens for the AI's response
    TEMPERATURE = 0.9, -- Controls the randomness of the AI's output
    DEFAULT_PROMPT = "You are a helpful and creative AI assistant for Roblox Studio. Your goal is to help users build, script, and create amazing things in their Roblox games.", -- Default system prompt

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
