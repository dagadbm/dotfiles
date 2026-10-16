#!/usr/bin/env python3
"""
Security validator hook.
Blocks destructive commands like 'rm -rf'.

For file access blocking, use permissions.deny in settings.json instead.
"""
import json
import sys
import re


def check_bash_command(command: str) -> tuple[bool, str]:
    """
    Validate bash commands for dangerous patterns.
    Returns: (is_allowed, error_message)
    """

    # Block rm -rf / rm -r -f patterns
    if re.search(r'\brm\s+(-[a-zA-Z]*r[a-zA-Z]*f|-[a-zA-Z]*f[a-zA-Z]*r)\b', command):
        return False, "rm -rf is blocked. Use explicit rm commands with specific file paths."

    # Block rm -r at root/home level
    if re.search(r'\brm\s+-[a-zA-Z]*r[a-zA-Z]*\s+[/~]', command):
        return False, "Recursive deletion at root/home level is blocked."

    return True, ""


def main():
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON input: {e}", file=sys.stderr)
        sys.exit(1)

    tool_name = input_data.get("tool_name", "")
    tool_input = input_data.get("tool_input", {})

    # Only validate Bash commands
    if tool_name != "Bash":
        sys.exit(0)

    command = tool_input.get("command", "")

    if not command:
        sys.exit(0)

    is_allowed, error_msg = check_bash_command(command)

    if not is_allowed:
        # Exit code 2 = block with error message
        print(f"SECURITY BLOCK: {error_msg}", file=sys.stderr)
        sys.exit(2)

    sys.exit(0)


if __name__ == "__main__":
    main()
