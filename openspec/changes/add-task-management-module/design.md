## Context
Stakeholders want an integrated board-based planning experience without relying on external SaaS tools. The module must reuse NukeViet's admin authentication, permission model, and localization. Primary users are site admins and editors collaborating on content, marketing, or engineering tasks.

## Goals / Non-Goals
- Goals: deliver board/column/card data model, admin CRUD, collaborative features (comments, ordering), and extensible hooks for automation.
- Non-Goals: real-time multi-user editing, public frontend task boards, deep sprint management or burndown charts.

## Decisions
- Data model: hierarchical tables (boards → columns → cards) with audit tables for comments/activity; stored under `NV_PREFIXLANG . '_' . $module_data` naming.
- Admin UX: leverage existing admin theme, use AJAX endpoints for drag/drop ordering, progressive enhancement from classic forms.
- Extensibility: emit module-level hooks (`nv_task_card_updated`) and provide REST-style endpoints for future integrations.

## Risks / Trade-offs
- Complexity creep if scope expands toward full project management; mitigate via staged milestones and feature flags.
- Performance concerns with large boards; mitigate via pagination and server-side ordering updates.
- Permissions matrix might be tricky; reuse NukeViet role system to avoid custom ACLs.

## Migration Plan
1. Deploy schema via module install script.
2. Deliver admin-only UI for managing boards/columns/cards.
3. Add optional APIs and hooks once core CRUD stabilizes.
4. Plan future frontend displays as separate change.

## Open Questions
- Should task boards be shareable with frontend users or restricted to admin? (Assume admin-only for phase one.)
- Do tasks need file attachments at launch? (Not in scope unless requested.)
