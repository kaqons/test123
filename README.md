# Roblox Studio AI Assistant Plugin

Welcome to the Roblox Studio AI Assistant Plugin! This powerful tool integrates Google's Gemini 2.5 Pro AI directly into your Roblox Studio environment, helping you code, build, and create with advanced AI assistance.

## Features

- **AI-Powered Chat:** Get help with scripting, building, and design through an intuitive chat interface.
- **Advanced Reasoning:** Leverages Gemini 2.5 Pro's "thinking" capabilities for complex problem-solving.
- **In-Studio Tools:** The AI can perform actions directly in your game world, such as creating parts, modifying properties, and generating scripts.
- **Persistent Chat History:** Save, browse, and reload your past conversations.
- **Customizable:** Easily configure the AI's behavior and UI to fit your workflow.

## Installation

To install the plugin, you must place the plugin's source code into your local Roblox Studio plugins folder.

1.  **Download the Plugin:**
    *   Download the latest version of the plugin from the [releases page](<link_to_releases_page>) or clone this repository.

2.  **Find Your Local Plugins Folder:**
    *   **Windows:** `C:\Users\<YourUsername>\AppData\Local\Roblox\Plugins`
    *   **Mac:** `Users/<YourUsername>/Documents/Roblox/Plugins`
    *   If the `Plugins` folder does not exist, you can create it.

3.  **Install the Plugin:**
    *   Copy the entire plugin source folder (the `src` directory and all its contents) into your local plugins folder.
    *   You can rename the main plugin folder to something descriptive, like `AI_Assistant_Gemini`.

4.  **Launch Roblox Studio:**
    *   Open Roblox Studio. The "AI Assistant" button should now appear in your "Plugins" toolbar.

## Configuration

Before using the plugin, you need to configure it with your Google Gemini API key.

### 1. Get Your Gemini API Key

1.  Go to the [Google AI Studio website](https://aistudio.google.com/).
2.  Sign in with your Google account.
3.  Click on the "**Get API key**" button.
4.  Create a new API key in a new or existing project.
5.  **Copy the API key** to your clipboard. **Important:** Keep this key private and secure.

### 2. Configure the Plugin

1.  Navigate back to your local plugins folder where you installed the plugin.
2.  Open the `src` folder, and then open the `config.lua` file in a text editor.
3.  Find the `API_KEY` field and replace `"YOUR_GEMINI_API_KEY"` with the key you just copied.

    ```lua
    -- config.lua
    return {
        API_KEY = "PASTE_YOUR_GEMINI_API_KEY_HERE",
        -- ... other settings
    }
    ```

### 3. (Optional) Configure Gemini's Thinking Features

In the same `config.lua` file, you can adjust how the AI "thinks" to solve problems.

-   **`thinkingBudget`**: Controls the amount of reasoning the AI can do.
    -   `-1` (Default): Dynamic thinking. The AI decides how much to think based on the task's complexity.
    -   `0`: Disables thinking (faster for simple tasks).
    -   A specific number (e.g., `8192`): A fixed budget for thinking tokens. Higher values allow for more complex reasoning but may increase response time.
-   **`includeThoughts`**: If set to `true`, the AI's response will include a summary of its thought process. This is useful for debugging or understanding how the AI arrived at an answer.

## How to Use

1.  **Open the Plugin:** Click the "AI Assistant" button in the "Plugins" tab to open the chat window.
2.  **Chat with the AI:** Type your request in the input box at the bottom and press "Send." You can ask for help with:
    *   **Scripting:** "Write a script that makes a part change color every second."
    *   **Building:** "Create a red sphere at position 0, 10, 0."
    *   **General Questions:** "What's the best way to handle player data?"
3.  **Use AI Tools:** The AI can use tools to interact with your game. To trigger a tool, you can often just ask naturally. For example, "Create a new part." The AI will understand and use the `PartCreator` tool.
4.  **Manage Conversations:**
    *   **New Chat:** Click the "New Chat" button to start a fresh conversation. Your old chat will be saved automatically.
    *   **Chat History:** Click the "History" button to see a list of your past conversations. Click on any chat to load it back into the window.

## Available Tools

The AI has access to the following tools:

-   **`PartCreator`**: Creates a new part in the workspace with specified properties.
    -   *Example:* "Create a large, anchored, blue block."
-   **`PropertyChanger`**: Modifies the properties of an existing object in the workspace.
    -   *Example:* "Change the transparency of the part named 'Glass' to 0.5."
-   **`ScriptCreator`**: Generates a new script and places it inside a specified object.
    -   *Example:* "Add a script to the 'Door' part."

More tools will be added in future updates!
