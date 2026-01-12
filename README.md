# Homelab PaaS

A personal learning platform for AI/ML experiments and software development. Each experiment runs in an isolated environment with full dev tooling.

## Quick Start

```bash
# Deploy to new Debian 12 LXC container
curl -fsSL https://raw.githubusercontent.com/jamesphenry/homelab-paas/main/ansible/bootstrap.sh | bash
```

After bootstrap, access the dashboard at `http://<LAN_IP>:8080` and login with your system credentials.

## Architecture

```
LXC Container (User-Owned)
├── Gitea (code + Docker/Python registries)
├── PostgreSQL (dashboard + experiment databases)
├── Docker (devcontainers)
├── Monitoring API (metrics + logs)
└── Dashboard (React + Python, dark theme)
    ├── Experiments CRUD
    ├── Service management
    ├── Secrets management
    └── Database management UI
```

## Features

- **Isolated Experiments**: Each experiment = dedicated system user with uv, Jupyter Lab, code-server
- **Auto-Provisioning**: Create experiment → Gitea repo + database user + dev environment ready
- **Monitoring**: Per-experiment metrics and logs via dashboard API
- **Secrets Management**: Encrypted storage, loaded into experiment environment
- **Service Plugins**: Extend system via opencode; dashboard auto-updates
- **GPU-Aware**: Ready for NVIDIA GPU integration
- **LAN-Only**: No external network exposure

## For Users

- Access dashboard to create/manage experiments
- Experiments auto-configure with Jupyter Lab and code-server
- Archive experiments to Gitea when complete

## For Developers

See [AGENTS.md](./AGENTS.md) for:
- Agent team responsibilities
- Ticket workflow and conventions
- Implementation phases
- Development guidelines

## Repository Structure

```
├── ansible/          # Bootstrap and base service installation
├── services/         # Service code (dashboard, monitoring, etc.)
├── experiments/      # Experiment templates
├── scripts/          # Utility scripts
├── docs/             # Documentation
└── AGENTS.md         # Development guide
```

## Tech Stack

- **Dashboard**: React (dark theme), Python FastAPI, PostgreSQL
- **Services**: Gitea, Docker, Monitoring API
- **Automation**: Ansible, opencode, tk (ticket system)

## License

MIT
