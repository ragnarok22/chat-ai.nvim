AI Chat

## Installation

Using Lazy:

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
