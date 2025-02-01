# AI Chat

AI Chat for neovim

## Installation

You need to set as environment variable `OPENAI_API_KEY` with your OpenAI API key.

Lazy configuration:

```lua
{
  'ragnarok22/ai-chat.nvim',
  cmd = 'AIChat',
config = function()
  require('ai_chat').setup {
    models = {
      chatgpt = {
        api_key = os.getenv 'OPENAI_API_KEY',
      },
    },
  }
end,
},
```

## Usage

Run `:AIChat` to open the chat window. To send a message go to
normal mode and press Enter.

## Supported models

- chatgpt
- deepseek (coming soon)

## TODO

- Add support for deepseek
- Add context support for better responses.
- Add support for multiple models

## License

MIT
