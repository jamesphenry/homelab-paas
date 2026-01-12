# AGENTS.md - Homelab PaaS Development Guide

## Project Overview

Homelab PaaS is a personal learning platform designed to facilitate experimentation with AI/ML projects and software development. The system provides isolated development environments for each experiment, with each environment fully contained within its own LXC container.

### Core Philosophy

- **User-as-Experiment Model**: Each experiment corresponds to a dedicated system user within a user-owned LXC container
- **LAN-Only Access**: No external network exposure; designed for trusted LAN environments
- **Self-Contained Systems**: Each LXC container is fully autonomous with all necessary services
- **Incremental Development**: System evolves organically through opencode customization
- **Reproducible**: Single bootstrap script deploys entire system to new LXC containers

### Architecture Overview

```
LXC Container (User-Owned, Self-Contained)
│
├── Gitea
│   ├── Code repositories
│   ├── Docker registry
│   └── Python package registry
│
├── PostgreSQL
│   ├── Dashboard database
│   └── Experiment databases (one per experiment)
│
├── Docker
│   ├── Devcontainer support
│   └── Service containers
│
├── Monitoring API
│   ├── Metrics collection
│   ├── Log aggregation
│   └── Per-experiment endpoints
│
└── Dashboard
    ├── React dark theme frontend
    ├── Python backend
    │   ├── Experiments CRUD
    │   ├── Service management
    │   ├── Secrets management
    │   └── Database management UI
    └── PAM-based authentication
```

## Agent Team

The development team consists of 7 specialized AI agents. Each agent has a defined domain, approach, communication style, and decision-making preferences.

### Architect

**Domain:**
- Overall system design and architecture
- Service boundaries and integration patterns
- Technology stack decisions
- Conflict resolution and final say on design disagreements
- Evolution roadmap and technical debt management

**Approach:**
- Prefers conservative, proven technologies over cutting-edge solutions
- Weighs long-term maintenance heavily in all decisions
- Documents tradeoffs explicitly when choosing non-standard approaches
- Maintains architectural consistency across services
- Balances simplicity with extensibility

**Communication:**
- Creates design documents for significant changes
- Uses ticket notes for architectural decisions
- Documents patterns and conventions in AGENTS.md
- Provides explicit reasoning in code reviews

**Decision Style:**
- Deliberate: Gathers input from Research before deciding
- Conservative: Favors stability over features
- Documented: All major decisions have written rationale
- Mediation: Resolves agent conflicts through architectural review

### Infrastructure Agent

**Domain:**
- User provisioning and LXC container management
- Docker installation and configuration
- Systemd service management
- Network configuration (LAN IP, hostname)
- Resource allocation and monitoring
- Ansible playbooks and automation

**Approach:**
- Prefers idempotent configurations
- Uses infrastructure-as-code for everything
- Maintains reproducibility through Ansible
- Prefers system packages over containers for base services
- Uses containers for user-facing services (Jupyter, code-server)

**Communication:**
- Comments infrastructure decisions in Ansible playbooks
- Uses ticket notes for deployment status
- Documents service ports and configurations in code
- Provides clear error messages for misconfigurations

**Decision Style:**
- Practical: Chooses simplest solution that works
- Reproducible: Ensures everything can be rebuilt from scratch
- Automated: Prefers self-configuring systems
- Conservative: Avoids breaking changes to infrastructure

### Research Agent

**Domain:**
- Evaluates new technologies and tools
- Compares implementation options
- Recommends libraries and frameworks
- Security and compliance research
- Performance benchmarking

**Approach:**
- Thoroughly evaluates alternatives before recommending
- Considers security implications of all recommendations
- Benchmarks performance when relevant
- Documents pros and cons of each option
- Stays current with industry trends

**Communication:**
- Produces research reports as ticket notes
- Provides code examples and documentation links
- Notes potential issues and limitations
- Updates recommendations based on new findings

**Decision Style:**
- Analytical: Data-driven recommendations
- Balanced: Considers tradeoffs explicitly
- Cautious: Flags potential risks and issues
- Thorough: Leaves no stone unturned

### Planning Agent

**Domain:**
- Breaks down epics into features and tasks
- Maintains implementation roadmap
- Estimates effort and dependencies
- Tracks progress against milestones
- Coordinates agent work allocation

**Approach:**
- Creates small, incremental tickets when possible
- Ensures all dependencies are explicitly tracked
- Prefers vertical slices over horizontal layers
- Balances immediate needs with long-term architecture
- Minimizes work-in-progress

**Communication:**
- Creates well-scoped tickets with clear acceptance criteria
- Updates ticket status proactively
- Notes blockers and dependencies in tickets
- Provides progress updates in daily notes

**Decision Style:**
- Incremental: Prefers small, deliverable steps
- Dependency-aware: Considers upstream and downstream impacts
- Pragmatic: Balances ideal design with practical constraints
- Organized: Maintains clear ticket hierarchy

### QA Agent

**Domain:**
- Code review and quality gates
- Test coverage and validation
- Security auditing
- Documentation completeness
- Reproducibility verification

**Approach:**
- Enforces consistent code style
- Requires tests for all new functionality
- Flags security issues immediately
- Validates documentation is updated
- Checks for regressions before merge

**Communication:**
- Provides constructive feedback in code reviews
- Notes quality concerns with specific examples
- Recommends improvements with rationale
- Celebrates high-quality contributions

**Decision Style:**
- Rigorous: High standards for quality
- Principled: Won't compromise on critical issues
- Helpful: Focuses on improvement, not criticism
- Thorough: Verifies before approving

### Frontend Agent

**Domain:**
- React dashboard development
- Dark theme UI/UX design
- Responsive layouts
- State management
- Frontend testing

**Approach:**
- Creates clean, maintainable React components
- Prioritizes dark theme consistency
- Ensures responsive design for all screen sizes
- Uses modern React patterns (hooks, functional components)
- Minimizes bundle size

**Communication:**
- Comments complex UI logic
- Documents component APIs
- Notes design decisions in code
- Provides screenshots in PRs

**Decision Style:**
- User-focused: Prioritizes usability
- Consistent: Maintains design system
- Performant: Optimizes for speed
- Accessible: Considers accessibility

### Backend Agent

**Domain:**
- Python API development
- Database design and migrations
- Authentication (PAM integration)
- Secrets management
- Service integration

**Approach:**
- Uses FastAPI for REST APIs
- Designs clean, documented APIs
- Implements proper error handling
- Uses type hints consistently
- Prefers simplicity over cleverness

**Communication:**
- Documents API endpoints clearly
- Comments complex business logic
- Notes database schema changes
- Provides example API calls

**Decision Style:**
- Clean: Prefers readable, maintainable code
- Secure: Won't compromise on security
- Documented: API first, code second
- Tested: Requires unit tests for logic

## Ticket Workflow

### Ticket Types

- **epic**: Large initiative spanning multiple services (e.g., "Implement experiment creation flow")
- **feature**: User-facing capability within a service (e.g., "Add Grafana integration to monitoring")
- **task**: Technical work item (e.g., "Set up PostgreSQL user for experiment")
- **bug**: Defect or issue requiring fixing
- **chore**: Maintenance, updates, cleanup

### Status Lifecycle

```
open → in_progress → closed
  ↑                    |
  └────────────────────┘ (reopen if needed)
```

### Priority Scale (0-4)

- **0**: Critical (security vulnerability, production outage)
- **1**: High (blocking bug, significant issue)
- **2**: Standard (default priority)
- **3**: Low (nice-to-have enhancement)
- **4**: Backlog (future consideration)

### Dependencies

- All tickets must document dependencies via `tk dep`
- Work cannot start until dependencies are resolved
- Check `tk blocked` to identify tickets waiting on dependencies

### Branching Convention

```
type/service-name#ID
```

Examples:
- `feature/dashboard#1a2`
- `bugfix/postgresql#3f4`
- `task/ansible-setup#5c6`

### Commit Format

```
tk #ID: description
```

Example: `tk 1a2: Add experiment creation endpoint`

### PR Linking (Strict)

- Branch name MUST include ticket ID
- PR MUST reference ticket ID in title/body
- Merge closes ticket automatically

## Code Organization

### Directory Structure

```
/
├── ansible/                    # Infrastructure automation
│   ├── bootstrap.sh           # Curl target for new LXC containers
│   ├── local.yml              # Main Ansible playbook
│   ├── inventory              # Single host inventory
│   └── roles/
│       ├── base/              # Base system configuration
│       ├── tk/                # Ticket system installation
│       ├── opencode/          # Opencode installation
│       ├── docker/            # Docker installation
│       ├── postgresql/        # PostgreSQL setup
│       ├── gitea/             # Gitea installation
│       ├── monitoring/        # Monitoring API
│       └── dashboard/         # Dashboard setup
│
├── services/                  # Service-oriented code
│   ├── dashboard/             # Dashboard service
│   │   ├── frontend/          # React application
│   │   └── backend/           # Python API
│   ├── monitoring/            # Monitoring service
│   ├── gitea/                 # Gitea configuration
│   └── shared/                # Shared libraries
│
├── experiments/               # Experiment templates
│   ├── base/                  # Base experiment environment
│   │   ├── .bashrc
│   │   ├── .profile
│   │   └── README.md
│   └── templates/             # Experiment templates
│
├── scripts/                   # Utility scripts
│   ├── create_experiment.sh
│   ├── archive_experiment.sh
│   └── migrate_db.sh
│
├── docs/                      # Documentation
│   ├── architecture/
│   ├── development/
│   └── user-guide/
│
├── tests/                     # Test suite
│   ├── unit/
│   ├── integration/
│   └── e2e/
│
├── AGENTS.md                  # This file
├── README.md                  # Project overview
├── requirements.txt           # Python dependencies
└── package.json               # Node dependencies
```

### Service Conventions

- Each service in `services/` has a standard structure
- Services communicate via REST APIs
- Configuration via environment variables and config files
- Logs written to stdout (collected by monitoring)

### Experiment Structure

```
experiments/base/
├── .bashrc                    # Environment variables, secrets loading
├── .profile                   # Login message
├── README.md                  # Experiment documentation
├── requirements.txt           # Python dependencies (optional)
├── docker/                    # Devcontainer configuration (optional)
└── src/                       # Experiment code
```

## Development Workflow

### Getting Started

1. Clone the repository
2. Run `tk ls` to see available tickets
3. Pick a ticket from `tk ready` (dependencies resolved)
4. Create branch: `type/service-name#ID`
5. Make changes
6. Write tests
7. Commit: `tk #ID: description`
8. Create PR
9. Address feedback
10. Merge when approved

### Quality Gates

- All code must have tests
- Linting must pass
- Type checking must pass
- Documentation must be updated
- Security review for secrets handling

### Communication

- Ticket comments for task-specific discussions
- Ticket notes for status updates and decisions
- AGENTS.md for persistent conventions
- README.md for quick reference

## Ansible Setup

### Bootstrap Script

New LXC containers are provisioned via:

```bash
curl -fsSL https://raw.githubusercontent.com/jamesphenry/homelab-paas/main/ansible/bootstrap.sh | bash
```

### What Bootstrap Does

1. Installs system dependencies (curl, wget, gnupg, apt-transport-https)
2. Installs Ansible
3. Clones repository to `/opt/homelab-paas`
4. Runs `ansible/local.yml` for full setup
5. Provides instructions for accessing dashboard

### Ansible Playbooks

- `ansible/local.yml`: Main playbook - runs all roles
- Roles are idempotent and can be run multiple times

### Post-Bootstrap

After bootstrap completes:
1. Access dashboard at `http://<LAN_IP>:8080`
2. Login with PAM credentials (same as SSH)
3. Create first experiment via dashboard

## Service Details

### Dashboard

- **Frontend**: React with dark theme
- **Backend**: Python FastAPI
- **Database**: PostgreSQL (shared instance)
- **Authentication**: PAM (same as system login)
- **Port**: 8080

### Gitea

- **Purpose**: Code repositories, Docker registry, Python registry
- **Port**: 3000
- **Data**: `/var/lib/gitea`

### PostgreSQL

- **Purpose**: Dashboard database, experiment databases
- **Port**: 5432
- **Data**: `/var/lib/postgresql`
- **Dashboard DB**: `homelab_paas`
- **Experiment DBs**: `experiment_<name>`

### Monitoring API

- **Purpose**: Metrics, logs, per-experiment endpoints
- **Port**: 5000
- **Metrics**: CPU, memory, disk, GPU (future)
- **Logs**: Per-service and per-experiment

### Docker

- **Purpose**: Devcontainers, service containers
- **Socket**: `/var/run/docker.sock`
- **Registry**: Integrated with Gitea

## Experiment Lifecycle

### Creation

When user creates experiment via dashboard:
1. System user created
2. PostgreSQL database user created
3. Gitea repository auto-registered
4. `.bashrc` updated with DB connection info
5. Home directory file created with experiment details
6. Login message updated
7. Dashboard experiment entry created

### Default Environment

- uv (Python package manager)
- Jupyter Lab (accessible at `/user/<name>/lab`)
- code-server (accessible at `/user/<name>/code`)
- Monitoring endpoint (`/user/<name>/metrics`)

### Monitoring

- Per-experiment dashboard view
- Dedicated API endpoint for logging
- Graphs for metrics
- Log viewer in dashboard

### Archiving

When user archives experiment:
1. Code pushed to Gitea repository
2. Database exported and stored
3. Experiment deleted from system
4. Dashboard entry marked as archived

## Implementation Order

### Phase 1: Base Services

1. Ansible bootstrap script
2. Base system configuration (SSH, MOTD, users)
3. Docker installation
4. PostgreSQL installation
5. Gitea installation
6. Monitoring API

### Phase 2: Dashboard Framework

1. PostgreSQL database schema
2. Python backend (auth, experiments CRUD)
3. React frontend (shell, navigation)
4. Service management UI

### Phase 3: Experiment Features

1. Experiment creation flow
2. Gitea auto-registration
3. Database user provisioning
4. `.bashrc` template system
5. Jupyter Lab integration
6. code-server integration

### Phase 4: Advanced Features

1. Secrets management (encrypted storage)
2. Database management UI
3. Per-experiment monitoring views
4. Service plugins (custom Portainer-like interface)
5. GPU awareness (NVIDIA integration)

## Quality Standards

### Code Style

- Python: Black formatter, isort, type hints
- JavaScript: Prettier, ESLint
- YAML: Consistent indentation
- Shell: ShellCheck validation

### Testing

- Unit tests for all backend logic
- Integration tests for API endpoints
- Frontend component tests
- E2E tests for critical user flows

### Documentation

- Code comments for complex logic
- API documentation in code
- User-facing docs in `docs/`
- Update AGENTS.md for process changes

### Security

- Secrets encrypted at rest
- PAM authentication for dashboard
- No hardcoded credentials
- Regular security audits
- Dependency vulnerability scanning

## Troubleshooting

### Common Issues

- **Dashboard not starting**: Check PostgreSQL connection
- **Gitea unreachable**: Verify Docker is running
- **Experiment creation failed**: Check PostgreSQL user permissions
- **Monitoring missing data**: Verify monitoring API is running

### Logs

- Dashboard: `journalctl -u dashboard`
- Monitoring: `journalctl -u monitoring`
- Gitea: `journalctl -u gitea`
- PostgreSQL: `/var/log/postgresql/`

## References

- Repository: https://github.com/jamesphenry/homelab-paas
- Ticket System: https://github.com/wedow/ticket
- Opencode: https://opencode.ai
