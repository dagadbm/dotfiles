# AI Integration for Neovim

## Overview

This document provides a complete implementation guide for integrating AI capabilities into your Neovim setup using:

1. **minuet-ai.nvim** - Tab completion with Claude API (ghost text/virtual text)
2. **codecompanion.nvim** - Chat, refactoring, workflows, and Claude Code integration

## Prerequisites

### 1. Install Required Tools
```bash
# Install Claude Code CLI (if not already installed)
# Follow instructions at: https://github.com/anthropics/claude-code

# Verify installation
claude --version
```

### 2. Set Environment Variable
Add to your shell configuration (`~/.zshrc`, `~/.bashrc`, etc.):

```bash
export ANTHROPIC_API_KEY="your-api-key-here"
```

Get your API key from: https://console.anthropic.com/settings/keys

### 3. Verify Dependencies
- Neovim >= 0.10
- plenary.nvim (should already be installed)
- blink.cmp (already configured in your setup)

---

## Plugin 1: minuet-ai.nvim

### Purpose
Provides **inline code completions** as you type using Claude's API. Shows ghost text (virtual text) that you can accept with Tab.

### Features
- Virtual text inline completions
- Streaming support for faster responses
- Integrates with blink.cmp
- Multiple LLM provider support (OpenAI, Gemini, Claude, Ollama, etc.)

### Configuration

#### Add to `neovim/lua/plugins/ai.lua`:

```lua
return {
  -- [[ AI Completion ]]
  {
    'milanglacier/minuet-ai.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('minuet').setup({
        provider = 'claude',
        provider_options = {
          claude = {
            model = 'claude-3-5-sonnet-20241022',
            stream = true,
            max_tokens = 512,
            temperature = 0.7,
            api_key = 'ANTHROPIC_API_KEY',  -- Will read from environment variable
            end_point = 'https://api.anthropic.com/v1/messages',
          },
        },
        -- Configure virtual text appearance
        n_completions = 1,  -- Number of completions to generate
        auto_complete = true,  -- Automatically trigger completions
        debounce_delay = 500,  -- Milliseconds to wait before triggering (500ms = 0.5s)

        -- Default keymaps (can be disabled if you want custom ones)
        default_keymaps = true,
      })
    end,
  },

  -- [[ AI Chat & Refactoring ]]
  -- Add codecompanion.nvim configuration here (see below)
}
```

#### Update `neovim/lua/plugins/completion.lua`:

Add minuet to blink.cmp sources. Find the `sources` section and update it:

```lua
sources = {
  default = { 'lsp', 'path', 'snippets', 'buffer', 'minuet', 'tmux', 'cmdline', 'omni' },
  providers = {
    minuet = {
      name = 'minuet',
      module = 'minuet.blink',
      score_offset = 8,  -- Slightly prioritize AI completions
      async = true,
    },
    tmux = {
      module = 'blink-cmp-tmux',
    },
  },
},
```

### Keymaps (Default)

| Key | Action |
|-----|--------|
| `<Tab>` | Accept completion |
| `<C-n>` | Next completion (if multiple) |
| `<C-p>` | Previous completion (if multiple) |
| `<C-x>` | Dismiss completion |

### Usage

1. Start typing code
2. Wait ~0.5 seconds (debounce delay)
3. Ghost text appears as gray inline text
4. Press `<Tab>` to accept, `<C-x>` to dismiss

### Tips

- **Too slow?** Increase `debounce_delay` to trigger less frequently
- **Too fast/distracting?** Set `auto_complete = false` and trigger manually
- **Wrong suggestions?** Adjust `temperature` (lower = more deterministic)
- **Want different model?** Change to `claude-3-5-haiku-20241022` for faster/cheaper

---

## Plugin 2: codecompanion.nvim

### Purpose
Provides **chat interface, inline refactoring, and Claude Code integration**. This is your main AI assistant for conversations and code modifications.

### Features
- Native Neovim chat buffer (not terminal-based)
- Inline transformations with visual selections
- Slash commands (`/explain`, `/fix`, `/tests`, etc.)
- Agent Client Protocol (Claude Code integration)
- CLAUDE.md memory file support
- Multiple LLM provider support
- Agentic workflows

### Configuration

#### Add to `neovim/lua/plugins/ai.lua`:

```lua
{
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('codecompanion').setup({
      adapters = {
        anthropic = function()
          return require('codecompanion.adapters').extend('anthropic', {
            env = {
              api_key = 'ANTHROPIC_API_KEY',  -- Will read from environment variable
            },
            schema = {
              model = {
                default = 'claude-3-5-sonnet-20241022',
              },
            },
          })
        end,
      },

      strategies = {
        -- Use Anthropic for chat
        chat = {
          adapter = 'anthropic',
        },
        -- Use Anthropic for inline transformations
        inline = {
          adapter = 'anthropic',
        },
        -- Use Anthropic for agent workflows
        agent = {
          adapter = 'anthropic',
        },
      },

      -- Display settings
      display = {
        chat = {
          window = {
            layout = 'vertical',  -- or 'horizontal', 'float'
            width = 0.4,  -- 40% of screen width
            height = 0.8,  -- 80% of screen height
          },
          show_settings = true,  -- Show model/settings in chat
        },
        inline = {
          diff = {
            enabled = true,
            highlights = {
              removed = 'DiffDelete',
            },
          },
        },
      },

      -- Enable Claude Code support via Agent Client Protocol
      agent = {
        tools = {
          ['claude-code'] = {
            enabled = true,
          },
        },
      },

      -- Support CLAUDE.md memory files
      opts = {
        memory = true,
      },
    })
  end,
},
```

### Add Keymaps to `neovim/lua/config/mappings.lua`

Add these mappings after line 157 (after `-- [[ AI mappings ]]`):

```lua
-- [[ AI mappings ]]

-- codecompanion.nvim chat and inline commands
map('n', [[<Leader>ic]], [[<Cmd>CodeCompanionChat Toggle<CR>]], { desc = 'Toggle AI chat' })
map('n', [[<Leader>iC]], [[<Cmd>CodeCompanionChat Add<CR>]], { desc = 'Add to AI chat' })

-- Inline AI assistant with prompt
map('n', [[<Leader>ia]], [[<Cmd>CodeCompanion<CR>]], { desc = 'AI inline assistant' })
map('v', [[<Leader>ia]], [[:CodeCompanion<CR>]], { desc = 'AI inline assistant (visual)' })

-- Quick actions (visual mode)
map('v', [[<Leader>ie]], [[:CodeCompanionChat explain<CR>]], { desc = 'Explain code' })
map('v', [[<Leader>if]], [[:CodeCompanionChat fix<CR>]], { desc = 'Fix code' })
map('v', [[<Leader>it]], [[:CodeCompanionChat tests<CR>]], { desc = 'Generate tests' })
map('v', [[<Leader>io]], [[:CodeCompanionChat optimize<CR>]], { desc = 'Optimize code' })
map('v', [[<Leader>id]], [[:CodeCompanionChat docs<CR>]], { desc = 'Add documentation' })

-- Quick actions (normal mode - will use current buffer)
map('n', [[<Leader>ie]], [[<Cmd>CodeCompanionChat explain<CR>]], { desc = 'Explain code' })
map('n', [[<Leader>if]], [[<Cmd>CodeCompanionChat fix<CR>]], { desc = 'Fix diagnostics' })
map('n', [[<Leader>it]], [[<Cmd>CodeCompanionChat tests<CR>]], { desc = 'Generate tests' })

-- Toggle actions menu
map({ 'n', 'v' }, [[<Leader>im]], [[<Cmd>CodeCompanionActions<CR>]], { desc = 'AI actions menu' })
```

### Keymap Reference

| Key | Mode | Action |
|-----|------|--------|
| `<Leader>ic` | Normal | Toggle chat window |
| `<Leader>iC` | Normal | Add current buffer to chat |
| `<Leader>ia` | Normal/Visual | Inline assistant prompt |
| `<Leader>ie` | Normal/Visual | Explain code |
| `<Leader>if` | Normal/Visual | Fix code/diagnostics |
| `<Leader>it` | Normal/Visual | Generate tests |
| `<Leader>io` | Visual | Optimize/refactor code |
| `<Leader>id` | Visual | Add documentation |
| `<Leader>im` | Normal/Visual | Open actions menu |

### Usage Examples

#### 1. Chat with AI
```
<Leader>ic  (opens chat window)
Type: "How do I implement a binary search tree in Lua?"
<Enter>
```

#### 2. Explain Code
```
(Select code in visual mode)
<Leader>ie
(Chat opens with explanation)
```

#### 3. Fix Code
```
(Cursor on line with diagnostic error)
<Leader>if
(AI suggests fix and applies diff)
```

#### 4. Inline Refactoring
```
(Select code in visual mode)
<Leader>ia
Type: "Extract this into a separate function"
<Enter>
(AI shows diff, accept with :w or reject)
```

#### 5. Generate Tests
```
(Select function in visual mode)
<Leader>it
(AI generates test cases)
```

#### 6. Add to Existing Chat
```
<Leader>iC  (adds current buffer to chat)
Continue conversation with context
```

### Slash Commands (In Chat Buffer)

When in a chat buffer, you can use:
- `/explain` - Explain selected code
- `/fix` - Fix the code
- `/tests` - Generate tests
- `/docs` - Add documentation
- `/optimize` - Optimize performance
- `/buffer` - Add current buffer to context
- `/file` - Add file to context
- `/help` - Show all commands

### Claude Code Integration

codecompanion.nvim supports Claude Code via the Agent Client Protocol:

1. Start a chat: `<Leader>ic`
2. Use agent mode for complex tasks
3. Claude Code can read/write files, run commands
4. Changes are shown as diffs in the chat

To enable Claude Code workflows:
```
(In chat buffer)
Type: "@claude-code refactor this module to use dependency injection"
```

### CLAUDE.md Support

If you have a `CLAUDE.md` file in your project root, codecompanion will automatically include it as context for conversations. This is compatible with Claude Code's memory system.

Create `.cursor/rules` or `CLAUDE.md` in your project:
```markdown
# Project Context

## Code Style
- Use 2 spaces for indentation
- Prefer functional programming
- Add type annotations

## Testing
- Use busted for Lua tests
- Test file naming: *_spec.lua
```

---

## Complete Workflow Examples

### Workflow 1: Write a New Feature
1. `<Leader>ic` - Open chat
2. Type: "I need to implement user authentication"
3. AI suggests approach
4. `<Leader>ia` - Inline assistant: "Create AuthService class"
5. Review diff, accept changes
6. `<Leader>it` - Generate tests for new code

### Workflow 2: Debug an Error
1. See diagnostic error in code
2. `<Leader>if` - AI analyzes and suggests fix
3. Review suggestion in chat
4. Accept or modify the fix

### Workflow 3: Refactor Code
1. Select code block in visual mode
2. `<Leader>io` - "Make this more efficient"
3. AI shows optimized version with diff
4. Accept changes

### Workflow 4: Learn/Understand Code
1. Select complex code section
2. `<Leader>ie` - Get detailed explanation
3. Ask follow-up questions in chat
4. `<Leader>id` - "Add comments explaining this"

---

## Troubleshooting

### minuet-ai.nvim

**Problem: Completions not showing**
```bash
# Check API key is set
echo $ANTHROPIC_API_KEY

# Check logs
:messages
```

**Problem: Completions too slow**
- Increase `debounce_delay` to 1000ms or more
- Switch to faster model: `claude-3-5-haiku-20241022`
- Check your internet connection

**Problem: Completions not relevant**
- Lower `temperature` for more focused suggestions
- Adjust `max_tokens` (lower = faster but shorter)
- Check the context around your cursor

**Problem: Tab key conflicts**
- Set `default_keymaps = false` in config
- Define custom keymaps in your mappings.lua

### codecompanion.nvim

**Problem: Chat window not opening**
```vim
:CodeCompanionChat Toggle
:messages  " Check for errors
```

**Problem: API errors**
```bash
# Verify API key
echo $ANTHROPIC_API_KEY

# Check API key is valid at console.anthropic.com
```

**Problem: Diffs not applying**
- Ensure file is writable
- Check for syntax errors in buffer
- Try `:CodeCompanionChat` and manually copy code

**Problem: Claude Code not working**
- Ensure `claude` CLI is installed and in PATH
- Verify Claude Code is authenticated
- Check Agent Client Protocol is enabled in config

---

## Configuration Tips

### Optimize for Speed
```lua
-- In minuet-ai.nvim config
provider_options = {
  claude = {
    model = 'claude-3-5-haiku-20241022',  -- Faster, cheaper
    max_tokens = 256,  -- Shorter completions
  },
}
debounce_delay = 1000,  -- Wait 1 second before triggering
```

### Optimize for Quality
```lua
-- In minuet-ai.nvim config
provider_options = {
  claude = {
    model = 'claude-3-5-sonnet-20241022',  -- Better reasoning
    max_tokens = 1024,  -- Longer completions
    temperature = 0.3,  -- More focused
  },
}
debounce_delay = 300,  -- Trigger quickly (0.3s)
```

### Use Different Models per Task
```lua
-- In codecompanion.nvim config
strategies = {
  chat = {
    adapter = 'anthropic',
    schema = {
      model = { default = 'claude-3-5-sonnet-20241022' },  -- Better for chat
    },
  },
  inline = {
    adapter = 'anthropic',
    schema = {
      model = { default = 'claude-3-5-haiku-20241022' },  -- Faster for inline
    },
  },
}
```

---

## Advanced Configuration

### Add More AI Providers

You can add OpenAI, Ollama, or other providers:

```lua
-- In codecompanion.nvim config
adapters = {
  openai = function()
    return require('codecompanion.adapters').extend('openai', {
      env = {
        api_key = 'OPENAI_API_KEY',
      },
    })
  end,
  ollama = function()
    return require('codecompanion.adapters').extend('ollama', {
      schema = {
        model = { default = 'codellama:13b' },
      },
    })
  end,
}
```

Then switch providers in chat with `:CodeCompanionChat` and select provider.

### Custom Prompts

Add to codecompanion config:

```lua
prompts = {
  ["Custom Refactor"] = {
    strategy = "inline",
    description = "Refactor with my style guide",
    prompts = {
      {
        role = "system",
        content = "You are an expert Lua developer. Follow functional programming principles.",
      },
      {
        role = "user",
        content = "Refactor this code:\n\n```\n{{selection}}\n```",
      },
    },
  },
}
```

Access via: `:CodeCompanionActions` then select "Custom Refactor"

---

## File Structure Summary

After implementation, your files will look like:

```
neovim/
├── lua/
│   ├── plugins/
│   │   ├── ai.lua              # minuet + codecompanion config
│   │   └── completion.lua       # Updated with minuet source
│   └── config/
│       └── mappings.lua         # AI keymaps under <Leader>i
```

---

## Next Steps

1. ✅ Add plugins to `ai.lua`
2. ✅ Update `completion.lua` with minuet source
3. ✅ Add keymaps to `mappings.lua`
4. ✅ Set `ANTHROPIC_API_KEY` environment variable
5. ✅ Restart Neovim
6. ✅ Run `:Lazy sync` to install plugins
7. ✅ Test completion: Start typing and wait for ghost text
8. ✅ Test chat: `<Leader>ic` to open chat
9. ✅ Test inline: Select code, `<Leader>ia`, type prompt

---

## Resources

- minuet-ai.nvim: https://github.com/milanglacier/minuet-ai.nvim
- codecompanion.nvim: https://github.com/olimorris/codecompanion.nvim
- codecompanion.nvim docs: https://codecompanion.olimorris.dev
- Anthropic API docs: https://docs.anthropic.com
- Claude Code: https://github.com/anthropics/claude-code

---

## Quick Reference Card

### Completion (minuet-ai.nvim)
- Just type, wait 0.5s, ghost text appears
- `<Tab>` to accept, `<C-x>` to dismiss

### Chat (codecompanion.nvim)
- `<Leader>ic` - Toggle chat
- `<Leader>iC` - Add buffer to chat
- `<Leader>im` - Actions menu

### Quick Actions
- `<Leader>ie` - Explain
- `<Leader>if` - Fix
- `<Leader>it` - Tests
- `<Leader>io` - Optimize (visual)
- `<Leader>id` - Docs (visual)
- `<Leader>ia` - Custom prompt

---

Good luck! If you run into issues, check the Troubleshooting section or open an issue on the plugin repositories.
