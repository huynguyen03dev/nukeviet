# Dictionary Detail Page Separation PRD

## 1. Introduction / Overview
The dictionary module currently renders search results and word details within the same `main.tpl` view. Selecting a suggestion replaces the introductory panel with in-place word details, which prevents direct linking and makes navigation confusing. This feature will introduce a dedicated detail page so that each word has its own URL and the main page remains focused on search and discovery.

## 2. Goals
- Provide a dedicated, shareable detail page for every dictionary word.
- Keep the main dictionary page as a lightweight entry point for search and suggestions.
- Preserve the existing search and autocomplete experience for users.

## 3. User Stories
- As a site visitor, I can click a suggestion from the dictionary search bar and land on a dedicated detail page showing the word information so that I can focus on that word.
- As a site visitor, I can bookmark or share the URL of a word detail page so that others can open it directly without using the search page first.

## 4. Functional Requirements
1. The system must provide a new frontend operation (e.g., `detail.php`) that renders the full word information for a given slug/id and is accessible to all visitors without authentication.
2. The detail page must reuse the existing detail UI (headword, part of speech, pronunciation, meaning, notes, examples) currently shown within `main.tpl`.
3. The search suggestions on the main dictionary page must navigate (same tab) to the dedicated detail page when a word is selected, using a query-parameter route such as `index.php?{NV_LANG_VARIABLE}={NV_LANG_DATA}&{NV_NAME_VARIABLE}={MODULE_NAME}&{NV_OP_VARIABLE}=detail&word=<slug>`.
4. The detail page must handle invalid or missing slugs gracefully (e.g., show a `{LANG.no_results}` message and provide a link back to the main search page).
5. The main dictionary page must retain the current search and autocomplete behavior, including loading indicators and intro messaging.

## 5. Non-Goals (Out of Scope)
- No changes to the admin panel, entry management workflows, or data model.
- No new search filters or autocomplete logic changes beyond linking to the detail page.
- No new bookmarking, favoriting, or editing capabilities on the detail page.

## 6. Design Considerations
- Reuse the existing visual components from the in-page word detail panel so the new page stays consistent with the current theme.
- Ensure the layout aligns with `themes/default/modules/dictionary` styling conventions and responsive behavior already in place.
- Provide obvious navigation back to the main search page (e.g., breadcrumb or button) to maintain user flow.

## 7. Technical Considerations
- Create a new `modules/dictionary/funcs/detail.php` (or equivalent) with corresponding `detail.tpl`, following NukeViet naming/security conventions and using `$global_config['module_theme']` for template resolution.
- Implement routing with query parameters (e.g., `index.php?{NV_LANG_VARIABLE}={NV_LANG_DATA}&{NV_NAME_VARIABLE}={MODULE_NAME}&{NV_OP_VARIABLE}=detail&word=<slug>`) and access the slug via `$nv_Request->get_title('word', 'get', '')` to satisfy coding standards.
- Use existing data access helpers to fetch word details by slug/id, avoiding additional database queries beyond those required for a single word fetch.
- Update the frontend JS to redirect the user to the detail page when a suggestion is selected while retaining the current autocomplete UX.
- Ensure direct navigation to the detail page (without visiting the main page first) works correctly, including initialization of audio assets and language strings.

## 8. Success Metrics
- TBD with product stakeholders. Potential proxies include tracking unique page views of individual word detail URLs or reduced user confusion reports about navigation.

## 9. Open Questions
- Should breadcrumbs or navigation aids be added to reinforce the relationship between the search page and detail page?
- Do we need analytics or logging updates to capture usage of the new detail page?

