# OpenMetadata MCP (Model Context Protocol) - Compact Guide

Complete setup and usage guide for OpenMetadata's integrated MCP server with AI tools.

## 📖 Table of Contents

1. [MCP Overview](#mcp-overview)
2. [Tool Support & Integration](#tool-support--integration)
3. [MCP Capabilities](#mcp-capabilities)
4. [Use Cases](#use-cases)
5. [OpenMetadata vs DataHub](#openmetadata-vs-datahub)
6. [Setup Guide](#setup-guide)
7. [Troubleshooting](#troubleshooting)
8. [Best Practices](#best-practices)

---

## MCP Overview

**Model Context Protocol (MCP)** enables AI models to securely access external data sources. OpenMetadata v1.8.0+ includes a fully integrated MCP server.

### Key Benefits & Features

| Aspect | Details |
|--------|---------|
| **Authentication** | 🔐 Token-based access control via OpenMetadata JWT/OAuth |
| **Integration** | 🔄 Real-time live data access, not static exports |
| **Compatibility** | 🛠️ Works with multiple AI platforms and tools |
| **Context** | 📊 Rich metadata context from unified data graph |
| **Transport** | SSE (`/mcp/sse`) + Streamable HTTP (`/mcp`) |
| **Protocol** | JSON-RPC 2.0, MCP v2024-11-05 |
| **Security** | Same auth engine as OpenMetadata UI, RBAC integration |

### Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   AI Tool       │    │  MCP Server     │    │  OpenMetadata   │
│ (Claude/VS Code)│◄──►│   (Built-in)    │◄──►│    Platform     │
│                 │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
        │                        │                        │
        │                        │                        │
        ▼                        ▼                        ▼
   User Queries              Authentication         Metadata Graph
   & Commands               & Authorization         & Data Assets
```

---

## Tool Support & Integration

### Comprehensive Tool Support Matrix

| Tool | Status | Support Level | Key Features | Configuration | VS Code Features | Setup Method |
|------|--------|---------------|--------------|---------------|------------------|--------------|
| **Claude Desktop** | ✅ Full | Official | Complete metadata access, search, lineage | `claude_desktop_config.json` | N/A | Direct MCP server connection |
| **VS Code + GitHub Copilot** | ✅ Full | Official | Agent mode, tools, resources, prompts | `.vscode/mcp.json` | Agent mode, tool selection (128 limit), MCP resources, prompts (`/mcp.openmetadata.promptname`), settings sync, auto-discovery | Native MCP protocol (v1.102+) |
| **Goose Desktop** | 🔄 Experimental | Community | Basic metadata access | Custom config | N/A | Community-maintained |

### Configuration Types & Use Cases

| Configuration Type | File/Location | Primary Use Case | Best For | Setup Complexity |
|-------------------|---------------|------------------|----------|------------------|
| **Workspace Config** | `.vscode/mcp.json` | Team sharing, project-specific | Development teams, shared projects | ⭐⭐ Medium |
| **User Config** | Global VS Code settings | Personal setup, cross-project | Individual developers | ⭐ Easy |
| **Auto-discovery** | Automatic detection | Import from other tools | Multi-tool users | ⭐ Easy |

---

## MCP Capabilities

## MCP Capabilities

### OpenMetadata MCP Tools & Capabilities Matrix

| Tool Name | Function | Category | Primary Use | Parameters | Example Usage | Specific Capabilities | Discovery Method |
|-----------|----------|----------|-------------|------------|---------------|----------------------|------------------|
| `search_metadata` | 🔍 Search & Discovery | Data Discovery | Find entities across catalog | `query`, `entity_type`, `limit` | "Search for all tables containing customer data" | Find entities by keywords, filter by type, set result limits, search across tables/databases/dashboards/pipelines | VS Code Agent Mode, Claude chat |
| `get_entity_details` | 📊 Entity Information | Metadata Analysis | Get detailed entity data | `entity_type`, `fqn` | "Get details about the sales database" | Retrieve comprehensive entity information by FQN, get complete metadata context | Direct tool reference |
| `get_entity_lineage` | 🔗 Lineage Analysis | Dependencies | Trace data dependencies | `entity_type`, `fqn`, `upstream_depth`, `downstream_depth` | "Show me the lineage for table 'user_profiles'" | Trace data lineage with upstream/downstream depth control, column-level lineage tracking | Impact analysis queries |
| `create_glossary` | 📝 Governance Setup | Documentation | Create business glossaries | `name`, `description`, `mutuallyExclusive`, `owners`, `reviewers` | "Create a glossary for financial terms" | Set up business glossaries with ownership settings, configure mutual exclusivity | Governance workflows |
| `create_glossary_term` | 📝 Documentation | Documentation | Add glossary terms | `glossary`, `name`, `description`, `parentTerm`, `owners` | "Add a new term 'Customer Lifetime Value'" | Add terms to glossaries with hierarchical relationships, support parent-child structures | Business context creation |
| `patch_entity` | ⚙️ Entity Management | Operations | Update entity metadata | `entityType`, `entityFqn`, `patch` | "Update the description of the users table" | Modify entity properties using JSONPatch operations, fine-grained metadata updates | Administrative tasks |

### Tool Discovery & Access Methods

| Platform | Method | Steps | Command Examples |
|----------|--------|-------|------------------|
| **VS Code** | Agent Mode | Chat view (`Ctrl+Cmd+I`) → Agent mode → Tools button → Look for OpenMetadata tools | `MCP: Browse Resources`, `MCP: List Servers`, `MCP: Show Installed Servers` |
| **Claude Desktop** | Direct Query | Ask AI about available tools | "What tools do you have available from OpenMetadata?" |
| **Terminal** | Direct Testing | Command line MCP testing | `npx -y mcp-remote http://localhost:8585/mcp/sse --header "Authorization:Bearer TOKEN" --verbose` |
| **All Platforms** | Tool Categories | Expected operational categories | 🔍 Search & Discovery, 📊 Lineage Analysis, 📈 Data Quality, 👥 Governance, 📝 Documentation, 🔄 Operations |

---

## Use Cases

### Comprehensive Use Case Matrix

| Use Case Category | Scenario | User Query | AI Response Summary | Tools Used | Business Impact | Example Implementation |
|-------------------|----------|------------|-------------------|------------|-----------------|----------------------|
| **🔄 Pipeline Monitoring** | Operational monitoring | "Monitor our data pipelines and alert me about any failures" | Lists 3 pipelines: ✅ Customer ETL (running), ⚠️ Sales Sync (warning), ❌ ML Pipeline (failed) | `search_metadata`, `get_entity_details` | Proactive issue detection, reduced downtime | Real-time pipeline status dashboard |
| **📊 Dashboard Generation** | Data quality visualization | "Create a dashboard showing our data quality metrics" | Proposes dashboard with completeness scores, freshness trends, validation results, top 10 quality issues | `search_metadata`, `get_entity_details` | Improved data trust, faster issue resolution | Automated quality reporting |
| **🔒 GDPR Compliance** | Regulatory compliance | "I need to find all customer-related data for GDPR compliance" | Identifies 23 tables: 🔴 High risk (PII), 🟡 Medium risk, with compliance tags and detailed breakdown | `search_metadata`, `get_entity_lineage` | Risk mitigation, compliance automation | Privacy impact assessments |
| **⚡ Impact Analysis** | Change management | "What would break if I modify the user_id column in the users table?" | Shows 5 direct impacts (FK constraints), 12 downstream dashboards affected with migration plan recommendation | `get_entity_lineage`, `get_entity_details` | Reduced deployment risks, change planning | Database schema evolution |
| **🔍 Data Discovery** | Data exploration | "Find all tables containing customer data" | Comprehensive catalog search with filtering, tagging, and metadata context | `search_metadata` | Faster data onboarding, improved productivity | Self-service analytics |
| **📝 Governance Setup** | Business context creation | "Create a glossary for financial terms and add key definitions" | Creates structured glossary with hierarchical terms, ownership, and business context | `create_glossary`, `create_glossary_term` | Better data understanding, standardized definitions | Business vocabulary management |
| **🔧 Metadata Management** | Administrative tasks | "Update descriptions and tags for all customer-related tables" | Bulk metadata updates with validation and change tracking | `patch_entity`, `search_metadata` | Improved data documentation, consistency | Metadata maintenance automation |
| **📈 Quality Analysis** | Data health assessment | "Show me data quality trends and ownership gaps" | Comprehensive quality metrics, ownership analysis, and actionable recommendations | `search_metadata`, `get_entity_details` | Proactive quality management, ownership clarity | Data stewardship programs |

### Detailed Implementation Examples

| Use Case | Complete Interaction Flow | Technical Details |
|----------|---------------------------|-------------------|
| **Pipeline Monitoring** | User: "Monitor our data pipelines" → AI: Scans pipeline entities → Returns status with health indicators → Offers investigation options for failures | Uses `search_metadata` with entity_type='pipeline', then `get_entity_details` for status information |
| **GDPR Compliance** | User: "Find customer data for GDPR" → AI: Searches for PII-tagged entities → Analyzes data sensitivity → Categorizes by risk level → Generates compliance report | Combines `search_metadata` for PII discovery with `get_entity_lineage` for data flow analysis |
| **Impact Analysis** | User: "What breaks if I modify user_id?" → AI: Traces column dependencies → Maps downstream impacts → Identifies affected dashboards → Suggests migration strategy | Uses `get_entity_lineage` with column-level granularity, upstream_depth=3, downstream_depth=5 |
| **Dashboard Generation** | User: "Create quality dashboard" → AI: Discovers quality metrics → Aggregates completeness scores → Identifies trends → Proposes visualization config | Leverages `search_metadata` for quality entities and `get_entity_details` for metric extraction |

---

## OpenMetadata vs DataHub

### Feature Comparison

| Feature | OpenMetadata MCP | DataHub MCP |
|---------|------------------|-------------|
| **MCP Server** | ✅ Built-in (v1.8.0+) | ✅ External ([mcp-server-datahub](https://github.com/acryldata/mcp-server-datahub)) |
| **Architecture** | Embedded in core | Separate project |
| **Authentication** | Integrated OAuth/JWT | API Token-based |
| **Transport** | SSE + Streamable HTTP | REST API |
| **Real-time Updates** | ✅ Native streaming | ✅ Polling-based |
| **Column-level Lineage** | ✅ Native support | ✅ Available |
| **Data Quality Integration** | ✅ Built-in quality framework | ✅ External quality tools |
| **Glossary Management** | ✅ Rich business glossary | ✅ Business glossary |
| **Auto-classification** | ✅ ML-powered tagging | ✅ Policy-based tagging |
| **Change Management** | ✅ Version control integration | ✅ Change tracking |
| **Maturity** | 🟡 New (v1.8.0+) | 🟡 Community project |
| **Setup Complexity** | ✅ Simple (all-in-one) | 🔄 Complex (multiple components) |

### Architecture Comparison

| Aspect | OpenMetadata MCP | DataHub MCP |
|--------|------------------|-------------|
| **Integration Type** | ✅ Embedded Architecture | ✅ External Server Architecture |
| **Server Location** | MCP server built into OpenMetadata core | Separate mcp-server-datahub project |
| **Auth Engine** | Same authentication & authorization engine | API-based communication |
| **Data Access** | Direct access to metadata graph | Independent deployment |
| **Communication** | Real-time streaming via SSE | REST API integration |

### Maturity & Ecosystem

| Aspect | OpenMetadata | DataHub |
|--------|--------------|---------|
| **MCP Maturity** | 🟡 New (v1.8.0+) | 🟡 Community project |
| **Documentation** | ✅ Official guides | ✅ Community docs |
| **Community Support** | ✅ Active Slack community | ✅ Large community |
| **Enterprise Features** | ✅ Built-in enterprise features | ✅ Commercial support available |
| **Ecosystem Size** | 🔄 Growing (~7.1k stars) | ✅ Mature (~10.8k stars) |

### When to Choose

| Choose OpenMetadata MCP If | Choose DataHub MCP If |
|---------------------------|----------------------|
| ✅ Want unified, all-in-one metadata platform | ✅ Need maximum flexibility and customization |
| ✅ Prefer embedded MCP with tight integration | ✅ Have existing DataHub investments |
| ✅ Need modern UI/UX and active development | ✅ Want battle-tested enterprise solution |
| ✅ Want built-in data quality and governance | ✅ Need extensive connector ecosystem |
| ✅ Prefer simple setup and maintenance | ✅ Want LinkedIn's production-grade architecture |
| ✅ Need strong collaboration features | ✅ Require complex data modeling capabilities |

### Pros & Cons Summary

| Platform | Pros | Cons |
|----------|------|------|
| **OpenMetadata** | Unified platform, built-in integration, modern UI, easy setup | Newer platform, smaller ecosystem, recent MCP addition |
| **DataHub** | Battle-tested, mature ecosystem, flexible architecture, large community | Complex setup, external MCP server, aging UI, resource heavy |

---

## Setup Guide

### Prerequisites

| Requirement | Details |
|-------------|---------|
| **OpenMetadata** | v1.8.0+ (MCP support) |
| **AI Tools** | Claude Desktop, VS Code + Copilot, Cursor IDE |
| **Access** | Admin rights to install MCP Application |

### Quick Setup Steps

| Step | Action | Details |
|------|--------|---------|
| **1. Enable MCP** | Settings → Apps → MCP Application → Install | Configure origin validation if needed |
| **2. Create Token** | `/users/admin/access-token` → Generate New Token | Copy securely, set 60-day expiration |
| **3. Configure Tools** | Add MCP server config to AI tools | See platform-specific configs below |
| **4. Test Connection** | Run test queries in AI tool | Verify tools are available |

### Platform Configurations

#### Claude Desktop (`claude_desktop_config.json`)

```json
{
  "mcpServers": {
    "openmetadata": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "http://localhost:8585/mcp/sse",
               "--auth-server-url=http://localhost:8585/mcp",
               "--client-id=openmetadata", "--verbose", "--clean",
               "--header", "Authorization:${AUTH_HEADER}"],
      "env": { "AUTH_HEADER": "Bearer YOUR_OPENMETADATA_PAT_TOKEN" }
    }
  }
}
```

#### VS Code (`.vscode/mcp.json` or User Config)

```json
{
  "servers": {
    "OpenMetadata": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "mcp-remote", "http://localhost:8585/mcp/sse",
               "--auth-server-url=http://localhost:8585/mcp",
               "--client-id=openmetadata"],
      "env": { "AUTH_HEADER": "Bearer YOUR_OPENMETADATA_PAT_TOKEN" }
    }
  }
}
```

#### Alternative VS Code Setup Methods

| Method | Steps |
|--------|-------|
| **Command Palette** | Run `MCP: Add Server` → Choose `stdio` type → Fill server details → Select Workspace/Global |
| **User Configuration** | Run `MCP: Open User Configuration` → Add server config → Personal setup |
| **Auto-discovery** | Enable auto-discovery to import from Claude Desktop configs |

### Advanced VS Code Features

| Feature | Description | Usage |
|---------|-------------|-------|
| **MCP Server Management** | View, start, stop, restart servers | `MCP: Show Installed Servers` in Extensions view |
| **Server Actions** | Right-click server management | Right-click servers for start/stop/restart/configure |
| **Output Logs** | Debug MCP server issues | `MCP: Show Output` for debugging |
| **Browse Resources** | Explore available data | `MCP: Browse Resources` to explore data |
| **Settings Sync** | Sync configs across devices | Enable Settings Sync → Include "MCP Servers" |

#### Auto-discovery Configuration

```json
{
  "chat.mcp.discovery.enabled": true
}
```

### VS Code Usage

| Action | Steps |
|--------|-------|
| **Enable Agent Mode** | Chat view (`Ctrl+Cmd+I`) → Agent mode → Tools button |
| **Select Tools** | Tools picker → Enable OpenMetadata tools (max 128) |
| **Use MCP** | Natural language queries: "What tables do you have?" |
| **Direct Tool Reference** | `#toolname` syntax for specific tools |
| **Add Context** | Add Context → MCP Resources for data context |
| **Use Prompts** | `/mcp.openmetadata.promptname` for templates |

---

## Troubleshooting

### Comprehensive Troubleshooting Matrix

| Issue Category | Specific Issue | Symptoms | Quick Fixes | Detailed Solutions | Debug Commands |
|----------------|----------------|----------|-------------|-------------------|----------------|
| **Connection** | MCP server not responding | Server connection timeout, no tool access | Check OpenMetadata running, MCP app installed, token valid | Verify OpenMetadata accessible at `http://localhost:8585`, ensure MCP Application installed (Settings → Apps → MCP Application), check network connectivity, validate firewall rules | `npx -y mcp-remote http://localhost:8585/mcp/sse --header "Authorization:Bearer TOKEN" --verbose --clean` |
| **Authentication** | Auth failures | 401/403 responses, permission denied | Regenerate token, check "Bearer " prefix, verify permissions | Create new Personal Access Token, ensure "Bearer " prefix in auth header, verify user permissions in OpenMetadata, check token expiration | `curl -H "Authorization: Bearer TOKEN" http://localhost:8585/api/v1/users/me` |
| **Claude Desktop** | Tools not visible | No MCP tools appearing in Claude | Restart Claude, check config syntax, verify file location | Restart Claude Desktop completely, validate `claude_desktop_config.json` syntax, check file location and permissions, enable developer mode | Verify config file location and restart Claude Desktop |
| **VS Code** | Tools not showing | MCP features unavailable, tools not in agent mode | Ensure v1.102+, check MCP enabled, verify config syntax | Update VS Code to v1.102+, verify MCP enabled in organization policies, check `.vscode/mcp.json` syntax, use `MCP: Show Installed Servers` | Command Palette: `MCP: Show Output`, `MCP: List Servers` |
| **Tool Limits** | Too many tools error | "Cannot have >128 tools" message | Reduce enabled tools, use tool sets, reference specific tools | Deselect unnecessary MCP servers, reduce enabled tools in agent mode, use tool sets for grouping, reference tools with `#toolname` | Check active tool count in VS Code agent mode |
| **Network** | Connection timeouts | Slow responses, intermittent failures | Check firewall rules, verify DNS resolution, test connectivity | Check firewall rules, verify DNS resolution, test network connectivity, consider VPN for remote access | `curl -v http://localhost:8585/api/v1/health` |
| **Token Issues** | Intermittent auth failures | Sporadic permission errors | Set up token monitoring, use 60-day tokens, implement renewal | Set up token expiration monitoring, use 60-day tokens, implement auto-renewal process | `curl -H "Authorization: Bearer TOKEN" http://localhost:8585/api/v1/apps/name/McpApplication` |
| **Performance** | Slow MCP responses | Delayed tool execution, timeouts | Monitor server resources, optimize queries, check database | Monitor OpenMetadata server resources, implement query optimization, check database performance, scale infrastructure | `docker logs openmetadata_server` |
| **Tool Discovery** | Tools not appearing | Available tools not showing | Verify tool definitions, check capabilities, validate permissions | Verify tool definitions in `tools.json`, check server capabilities, validate user permissions for tools | `curl -X POST http://localhost:8585/mcp -H "Authorization: Bearer TOKEN" -d '{"jsonrpc":"2.0","method":"tools/list"}'` |
| **Transport** | HTTP vs SSE issues | Connection method problems | Test alternative transport, verify endpoint | Test Streamable HTTP vs SSE transport, verify correct endpoint URLs | `curl -X POST http://localhost:8585/mcp -H "Authorization: Bearer TOKEN" -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":"test","method":"initialize"}'` |

---

## Best Practices

### Security

| Practice | Implementation | Detailed Guidance |
|----------|----------------|------------------|
| **Token Management** | Use 30-60 day expiration, rotate regularly, store in env vars | Create dedicated service accounts for MCP access, implement automated token rotation, never commit tokens to version control, use secure secret management |
| **Access Control** | Create dedicated service accounts, apply least privilege, use RBAC | Create MCP-specific service accounts, grant minimum required permissions, implement role-based access control, monitor access patterns |
| **Network Security** | Use HTTPS in production, implement firewalls, monitor traffic | Enable HTTPS for production deployments, configure network firewalls, consider VPN for remote access, implement network traffic monitoring |

### Performance

| Area | Best Practices | Implementation Details |
|------|----------------|----------------------|
| **Queries** | Use specific queries vs broad searches, implement caching, limit result sets | Prefer specific entity queries over broad searches, implement result caching where appropriate, use pagination for large datasets, optimize query patterns |
| **Resources** | Monitor MCP server usage, configure timeouts, implement rate limiting | Monitor OpenMetadata server resources, configure appropriate request timeouts, implement rate limiting for heavy usage, scale infrastructure as needed |

### Operations

| Category | Practices | Implementation |
|----------|-----------|----------------|
| **Monitoring** | Health checks, auth failure alerts, query performance tracking | Set up MCP server health checks, monitor authentication failures, track query performance in VS Code agent mode, implement service disruption alerts |
| **Configuration** | Version control configs, use Settings Sync, document setups | Version control `.vscode/mcp.json` files, use Settings Sync for user configurations, document MCP server configurations, manage configs in Dev Containers |
| **Team Collaboration** | Share workspace configs, consistent naming, document patterns | Share workspace MCP configs via `.vscode/mcp.json`, use consistent server naming conventions, document team MCP usage patterns, create reusable prompt files |

### Usage Patterns

| Pattern | Good Example | Avoid | Best Practices |
|---------|--------------|-------|----------------|
| **Specific Queries** | "Show tables in sales database with customer data" | "Show me everything" | Provide context, use specific entity types, include relevant filters |
| **Tool Selection** | Enable only needed tools (stay under 128 limit) | Enable all available tools | Strategic tool selection, use tool sets for workflows, reference tools directly with `#toolname` |
| **Context Requests** | "Find PII data for GDPR compliance with retention policies" | "Find some data" | Include business context, specify compliance requirements, mention specific use cases |
| **Iterative Exploration** | Start broad → narrow down → specific details | Random queries | Begin with discovery, progressively narrow scope, use previous results to guide next queries |

### Additional Best Practices

| Category | Practice | Details |
|----------|----------|---------|
| **Backup & Recovery** | Regular OpenMetadata backups, document configurations | Implement regular OpenMetadata backups, document MCP configurations, test disaster recovery procedures, version control configurations |
| **Team Setup** | Standardized configurations, shared documentation | Create team-wide MCP configuration standards, maintain shared documentation, implement onboarding procedures for new team members |
| **Monitoring & Alerting** | Proactive monitoring, performance tracking | Monitor MCP server performance, track usage patterns, implement alerting for failures, regular health checks |
| **Development Workflow** | Integration with CI/CD, testing procedures | Integrate MCP configs with CI/CD pipelines, implement testing procedures for MCP functionality, maintain development environment consistency |

### Tool Discovery Best Practices

| Practice | Implementation |
|----------|----------------|
| **Start with Discovery** | Always check what tools are actually available first, verify tool capabilities before complex workflows |
| **Test Gradually** | Try simple operations before complex workflows, validate permissions and access patterns |
| **Check Permissions** | Ensure your OpenMetadata user has necessary access, verify RBAC settings for tool usage |
| **Monitor Logs** | Use MCP server output to debug tool issues, track performance and error patterns |

---

## Additional Resources

### Official Documentation

| Resource | Link |
|----------|------|
| **OpenMetadata MCP Docs** | [docs.open-metadata.org/latest/how-to-guides/mcp](https://docs.open-metadata.org/latest/how-to-guides/mcp) |
| **VS Code MCP Docs** | [code.visualstudio.com/docs/copilot/chat/mcp-servers](https://code.visualstudio.com/docs/copilot/chat/mcp-servers) |
| **MCP Specification** | [modelcontextprotocol.io](https://modelcontextprotocol.io/) |

### Community & Support

| Resource | Purpose |
|----------|---------|
| **OpenMetadata Slack** | [#mcp channel](https://slack.open-metadata.org/) |
| **GitHub Repository** | [OpenMetadata/OpenMetadata](https://github.com/open-metadata/OpenMetadata) |
| **Community Forums** | [GitHub Discussions](https://github.com/open-metadata/OpenMetadata/discussions) |

---

*Last updated: July 17, 2025 | OpenMetadata v1.8.0+ | VS Code v1.102+ | MCP Protocol v2024-11-05*
