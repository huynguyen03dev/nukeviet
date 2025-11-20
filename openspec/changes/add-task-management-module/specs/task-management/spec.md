## ADDED Requirements

### Requirement: Board Lifecycle Management
The system SHALL allow administrators with the `task` module permission to create, edit, list, and archive task boards within the admin interface. Boards MUST capture name, summary, default column order, and visibility scope (admin-only).

#### Scenario: Create board
- **GIVEN** an authenticated admin with `task_board_manage` capability
- **WHEN** they submit a new board with name and summary
- **THEN** the board is persisted and appears in the board list ordered by last update

#### Scenario: Archive board
- **WHEN** an admin archives a board
- **THEN** the board is removed from active listings while remaining queryable for exports and history

### Requirement: Column Organization
Each board SHALL contain one or more columns with configurable names and ordering. Columns MUST be reorderable via drag-and-drop actions that persist order server-side.

#### Scenario: Add column
- **WHEN** an admin adds a column to a board
- **THEN** the column is saved with a sequential position and appears in board views

#### Scenario: Reorder columns
- **WHEN** an admin drags a column to a new position and drops it
- **THEN** the system updates stored ordering and returns the updated order to the client

### Requirement: Card Lifecycle
Cards SHALL belong to a column and store title, description, assignee, due date, labels, and priority. Cards MUST support CRUD actions, movement between columns, and server-side ordering.

#### Scenario: Create card
- **WHEN** an admin submits card details for a column
- **THEN** the card is created with default position at the bottom of the column

#### Scenario: Move card between columns
- **WHEN** an admin drags a card to another column and position
- **THEN** the system updates the card's column_id and ordering atomically and returns success

### Requirement: Card Collaboration
Cards SHALL expose commenting and activity logs to capture discussions and changes. Comments MUST record author, timestamp, and markdown-lite body. Activity entries MUST log state changes (creation, field edits, moves).

#### Scenario: Add comment
- **WHEN** an admin posts a comment on a card
- **THEN** the comment is stored with author + timestamp and displayed newest-first

#### Scenario: Log activity
- **WHEN** a card field changes (status, due date, column move)
- **THEN** the system appends an activity entry describing the change with actor + timestamp

### Requirement: Data Access & Export
The module SHALL provide admin-side endpoints to list boards/cards, enforce NukeViet role permissions, and export board data (CSV) including cards, columns, and activity references for auditing.

#### Scenario: Permission enforcement
- **WHEN** a user without `task` admin rights hits any module endpoint
- **THEN** the request is rejected with the standard NukeViet "Stop!!!" response

#### Scenario: Export board data
- **WHEN** an admin triggers board export
- **THEN** the system streams a CSV capturing columns, cards, assignments, and timestamps using localized headers
