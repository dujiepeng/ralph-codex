---
name: ralph-prd
description: "Generate a Product Requirements Document (PRD) for a new feature or a full project. Use when planning a feature, starting a new project, or when asked to create a PRD. Triggers on: ralph-prd, create a prd, write prd for, plan this feature, requirements for, spec out, full project, build an app."
user-invocable: true
---

# PRD Generator

Create detailed Product Requirements Documents that are clear, actionable, and suitable for implementation. Use a lightweight feature PRD for changes inside an existing product, and a fuller project blueprint PRD for new applications or complete projects.

---

## The Job

1. Receive a feature or project description from the user
2. Detect whether the request is for a feature or a full project
3. Ask essential clarifying questions (with lettered options)
4. Generate a structured PRD based on answers
5. Save to `tasks/prd-[feature-name].md`

**Important:** Do NOT start implementing. Just create the PRD.

---

## Step 1: Clarifying Questions

First classify the request:

- **Feature PRD:** the user is adding or changing capability inside an existing project.
- **Full Project Blueprint:** the user wants to create a complete app, site, service, tool, or system from scratch or from a broad idea.

Ask only critical questions where the initial prompt is ambiguous. For feature PRDs, ask 3-5 questions. For full project PRDs, ask enough to produce an implementable blueprint, typically 5-8 questions. Focus on:

- **Problem/Goal:** What problem does this solve?
- **Core Functionality:** What are the key actions?
- **Scope/Boundaries:** What should it NOT do?
- **Success Criteria:** How do we know it's done?

For full project PRDs, also clarify:

- **Users and Roles:** who uses the system, and what permissions they have
- **Platforms:** web, mobile, desktop, API-only, CLI, or other delivery targets
- **Data and Persistence:** core entities, stored state, imports/exports, and external services
- **Technical Preferences:** required stack, deployment target, authentication, payments, AI services, or other integrations
- **First Release Scope:** what must be in the initial usable version versus later releases

### Format Questions Like This:

```
1. What is the primary goal of this feature?
   A. Improve user onboarding experience
   B. Increase user retention
   C. Reduce support burden
   D. Other: [please specify]

2. Who is the target user?
   A. New users only
   B. Existing users only
   C. All users
   D. Admin users only

3. What is the scope?
   A. Minimal viable version
   B. Full-featured implementation
   C. Just the backend/API
   D. Just the UI
```

This lets users respond with "1A, 2C, 3B" for quick iteration. Remember to indent the options.

---

## Step 2: PRD Structure

Generate the PRD with these sections:

### 1. Introduction/Overview
Brief description of the feature and the problem it solves.

### 2. Goals
Specific, measurable objectives (bullet list).

### 3. User Stories
Each story needs:
- **Title:** Short descriptive name
- **Description:** "As a [user], I want [feature] so that [benefit]"
- **Acceptance Criteria:** Verifiable checklist of what "done" means

Each story should be small enough to implement in one focused session.

**Format:**
```markdown
### US-001: [Title]
**Description:** As a [user], I want [feature] so that [benefit].

**Acceptance Criteria:**
- [ ] Specific verifiable criterion
- [ ] Another criterion
- [ ] Typecheck/lint passes
- [ ] **[UI stories only]** Verify in browser using dev-browser skill
```

**Important:** 
- Acceptance criteria must be verifiable, not vague. "Works correctly" is bad. "Button shows confirmation dialog before deleting" is good.
- **For any story with UI changes:** Always include "Verify in browser using dev-browser skill" as acceptance criteria. This ensures visual verification of frontend work.

### 4. Functional Requirements
Numbered list of specific functionalities:
- "FR-1: The system must allow users to..."
- "FR-2: When a user clicks X, the system must..."

Be explicit and unambiguous.

### 5. Non-Goals (Out of Scope)
What this feature will NOT include. Critical for managing scope.

### 6. Design Considerations (Optional)
- UI/UX requirements
- Link to mockups if available
- Relevant existing components to reuse

### 7. Technical Considerations (Optional)
- Known constraints or dependencies
- Integration points with existing systems
- Performance requirements

### 8. Success Metrics
How will success be measured?
- "Reduce time to complete X by 50%"
- "Increase conversion rate by 10%"

### 9. Open Questions
Remaining questions or areas needing clarification.

---

## Full Project Blueprint

When the request is for a full project, generate a project-level PRD instead of the lighter feature PRD. The PRD must be complete enough for `ralph-json` to split into small Ralph stories while preserving the whole product intent.

Use these sections:

### 1. Product Overview
Describe the product, target users, primary problem, and first-release value proposition.

### 2. Goals and Non-Goals
List measurable project goals and explicit out-of-scope items for the first release.

### 3. User Roles and Permissions
Define each role, what it can view, create, update, delete, approve, administer, or export.

### 4. Core Workflows
Describe the main end-to-end user journeys, including empty states, error states, and completion states.

### 5. Pages, Routes, and Navigation
List the screens, routes, layouts, navigation surfaces, and major states for each page.

### 6. Functional Requirements
Number every requirement. Include create/read/update/delete behavior, validation rules, search/filter/sort behavior, notifications, imports/exports, and admin actions when relevant.

### 7. Data Model
Define the core entities, fields, relationships, required/optional values, lifecycle states, and retention expectations.

### 8. API, Integrations, and Services
Describe backend operations, external APIs, authentication providers, payment systems, AI services, storage, email, webhooks, or background jobs.

### 9. Project Structure
Specify expected app modules, directory structure, shared components, configuration files, environment variables, and seed/demo data.

### 10. UX and Visual Design
Define layout expectations, interaction patterns, responsive behavior, accessibility needs, and any branding or design-system constraints.

### 11. Non-Functional Requirements
Cover performance, security, privacy, accessibility, reliability, logging, monitoring, maintainability, and browser/device support.

### 12. Testing and Acceptance Strategy
List required unit, integration, end-to-end, browser, build, lint, typecheck, and manual verification expectations.

### 13. Execution Plan
Break the project into Ralph-sized milestones and user stories. Start with project scaffolding and tooling, then data model, backend/service logic, UI workflows, validation/error states, tests, polish, documentation, and deployment readiness. Each story should still be small enough to complete in one focused Ralph iteration.

### 14. Launch Readiness
Define run instructions, deployment target, environment setup, smoke checks, documentation, and release criteria.

### 15. Open Questions
List any unresolved choices and the default assumption to use if the user does not answer.

---

## Writing for Junior Developers

The PRD reader may be a junior developer or AI agent. Therefore:

- Be explicit and unambiguous
- Avoid jargon or explain it
- Provide enough detail to understand purpose and core logic
- Number requirements for easy reference
- Use concrete examples where helpful
- For full projects, describe the complete first usable release before decomposing it into small implementation stories

---

## Output

- **Format:** Markdown (`.md`)
- **Location:** `tasks/`
- **Filename:** `prd-[feature-name].md` (kebab-case)

---

## Example PRD

```markdown
# PRD: Task Priority System

## Introduction

Add priority levels to tasks so users can focus on what matters most. Tasks can be marked as high, medium, or low priority, with visual indicators and filtering to help users manage their workload effectively.

## Goals

- Allow assigning priority (high/medium/low) to any task
- Provide clear visual differentiation between priority levels
- Enable filtering and sorting by priority
- Default new tasks to medium priority

## User Stories

### US-001: Add priority field to database
**Description:** As a developer, I need to store task priority so it persists across sessions.

**Acceptance Criteria:**
- [ ] Add priority column to tasks table: 'high' | 'medium' | 'low' (default 'medium')
- [ ] Generate and run migration successfully
- [ ] Typecheck passes

### US-002: Display priority indicator on task cards
**Description:** As a user, I want to see task priority at a glance so I know what needs attention first.

**Acceptance Criteria:**
- [ ] Each task card shows colored priority badge (red=high, yellow=medium, gray=low)
- [ ] Priority visible without hovering or clicking
- [ ] Typecheck passes
- [ ] Verify in browser using dev-browser skill

### US-003: Add priority selector to task edit
**Description:** As a user, I want to change a task's priority when editing it.

**Acceptance Criteria:**
- [ ] Priority dropdown in task edit modal
- [ ] Shows current priority as selected
- [ ] Saves immediately on selection change
- [ ] Typecheck passes
- [ ] Verify in browser using dev-browser skill

### US-004: Filter tasks by priority
**Description:** As a user, I want to filter the task list to see only high-priority items when I'm focused.

**Acceptance Criteria:**
- [ ] Filter dropdown with options: All | High | Medium | Low
- [ ] Filter persists in URL params
- [ ] Empty state message when no tasks match filter
- [ ] Typecheck passes
- [ ] Verify in browser using dev-browser skill

## Functional Requirements

- FR-1: Add `priority` field to tasks table ('high' | 'medium' | 'low', default 'medium')
- FR-2: Display colored priority badge on each task card
- FR-3: Include priority selector in task edit modal
- FR-4: Add priority filter dropdown to task list header
- FR-5: Sort by priority within each status column (high to medium to low)

## Non-Goals

- No priority-based notifications or reminders
- No automatic priority assignment based on due date
- No priority inheritance for subtasks

## Technical Considerations

- Reuse existing badge component with color variants
- Filter state managed via URL search params
- Priority stored in database, not computed

## Success Metrics

- Users can change priority in under 2 clicks
- High-priority tasks immediately visible at top of lists
- No regression in task list performance

## Open Questions

- Should priority affect task ordering within a column?
- Should we add keyboard shortcuts for priority changes?
```

---

## Checklist

Before saving the PRD:

- [ ] Asked clarifying questions with lettered options
- [ ] Incorporated user's answers
- [ ] Correctly classified the request as feature PRD or Full Project Blueprint
- [ ] User stories are small and specific
- [ ] Functional requirements are numbered and unambiguous
- [ ] Non-goals section defines clear boundaries
- [ ] For full projects, included project structure, data model, workflows, testing strategy, execution plan, and launch readiness
- [ ] Saved to `tasks/prd-[feature-name].md`
