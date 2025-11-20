# Change: Add Task Management Module

## Why
NukeViet lacks a built-in workspace for planning work items; site owners currently resort to external tools like Trello or Notion to organize tasks, losing integration, permissions, and localization already available in the CMS.

## What Changes
- Introduce a core task management module that lets teams create boards, columns, and cards with metadata (status, due dates, assignees).
- Provide collaborative card interactions: comments, activity tracking, and drag-and-drop style ordering similar to board tools.
- Expose board/card data through admin pages first, with APIs/hooks to enable future frontend surfacing.

## Impact
- Affected specs: `task-management` (new capability)
- Affected code: new module under `modules/task`, new admin UI screens, supporting database tables, optional APIs/hooks for extension.
