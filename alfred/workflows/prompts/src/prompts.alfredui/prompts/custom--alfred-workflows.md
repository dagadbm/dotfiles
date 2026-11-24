Help me build or change an Alfred workflow, often with an Alfred UI (`.alfredui`) window.

Rules:

1. Never invent a key, value, enum, default or behaviour. Before using one, open the Alfred docs page that defines it and confirm the exact spelling and type. If the docs do not cover it, say so plainly, and only then fall back to a working example: either a workflow already in my Alfred preferences folder or one of Alfred's own. Name which one you used. If neither covers it, tell me what is unverified instead of guessing.
2. Every UI size is a multiple of 8: width, height, padding, spacing, insets, cornerradius and cell height. Font sizes follow a type scale instead (macOS body 13, then ratio 1.25: 16, 20). Leave a size out instead of picking an odd number. Where the docs say a size acts as a minimum (`constraints.size`), use it that way rather than fixing a height.
3. Keep logic in plain files inside the workflow folder (the `.alfredui` bundle and its `scripts/`), not in scripts typed into Alfred's editor, so changes diff cleanly. Paths in a UI are relative to the `.alfredui` root, and scripts run from there.
4. Never rename a workflow folder (`user.workflow.<UUID>`); Alfred treats a renamed folder as a new workflow.
5. Keep a workflow's source outside the Alfred preferences folder, in `<repo>/alfred/workflows/<name>/src/` (the workflow folder: `info.plist` and the rest). Symlink it into Alfred with a relative link, `Alfred.alfredpreferences/workflows/user.workflow.<UUID> -> <relative path>/alfred-workflows/<name>/src`, so the workflow Alfred runs is the one in git. Build the shareable `<repo>/alfred-workflows/<name>/<Name>.alfredworkflow` by zipping the contents of `src/` without `prefs.plist` (it holds my configured values). Never import that file on my own Mac: it would replace the symlinked folder. Put anything other people should be able to change in the workflow configuration (`userconfigurationconfig` in `info.plist`), not hard-coded values.
6. Say which parts you could only check by running the workflow in Alfred, and what to look for.

Alfred docs to check:

- Alfred UI index (Technical Documentation section): https://www.alfredapp.com/help/alfredui/
- Package structure: https://www.alfredapp.com/help/alfredui/structure/
- ui.json top-level keys: https://www.alfredapp.com/help/alfredui/ui-json/
- Window (size, padding, minsize, maxsize): https://www.alfredapp.com/help/alfredui/window/
- Placeholders ({var:}, {const:}, {file:}, {fileraw:}, {value:}, {data:}): https://www.alfredapp.com/help/alfredui/placeholders/
- Events and triggers: https://www.alfredapp.com/help/alfredui/events/
- Actions (log, script, json, function): https://www.alfredapp.com/help/alfredui/actions/
- JSON actions: https://www.alfredapp.com/help/alfredui/actions/json/
  - update: https://www.alfredapp.com/help/alfredui/actions/json/update/
  - copy: https://www.alfredapp.com/help/alfredui/actions/json/copy/
  - finish: https://www.alfredapp.com/help/alfredui/actions/json/finish/
- Components: https://www.alfredapp.com/help/alfredui/components/
  - Shared properties: https://www.alfredapp.com/help/alfredui/components/shared-properties/
  - Label: https://www.alfredapp.com/help/alfredui/components/label/
  - Textfield: https://www.alfredapp.com/help/alfredui/components/textfield/
  - Markdown area: https://www.alfredapp.com/help/alfredui/components/markdownarea/
  - Data view: https://www.alfredapp.com/help/alfredui/components/dataview/
  - Data view basic provider: https://www.alfredapp.com/help/alfredui/components/dataview/providers/basic/
  - Data view filters: https://www.alfredapp.com/help/alfredui/components/dataview/filters/
- Layouts: https://www.alfredapp.com/help/alfredui/layouts/
  - Border layout: https://www.alfredapp.com/help/alfredui/layouts/border/
  - Constraints: https://www.alfredapp.com/help/alfredui/layouts/constraints/
- Alfred UI workflow object (connect from a Keyword Input or Hotkey): https://www.alfredapp.com/help/workflows/user-interface/alfredui/

Linked pages I have not read yet, so check them before relying on them: properties, getters, variables, templates, pulse, debug, log, JSON functions, other components and other layouts.

The task:

XXX
