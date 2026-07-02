# Graph Report - D:\TaoTomate.Dots  (2026-07-03)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 110 nodes · 195 edges · 21 communities (10 shown, 11 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 7 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `bd110126`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_System Architecture Config|System Architecture Config]]
- [[_COMMUNITY_Skill Metadata Extraction|Skill Metadata Extraction]]
- [[_COMMUNITY_Agent Entry Points Skills|Agent Entry Points Skills]]
- [[_COMMUNITY_Skill Registry System|Skill Registry System]]
- [[_COMMUNITY_SDD Workflow Skills|SDD Workflow Skills]]
- [[_COMMUNITY_Persistence and Protocol Conventions|Persistence and Protocol Conventions]]
- [[_COMMUNITY_Governance and Auditing|Governance and Auditing]]
- [[_COMMUNITY_Skill Catalog Reporting|Skill Catalog Reporting]]
- [[_COMMUNITY_Registry Generation Tools|Registry Generation Tools]]
- [[_COMMUNITY_Hermes Agent Profiles|Hermes Agent Profiles]]
- [[_COMMUNITY_Duplicate Skill Detection|Duplicate Skill Detection]]
- [[_COMMUNITY_Recommendation Generation|Recommendation Generation]]
- [[_COMMUNITY_JSON Output Utility|JSON Output Utility]]
- [[_COMMUNITY_Distillation Protocol|Distillation Protocol]]
- [[_COMMUNITY_Validation Framework|Validation Framework]]
- [[_COMMUNITY_Global Error Logging|Global Error Logging]]
- [[_COMMUNITY_System Philosophy Vision|System Philosophy Vision]]
- [[_COMMUNITY_Conversation Distillation Skill|Conversation Distillation Skill]]
- [[_COMMUNITY_Error Mining Skill|Error Mining Skill]]
- [[_COMMUNITY_Skill Auditor Tool|Skill Auditor Tool]]
- [[_COMMUNITY_Skill Migration Tool|Skill Migration Tool]]

## God Nodes (most connected - your core abstractions)
1. `Agent Base Instructions` - 24 edges
2. `Skill Registry` - 15 edges
3. `SDD Workflow` - 14 edges
4. `Architecture Documentation` - 14 edges
5. `main()` - 11 edges
6. `Agent Config README` - 11 edges
7. `scan_directory()` - 10 edges
8. `Governance Protocol` - 10 edges
9. `Components Reference` - 10 edges
10. `Load Flow Documentation` - 9 edges

## Surprising Connections (you probably didn't know these)
- `Agent Base Instructions` --references--> `Error Log`  [EXTRACTED]
  agent-config/agents/base.md → agent-config/.config/error_log.md
- `Agent Base Instructions` --references--> `Model Routing`  [EXTRACTED]
  agent-config/agents/base.md → agent-config/shared/routing.md
- `Agent Base Instructions` --references--> `Skill: sdd-apply`  [EXTRACTED]
  agent-config/agents/base.md → agent-config/skills/sdd-apply/SKILL.md
- `Agent Base Instructions` --references--> `Skill: sdd-archive`  [EXTRACTED]
  agent-config/agents/base.md → agent-config/skills/sdd-archive/SKILL.md
- `Agent Base Instructions` --references--> `Skill: sdd-init`  [EXTRACTED]
  agent-config/agents/base.md → agent-config/skills/sdd-init/SKILL.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Agent Entry Points (all platforms)** — agent_config_agents_entry, agent_config_claude_md, agent_config_gemini_md, agent_config_agents_antigravity_md [EXTRACTED 1.00]
- **SDD Phase Skill Graph** — agent_config_skills_sdd_init_skill_sdd_init, agent_config_skills_sdd_explore_skill_sdd_explore, agent_config_skills_sdd_propose_skill_sdd_propose, agent_config_skills_sdd_spec_skill_sdd_spec, agent_config_skills_sdd_design_skill_sdd_design, agent_config_skills_sdd_tasks_skill_sdd_tasks, agent_config_skills_sdd_apply_skill_sdd_apply, agent_config_skills_sdd_verify_skill_sdd_verify, agent_config_skills_sdd_archive_skill_sdd_archive, agent_config_skills_sdd_onboard_skill_sdd_onboard [EXTRACTED 1.00]
- **Failure Handling Flow** — agent_config_config_governance_protocol_md, agent_config_skills_auditor_skill_auditor, agent_config_config_error_log_md, agent_config_shared_routing_md [EXTRACTED 0.95]
- **Platform Agent Config Inheritance from Base** — agent_config_agents_base, agent_config_agents_claude_code, agent_config_agents_gemini_cli, agent_config_agents_antigravity [EXTRACTED 1.00]
- **Hermes Worker Profiles (Orchestrator + Specialists)** — agent_config_hermes_profiles_chat_general_soul, agent_config_hermes_profiles_coder_soul, agent_config_hermes_profiles_research_soul, agent_config_hermes_profiles_vision_soul, agent_config_hermes_profiles_ollama_soul [EXTRACTED 1.00]
- **SDD Artifact Persistence Modes** — concept_engram_persistence, concept_openspec_persistence, concept_hybrid_persistence, agent_config_docs_persistence_contract, agent_config_docs_engram_convention, agent_config_docs_openspec_convention [EXTRACTED 0.95]

## Communities (21 total, 11 thin omitted)

### Community 0 - "System Architecture Config"
Cohesion: 0.28
Nodes (16): Antigravity Agent Config, Base Agent Config (Source of Truth), Claude Code Agent Config, Gemini CLI Agent Config, Architecture Documentation, Components Reference, Load Flow Documentation, Agent Trigger Rules (+8 more)

### Community 1 - "Skill Metadata Extraction"
Cohesion: 0.25
Nodes (11): extract_description(), extract_skill_name(), extract_version(), parse_frontmatter(), Extract YAML frontmatter from a markdown file., Get skill name from frontmatter or fall back to parent directory name., Get version from frontmatter., Get description from frontmatter, truncated to 80 chars. (+3 more)

### Community 2 - "Agent Entry Points Skills"
Cohesion: 0.24
Nodes (10): Agent Base Instructions, Claude Code Overrides, AGENTS.md Entry Point, Gemini CLI Overrides, CLAUDE.md Entry Point, GEMINI.md Entry Point, Skill: go-testing, Skill: sdd-onboard (+2 more)

### Community 3 - "Skill Registry System"
Cohesion: 0.24
Nodes (10): Changelog, Skill Registry, Contributing Guide, Skill Template, Project AGENTS.md Template, LLM-first Skill Style Guide, Skill: skill-optimizer, Skill: skill-registry (+2 more)

### Community 4 - "SDD Workflow Skills"
Cohesion: 0.20
Nodes (10): Skill: sdd-apply, Skill: sdd-archive, Skill: sdd-design, Skill: sdd-explore, Skill: sdd-init, Skill: sdd-propose, Skill: sdd-spec, Skill: sdd-tasks (+2 more)

### Community 5 - "Persistence and Protocol Conventions"
Cohesion: 0.44
Nodes (9): Engram Artifact Convention, OpenSpec File Convention, Persistence Contract, SDD Phase Common Protocol, Skill Resolver Protocol, Skill: judgment-day, Engram Persistence Mode, Hybrid Persistence Mode (+1 more)

### Community 6 - "Governance and Auditing"
Cohesion: 0.29
Nodes (8): Antigravity Agent Wrapper, Error Log, Governance Protocol, Skill Audit Report, Agent Config README, Model Routing, Skill Style Guide, Skill: auditor

### Community 7 - "Skill Catalog Reporting"
Cohesion: 0.25
Nodes (7): Skills Report, build_version_map(), content_hash(), print_report(), Map skill name → list of all found versions across locations., Print human-readable markdown report., SHA-256 hash of the file content (normalized: strip trailing whitespace per line

### Community 8 - "Registry Generation Tools"
Cohesion: 0.36
Nodes (8): archive_duplicates(), generate_registry(), identify_active(), main(), Mark skills that live in the active agent-config directories., Move non-active duplicate skill directories to .skill-archive/., Generate skill-registry.md from scanned skills., Path

### Community 9 - "Hermes Agent Profiles"
Cohesion: 0.33
Nodes (6): Hermes Chat-Fast Profile (Deprecated), Hermes Chat-General Orchestrator Profile, Hermes Coder Worker Profile, Hermes Ollama Local Oracle Profile, Hermes Research Worker Profile, Hermes Vision Worker Profile

## Knowledge Gaps
- **28 isolated node(s):** `AGENTS.md Entry Point`, `Skill Audit Report`, `Skills Report`, `VISION.md Philosophy`, `Skill Style Guide` (+23 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **11 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Agent Base Instructions` connect `Agent Entry Points Skills` to `System Architecture Config`, `Skill Registry System`, `SDD Workflow Skills`, `Governance and Auditing`, `Skill Catalog Reporting`?**
  _High betweenness centrality (0.259) - this node is a cross-community bridge._
- **Why does `Skill Registry` connect `Skill Registry System` to `System Architecture Config`, `Agent Entry Points Skills`, `Persistence and Protocol Conventions`, `Governance and Auditing`, `Skill Catalog Reporting`, `Hermes Agent Profiles`?**
  _High betweenness centrality (0.220) - this node is a cross-community bridge._
- **Why does `SDD Workflow` connect `SDD Workflow Skills` to `System Architecture Config`, `Agent Entry Points Skills`, `Skill Registry System`, `Persistence and Protocol Conventions`, `Hermes Agent Profiles`?**
  _High betweenness centrality (0.120) - this node is a cross-community bridge._
- **What connects `Extract YAML frontmatter from a markdown file.`, `SHA-256 hash of the file content (normalized: strip trailing whitespace per line`, `Get skill name from frontmatter or fall back to parent directory name.` to the rest of the system?**
  _42 weakly-connected nodes found - possible documentation gaps or missing edges._