# S.H.A.R.K. Tech Spec: Architectural & Operational Documentation

## 1. System Overview & Architecture

**Method S.H.A.R.K.** is a multi-agent orchestration framework designed for the Google Antigravity IDE. It transforms the IDE into a pseudo-Operating System where specific "Agents" act as system kernels, each handling a distinct layer of the software development lifecycle (SDLC).

### 1.1 Core Concept
The methodology relies on a **Linear-Recursive Pipeline** where 5 specialized agents operate in a strict sequence (S -> H -> A -> R -> K), interacting with a shared file system and memory state to build, verify, and secure software.

**Core Stack:**
- **IDE:** Google Antigravity (VS Code based)
- **Repo:** GitHub (MCP Integrated)
- **Backend:** Supabase (MCP Integrated - Auth, DB, Edge Functions)
- **Deploy:** Vercel
- **Context:** Local Filesystem (`~/.gemini/`) + Active Workspace

### 1.2 The 5-Agent Swarm
Every interaction is governed by a specific agent loaded via context injection (reading specific `.md` files).

| Agent | Archetype | Technical Directive | Key Artifacts |
|:---:|:---:|:---|:---|
| **SHIVA** | Specification | **Input Processing & Data Structuring.** Transforms natural language into structured JSON/Markdown requirements. Uses Python scripts for asset extraction. | `docs/memoria/projeto.md`, `design-system.json`, `project_context.json` |
| **HADES** | Architecture | **State Management & Planning.** Maintains the Source of Truth (`asbuilt.md`). Generates execution plans and SOPs. Manages GitFlow. | `docs/asbuilt.md`, `docs/plano-tarefas.md`, `docs/receitas/*.md` |
| **ATLAS** | Execution | **I/O Operations & Shell Execution.** The only agent authorized to run potentially destructive commands (Bash, Git, npm). Strict input/output machine. | Source Code, Build Artifacts, Git Commits |
| **RAVENA** | QA | **Verification & Browser Automation.** Uses Playwright/Puppeteer via "Browser Agent" for E2E testing. Validates UI/UX against design tokens. | `docs/qa-test-report.md`, Screenshots |
| **KERBEROS** | Security | **Offensive Security & Audit.** Performs static analysis (SAST) and active penetration testing (DAST) via Browser Agent. Audit dependency trees. | `docs/security-audit-report.md`, Vulnerability scans |

---

## 2. Operational Workflow (The Pipeline)

The workflow follows a strict direction. No step can be skipped.

### Phase 1: Specification (S - Shiva)
1.  **Context Injection:** Loads `~/.gemini/agents/shiva.md`.
2.  **Discovery:** Scans for existing `user_data.json` to personalize context.
3.  **Data Extraction:**
    *   If Image provided -> Runs `DesignSystemExtractor` (Python) to generate `design-system.json` (Tokens) and `design-tokens.css`.
    *   If URL provided -> Scrapes structure.
4.  **Artifact Generation:**
    *   `project_context.json`: Structured representation of entities, pages, and requirements.
    *   `projeto.md`: Human-readable constitution.
5.  **Handoff:** Explicit trigger invoking **Hades**.

### Phase 2: Planning & Architecture (H - Hades)
1.  **Context Injection:** Loads `~/.gemini/agents/hades.md`.
2.  **Environment Check:** Verifies MCP availability (Supabase/GitHub).
3.  **State Initialization:** Creates/Updates `docs/asbuilt.md`. This file is the **Immutable Source of Truth** for project status.
4.  **Roadmap Decomposition:** Breaks `projeto.md` into atomic tasks in `docs/plano-tarefas.md`.
5.  **GitFlow Setup:**
    *   Initializes `git`.
    *   Creates/Enforces branches: `main` (locked), `hml` (staging), `dev` (working).
6.  **Instruction Generation:** Generates precise Bash/Shell commands for Atlas.

### Phase 3: Action & Execution (A - Atlas)
1.  **Context Injection:** Loads `~/.gemini/agents/atlas.md`.
2.  **Protocol:**
    *   **Input:** Receives markdown code blocks from Hades.
    *   **Validation:** Checks specific constraints (e.g., "Am I in `dev`?").
    *   **Execution:** Runs `npm`, `git`, `docker`, file writes.
    *   **Output:** Returns raw stdout/stderr logs and file diffs.
3.  **Loop:** Reports success/failure back to Hades for next instructions.
4.  **Constraint:** NEVER merges to `main` without explicit confirmation.

### Phase 4: Review & QA (R - Ravena)
1.  **Context Injection:** Loads `~/.gemini/agents/ravena.md`.
2.  **Environment Sync:** Ensures `hml` branch is synced with `main` before testing.
3.  **Automated Testing Suite:**
    *   Triggers Atlas to run unit tests (`npm test`).
    *   **Browser Agent:** executes E2E scripts:
        *   `goto(url)`
        *   `click(selector)`
        *   `getComputedStyle()` (to validate Design System compliance against `design-system.json`).
4.  **Reporting:** Generates `qa-test-report.md` with pass/fail status.

### Phase 5: Security (K - Kerberos)
1.  **Context Injection:** Loads `~/.gemini/agents/kerberos.md`.
2.  **Offensive Auditing:**
    *   **SAST:** Greps for hardcoded secrets (`API_KEY`, `.env` in git).
    *   **DAST (Browser Agent):**
        *   SQL Injection payloads in inputs.
        *   XSS attacks (`<script>`).
        *   CSRF & IDOR checks.
3.  **Gatekeeping:** Blocks deployment if Critical/High vulnerabilities exist.

---

## 3. GitFlow Enforcement Strategy

The method enforces a specific branching strategy via **Hades** (Planning) and **Atlas** (Execution).

*   **`dev`**: The volatile working branch. All code generation happens here.
    *   *Policy:* Commits allowed freely.
*   **`hml` (Homologation)**: The testing sandbox.
    *   *Policy:* Merge from `dev` only after Phase 3 (Atlas) success.
    *   *Trigger:* Ravena & Kerberos operate primarily here.
*   **`main` (Production)**: The stable release.
    *   *Policy:* LOCKED. Merge from `hml` requires:
        1.  Ravena Approval (QA Pass).
        2.  Kerberos Approval (Security Audit Pass).
        3.  Explicit User Confirmation ("Deploy").
    *   *Artifact:* `docs/asbuilt.md` must be updated with version tags before merge.

---

## 4. Skills & Dynamic Context System

The method extends standard LLM capabilities through a **Skill Injection System**.

*   **Repository:** `~/.gemini/skills/`
*   **Mechanism:** Agents autonomosly detect intent keywords and use `view_file` to load specialized `.md` instruction sets.
*   **Translation Layer:** A mandatory constraint where Agents must "translate" technical jargon from Skills into layperson terms for the user, while maintaining technical precision in the background.

**Example Flow:**
1.  **Shiva** detects "Pricing Page".
2.  Loads `skills/business-analyst.md`.
3.  Processes technical requirement (Tiered Pricing Model).
4.  Output to User: "Vamos criar opções de planos para diferentes tipos de clientes?"
5.  Output to Project: Generates structured JSON for pricing tier components.

---

## 5. Artifact Specifications

### 5.1 `docs/asbuilt.md` (Source of Truth)
Must reside in every project. Contains:
*   Project Description & Stack.
*   Phase Status (01 to N).
*   Completion % metrics.
*   History of sessions.
*   Known Technical Debt/Blockers.

### 5.2 `user_data.json`
Located in `~/.gemini/memory/[username]/`.
*   Persists user identity across workspaces.
*   stores `name` (for addressing protocols).
*   Tracks interaction history.

### 5.3 `project_context.json`
Generated by Shiva. Machine-readable definition of the system.
```json
{
  "project_name": "String",
  "entities": [{ "name": "User", "fields": [...] }],
  "pages": ["/login", "/dashboard"],
  "design_system": { "primary_color": "#Hex", "font": "Name" }
}
```
