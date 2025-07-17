# OpenMetadata MCP (Model Context Protocol) - Comprehensive Guide

A complete guide to setting up and using OpenMetadata's integrated MCP server with Claude Desktop, VS Code with GitHub Copilot, and other AI tools.

## 📖 Table of Contents

1. [What is MCP?](#what-is-mcp)
2. [OpenMetadata MCP Overview](#openmetadata-mcp-overview)
3. [Supported Tools & Integrations](#supported-tools--integrations)
4. [MCP Capabilities & Features](#mcp-capabilities--features)
5. [Use Cases & Examples](#use-cases--examples)
6. [OpenMetadata vs DataHub MCP](#openmetadata-vs-datahub-mcp)
7. [Pros and Cons](#pros-and-cons)
8. [Setup Guide](#setup-guide)
9. [Troubleshooting](#troubleshooting)
10. [Best Practices](#best-practices)

---

## What is MCP?

**Model Context Protocol (MCP)** is an open standard that enables AI models and tools to securely access and interact with external data sources and systems. It provides a standardized way for:

- **AI Models** (Claude, GPT, etc.) to connect to data platforms
- **Tools** (VS Code, Claude Desktop, Cursor, etc.) to integrate with metadata systems
- **Secure data access** with proper authentication and authorization
- **Real-time data interaction** for enhanced AI capabilities

### Key Benefits of MCP:
- 🔐 **Secure Authentication** - Token-based access control
- 🔄 **Real-time Integration** - Live data access, not static exports
- 🛠️ **Tool Agnostic** - Works with multiple AI platforms and tools
- 📊 **Rich Context** - Provides deep metadata context to AI models

---

## OpenMetadata MCP Overview

OpenMetadata v1.8.0+ includes a **fully integrated MCP server** that leverages OpenMetadata's unified metadata graph to provide AI models with rich context about your data ecosystem.

### MCP Transport Methods

OpenMetadata supports **two MCP transport protocols**:

1. **SSE (Server-Sent Events)** - `http://localhost:8585/mcp/sse`
   - Real-time streaming communication
   - Best for most AI tools and integrations
   - Recommended for Claude Desktop and VS Code

2. **Streamable HTTP** - `http://localhost:8585/mcp`
   - HTTP-based request/response
   - Alternative for tools that don't support SSE
   - Supports origin header validation for security

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

### Technical Implementation

**MCP Server Components:**
- **MCPStreamableHttpServlet** - Handles HTTP-based MCP communication (`/mcp`)
- **HttpServletSseServerTransportProvider** - Manages SSE transport (`/mcp/sse`) 
- **DefaultToolContext** - Executes MCP tool calls with proper authorization
- **McpAuthFilter** - Handles authentication and JWT token validation
- **MCPConfiguration** - Manages server settings and origin validation

**Protocol Support:**
- **JSON-RPC 2.0** - Standard messaging protocol
- **MCP Protocol Version** - `2024-11-05` (latest specification)
- **Server Capabilities** - Tools, prompts, and resources support
- **Session Management** - Persistent sessions with unique session IDs

**Security Architecture:**
- **Same Auth Engine** - Uses OpenMetadata's existing JWT/OAuth system
- **RBAC Integration** - Respects user roles and permissions
- **Token Validation** - All requests validated through JwtFilter
- **Origin Validation** - Optional CORS protection for Streamable HTTP

### Key Features:
- ✅ **Embedded MCP Server** - Built directly into OpenMetadata
- ✅ **Same Authorization Engine** - Uses OpenMetadata's existing security model
- ✅ **Complete Metadata Access** - Full access to your data catalog
- ✅ **Real-time Updates** - Live data and lineage information
- ✅ **Role-based Access** - Respects user permissions and policies

---

## Supported Tools & Integrations

### ✅ Officially Supported

| Tool | Status | Features | Configuration |
|------|--------|----------|---------------|
| **Claude Desktop** | ✅ Full Support | Complete metadata access, search, lineage | `claude_desktop_config.json` |
| **VS Code + GitHub Copilot** | ✅ Full Support | Agent mode, tools, resources, prompts | `.vscode/mcp.json` |
| **Cursor IDE** | ✅ Full Support | AI-powered code assistance | MCP server config |
| **OpenAI GPT** | ✅ Compatible | API-based integration | REST API |

### 🛠️ VS Code Integration Details

**MCP Support Features in VS Code:**
- ✅ **Agent Mode** - AI assistant with tool access
- ✅ **Tool Selection** - Enable/disable specific MCP tools
- ✅ **MCP Resources** - Add data context to prompts
- ✅ **MCP Prompts** - Predefined prompt templates
- ✅ **Settings Sync** - Synchronize MCP configs across devices
- ✅ **Dev Container Support** - MCP in containerized environments
- ✅ **Auto-discovery** - Detect MCP servers from other tools

**Configuration Options:**
- 📁 **Workspace Config** - `.vscode/mcp.json` (team sharing)
- 👤 **User Config** - Global settings (personal)
- 🐳 **Dev Container** - `devcontainer.json` integration
- 🔍 **Auto-discovery** - Import from Claude Desktop configs

### 🔄 Community Supported

| Tool | Status | Notes |
|------|--------|-------|
| **Goose Desktop** | 🔄 Experimental | Community-maintained |
| **Continue.dev** | 🔄 In Progress | VS Code extension |
| **Cody** | 🔄 Planned | Sourcegraph integration |

### 🛠️ Integration Methods

1. **Desktop Applications** - Direct MCP server connection
2. **VS Code Extensions** - Through native MCP protocol (v1.102+)
3. **Dev Containers** - MCP configuration in `devcontainer.json`
4. **API Integration** - REST API with MCP compatibility
5. **Custom Tools** - Using MCP SDK/libraries
6. **Auto-discovery** - Automatic detection from other MCP tools

---

## MCP Capabilities & Features

### 🛠️ Available OpenMetadata MCP Tools

---

## MCP Capabilities & Features

### 🛠️ Available OpenMetadata MCP Tools

OpenMetadata's MCP server currently provides **6 core tools** for interacting with your metadata catalog.

#### **🔢 Current Tool Count: 6 Tools**

Your OpenMetadata MCP server exposes **6 tools** that provide essential metadata management capabilities. Here are the exact tools available:

| Tool Name | Description | Primary Function | Parameters |
|-----------|-------------|------------------|------------|
| `search_metadata` | Search across all metadata entities (tables, databases, dashboards, pipelines, etc.) | 🔍 **Search & Discovery** | `query`, `entity_type`, `limit` |
| `get_entity_details` | Get detailed information about specific entities by entity type and FQN | 📊 **Entity Details** | `entity_type`, `fqn` |
| `get_entity_lineage` | Get upstream and downstream lineage for entities with configurable depth | 🔗 **Lineage Analysis** | `entity_type`, `fqn`, `upstream_depth`, `downstream_depth` |
| `create_glossary` | Create new business glossaries with descriptions, ownership, and mutual exclusivity settings | 📝 **Governance Setup** | `name`, `description`, `mutuallyExclusive`, `owners`, `reviewers` |
| `create_glossary_term` | Create glossary terms within existing glossaries, supporting hierarchical relationships | 📝 **Documentation** | `glossary`, `name`, `description`, `parentTerm`, `owners` |
| `patch_entity` | Update/patch entity metadata using JSONPatch format for fine-grained modifications | ⚙️ **Entity Management** | `entityType`, `entityFqn`, `patch` |

#### **🛠️ Tool Implementation Details**

**Authentication & Authorization:**
- All tools require proper authentication via OpenMetadata Personal Access Token
- Tools respect OpenMetadata's role-based access control (RBAC)
- Authorization is handled through the same engine as the OpenMetadata UI

**Tool Execution Context:**
- Tools are executed within `DefaultToolContext` class
- Each tool call includes proper security context and user permissions
- Rate limiting and resource controls are applied via OpenMetadata's `Limits` framework

**Tool Definition:**
- Tools are defined in `json/data/mcp/tools.json` within the OpenMetadata server
- Each tool specifies its parameters schema using JSON Schema format
- Tool implementations are loaded at server startup via `McpUtils.getToolProperties()`

#### **📝 MCP Prompts Support**

In addition to tools, OpenMetadata's MCP server also supports **prompts** for enhanced AI interactions:

**Prompt Features:**
- **Predefined Templates** - Ready-to-use prompts for common metadata tasks
- **Parameterized Prompts** - Dynamic prompts that accept arguments
- **Context-aware** - Prompts that leverage OpenMetadata's metadata context

**Prompt Definition:**
- Prompts are defined in `json/data/mcp/prompts.json` 
- Loaded via `DefaultPromptsContext.loadPromptsDefinitionsFromJson()`
- Accessible through MCP protocol's `prompts/get` and `prompts/list` methods

**Usage in VS Code:**
- Use `/mcp.openmetadata.promptname` syntax to invoke prompts
- Available in agent mode and MCP resources
- Prompts can be combined with tools for complex workflows

#### **👁️ How to View Your Specific 6 Tools**

**In VS Code Agent Mode:**
1. Open Chat view (`Ctrl+Cmd+I` on Mac, `Ctrl+Alt+I` on Windows/Linux)
2. Select **Agent mode** from the dropdown
3. Click **Tools** button to see all available MCP tools
4. Enable the specific OpenMetadata tools you need (all 6 or a subset)
5. Use natural language to interact with your metadata catalog

**Example Queries with Actual Tools:**
```
"Search for all tables containing customer data" (uses search_metadata)
"Show me the lineage for table 'user_profiles'" (uses get_entity_lineage)
"Get details about the sales database" (uses get_entity_details)
"Create a glossary for financial terms" (uses create_glossary)
"Add a new term 'Customer Lifetime Value'" (uses create_glossary_term)
"Update the description of the users table" (uses patch_entity)
```

**Tool Capabilities Summary:**
- `search_metadata` - Find entities by keywords, filter by type, set result limits
- `get_entity_details` - Retrieve comprehensive entity information by FQN
- `get_entity_lineage` - Trace data lineage with upstream/downstream depth control
- `create_glossary` - Set up business glossaries with ownership settings
- `create_glossary_term` - Add terms to glossaries with hierarchical relationships
- `patch_entity` - Modify entity properties using JSONPatch operations

> **Note**: These are the actual 6 tools available in your running OpenMetadata MCP server (confirmed working).

### 🔍 Discovering Available OpenMetadata MCP Tools

OpenMetadata's MCP server provides tools for interacting with your metadata catalog. The exact tools available depend on your OpenMetadata version and configuration.

#### **How to Find Available Tools**

1. **In VS Code Agent Mode:**
   - Open Chat view (`Ctrl+Cmd+I` on Mac, `Ctrl+Alt+I` on Windows/Linux)
   - Select **Agent mode** from the dropdown
   - Click **Tools** button to see all available MCP tools
   - Look for tools prefixed with your OpenMetadata server name

2. **Using VS Code Commands:**
   ```bash
   # Command Palette options:
   MCP: Browse Resources
   MCP: List Servers
   MCP: Show Installed Servers
   ```

3. **In Claude Desktop:**
   - After successful MCP connection, ask: "What tools do you have available from OpenMetadata?"
   - The AI will list the actual tools provided by your OpenMetadata MCP server

4. **Direct MCP Server Testing:**
   ```bash
   # Test connection and see available capabilities
   npx -y mcp-remote http://localhost:8585/mcp/sse 
     --auth-server-url=http://localhost:8585/mcp 
     --client-id=openmetadata 
     --header "Authorization:Bearer YOUR_TOKEN" 
     --verbose
   ```

#### **Expected Tool Categories**

Based on OpenMetadata's architecture, the MCP server typically provides tools for:

- **🔍 Search & Discovery** - Finding and exploring metadata entities
- **📊 Lineage Analysis** - Understanding data flow and dependencies  
- **📈 Data Quality** - Accessing quality metrics and test results
- **👥 Governance** - Managing ownership, tags, and compliance
- **📝 Documentation** - Working with descriptions and glossary terms
- **🔄 Operations** - Pipeline status and usage analytics

#### **Tool Usage Notes**

- **Tool Names**: Actual tool names depend on OpenMetadata's MCP implementation
- **Capabilities**: Each tool's functionality is defined by OpenMetadata's API
- **Permissions**: Tool availability depends on your user permissions in OpenMetadata
- **Version**: Available tools may vary between OpenMetadata versions

### 📖 **Tool Discovery Best Practices**

1. **Start with Discovery**: Always check what tools are actually available first
2. **Test Gradually**: Try simple operations before complex workflows
3. **Check Permissions**: Ensure your OpenMetadata user has necessary access
4. **Monitor Logs**: Use MCP server output to debug tool issues

### 🔍 Data Discovery & Search

```python
# Example MCP interactions
"Find all tables related to customer data"
"Show me the lineage for table 'user_profiles'"  
"What are the most recent changes to our data warehouse?"
```

**Available Operations:**
- Search tables, databases, dashboards, pipelines
- Filter by tags, owners, domains
- Advanced metadata queries
- Column-level search and discovery

### 📊 Metadata Analysis

```python
# Metadata insights
"Analyze data quality metrics for our sales tables"
"Show ownership gaps in our data assets"
"Generate a summary of our data governance status"
```

**Capabilities:**
- Data quality assessment
- Ownership analysis
- Usage statistics
- Governance compliance checks

### 🔄 Lineage & Dependencies

```python
# Lineage exploration
"Show me the upstream dependencies of table X"
"What would be impacted if I change column Y?"
"Trace data flow from source to dashboard"
```

**Features:**
- Column-level lineage tracking
- Impact analysis
- Root cause analysis
- Dependency mapping

### 📝 Documentation & Glossary

```python
# Documentation assistance
"Create glossary terms for our financial data"
"Generate documentation for table schemas"
"Add business context to data assets"
```

**Operations:**
- Auto-generate documentation
- Create and manage glossary terms
- Add tags and classifications
- Business context enrichment

### 🎛️ Data Governance

```python
# Governance operations
"Check compliance status of PII data"
"Apply data classification tags"
"Review access policies for sensitive tables"
```

**Governance Features:**
- Policy management
- Access control reviews
- Compliance monitoring
- Risk assessment

---

## Use Cases & Examples

### 1. **Intelligent Pipeline Monitoring**

```python
User: "Monitor our data pipelines and alert me about any failures"

AI Response: "I can see 3 active pipelines in OpenMetadata:
- Customer ETL Pipeline: ✅ Running (Last success: 2 hours ago)
- Sales Data Sync: ⚠️ Warning (High memory usage)
- ML Feature Pipeline: ❌ Failed (Error in transform step)

Would you like me to investigate the failed pipeline?"
```

### 2. **Automated Dashboard Generation**

```python
User: "Create a dashboard showing our data quality metrics"

AI Response: "Based on your OpenMetadata data quality tests, I'll create a dashboard with:
- Table completeness scores across all databases
- Data freshness trends for critical tables  
- Schema validation results
- Top 10 tables with quality issues

Shall I generate the dashboard configuration?"
```

### 3. **Data Discovery & Exploration**

```python
User: "I need to find all customer-related data for GDPR compliance"

AI Response: "Found 23 tables containing customer data:

🔴 High Risk (PII):
- users.customer_profiles (SSN, email, phone) - Tagged: PII, GDPR_CRITICAL
- payments.billing_info (credit card data) - Tagged: PCI_DSS, SENSITIVE

🟡 Medium Risk:
- analytics.user_behavior (user IDs, IP addresses) - Tagged: ANALYTICS, PII_INDIRECT  
- marketing.campaigns (email preferences) - Tagged: MARKETING, GDPR

Would you like me to generate a GDPR compliance report?"
```

### 4. **Impact Analysis**

```python
User: "What would break if I modify the user_id column in the users table?"

AI Response: "⚠️ CRITICAL IMPACT DETECTED:

Direct Impact (5 tables):
- orders.user_orders (FK constraint)
- analytics.user_sessions (joins)
- recommendations.user_prefs (references)

Downstream Impact (12 dashboards):
- Sales Performance Dashboard
- User Analytics Dashboard  
- Recommendation Engine Metrics

I recommend creating a migration plan. Shall I draft one?"
```

---

## OpenMetadata vs DataHub MCP

### Feature Comparison

| Feature | OpenMetadata MCP | DataHub MCP |
|---------|------------------|-------------|
| **MCP Server** | ✅ Built-in (v1.8.0+) | ✅ External ([mcp-server-datahub](https://github.com/acryldata/mcp-server-datahub)) |
| **Authentication** | ✅ Integrated OAuth/JWT | ✅ API Token-based |
| **Real-time Updates** | ✅ SSE (Server-Sent Events) | ✅ REST API polling |
| **Column-level Lineage** | ✅ Native support | ✅ Available |
| **Data Quality Integration** | ✅ Built-in quality framework | ✅ External quality tools |
| **Glossary Management** | ✅ Rich business glossary | ✅ Business glossary |
| **Auto-classification** | ✅ ML-powered tagging | ✅ Policy-based tagging |
| **Change Management** | ✅ Version control integration | ✅ Change tracking |

### Architecture Differences

#### OpenMetadata MCP
```
✅ Embedded Architecture
- MCP server built into OpenMetadata core
- Same authentication & authorization engine
- Direct access to metadata graph
- Real-time streaming via SSE
```

#### DataHub MCP  
```
✅ External Server Architecture
- Separate mcp-server-datahub project
- API-based communication
- Independent deployment
- REST API integration
```

### Maturity & Ecosystem

| Aspect | OpenMetadata | DataHub |
|--------|--------------|---------|
| **MCP Maturity** | 🟡 New (v1.8.0+) | 🟡 Community project |
| **Documentation** | ✅ Official guides | ✅ Community docs |
| **Community Support** | ✅ Active Slack community | ✅ Large community |
| **Enterprise Features** | ✅ Built-in enterprise features | ✅ Commercial support available |
| **Ecosystem Size** | 🔄 Growing (~7.1k stars) | ✅ Mature (~10.8k stars) |

### When to Choose OpenMetadata MCP

✅ **Choose OpenMetadata if:**
- You want a unified, all-in-one metadata platform
- You need built-in data quality and governance features
- You prefer embedded MCP with tight integration
- You want modern UI/UX and active development
- You need strong collaboration features

### When to Choose DataHub MCP

✅ **Choose DataHub if:**
- You need maximum flexibility and customization
- You have existing DataHub investments
- You prefer battle-tested, enterprise-proven solutions
- You need extensive connector ecosystem
- You want LinkedIn's production-grade architecture

---

## Pros and Cons

### OpenMetadata MCP

#### ✅ Pros
- **Unified Platform** - Everything in one place (catalog, quality, governance)
- **Built-in Integration** - No separate MCP server to maintain
- **Modern Architecture** - Real-time updates via SSE
- **Rich UI/UX** - Intuitive web interface
- **Active Development** - Frequent releases and new features
- **Strong Community** - Growing ecosystem and support
- **Comprehensive Features** - Data quality, observability, governance built-in
- **Easy Setup** - Simple installation and configuration

#### ❌ Cons
- **Newer Platform** - Less battle-tested than DataHub
- **Smaller Ecosystem** - Fewer third-party integrations
- **MCP Recent Addition** - MCP support is relatively new (v1.8.0+)
- **Learning Curve** - Different concepts from traditional catalogs
- **Resource Requirements** - Can be resource-intensive for large deployments

### DataHub MCP

#### ✅ Pros
- **Battle-tested** - Proven at LinkedIn scale
- **Mature Ecosystem** - Extensive connectors and integrations
- **Flexible Architecture** - Highly customizable and extensible
- **Large Community** - Established user base and contributors
- **Enterprise Ready** - Production-proven at many companies
- **Rich Metadata Model** - Comprehensive data modeling
- **Strong Documentation** - Extensive guides and examples

#### ❌ Cons
- **Complex Setup** - More moving parts and configuration
- **External MCP Server** - Additional component to deploy and maintain
- **UI/UX Aging** - Interface feels dated compared to modern tools
- **Development Pace** - Slower release cycle
- **Java/Python Mix** - Multiple technology stacks to manage
- **Resource Heavy** - Can be complex for smaller organizations

---

## Setup Guide

### Prerequisites

- **OpenMetadata v1.8.0+** - [Upgrade guide](https://docs.open-metadata.org/latest/deployment/upgrade)
- **AI Tool of Choice**:
  - [Claude Desktop](https://claude.ai/download)
  - VS Code with GitHub Copilot
  - Cursor IDE
  - Any MCP-compatible tool

### Step 1: Enable MCP in OpenMetadata

1. Navigate to your OpenMetadata instance: `http://localhost:8585`
2. Go to **Settings → Apps → MCP Application**
3. Click **Install** to enable the MCP server
4. Configure the MCP settings:
   - **Origin Validation Enabled**: Set to `false` for SSE transport or `true` for enhanced security
   - **Origin Header URI**: Required if validation is enabled (e.g., `https://yourapp.example.com`)
   - Submit the configuration

### Step 2: Create Personal Access Token

1. Go to `http://localhost:8585/users/admin/access-token`
2. Click **Generate New Token**
3. Set expiration (recommended: 60 days)
4. Copy the token securely

### Step 3: Configure AI Tools

#### For Claude Desktop

Create/edit `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "openmetadata": {
      "command": "npx",
      "args": [
        "-y",
        "mcp-remote",
        "http://localhost:8585/mcp/sse",
        "--auth-server-url=http://localhost:8585/mcp",
        "--client-id=openmetadata",
        "--verbose",
        "--clean",
        "--header",
        "Authorization:${AUTH_HEADER}"
      ],
      "env": {
        "AUTH_HEADER": "Bearer YOUR_OPENMETADATA_PAT_TOKEN"
      }
    }
  }
}
```

#### For VS Code with GitHub Copilot

**Prerequisites:**
- VS Code v1.102+ (MCP support is generally available)
- GitHub Copilot extension enabled
- Access to Copilot in VS Code

**Configuration Options:**

1.**User Configuration (Personal Setup)**

   Run `MCP: Open User Configuration` command and add:

   ```json
   {
     "servers": {
       "OpenMetadata": {
         "type": "stdio", 
         "command": "npx",
         "args": [
           "-y",
           "mcp-remote", 
           "http://localhost:8585/mcp/sse",
           "--auth-server-url=http://localhost:8585/mcp",
           "--client-id=openmetadata"
         ],
         "env": {
           "AUTH_HEADER": "Bearer YOUR_OPENMETADATA_PAT_TOKEN"
         }
       }
     }
   }
   ```

2. **Alternative: Add via Command Palette**
   - Run `MCP: Add Server` command
   - Choose `stdio` type
   - Fill in server details
   - Select Workspace or Global configuration

#### For Cursor IDE

Similar configuration in Cursor's settings with MCP server definition.

### Step 4: Use MCP in VS Code

1. **Enable Agent Mode**
   - Open Chat view (`Ctrl+Cmd+I` on Mac, `Ctrl+Alt+I` on Windows/Linux)
   - Select **Agent mode** from the dropdown
   - Click **Tools** button to see available MCP tools

2. **Select OpenMetadata Tools**
   - In the tools picker, find OpenMetadata tools
   - Enable/disable specific tools as needed
   - Maximum 128 tools can be active per chat request

3. **Start Using MCP**
   ```
   # Example prompts:
   "What tables do you have access to in OpenMetadata?"
   "Show me the lineage for table 'user_profiles'"
   "Find all tables with customer data for GDPR compliance"
   ```

4. **Direct Tool Reference**
   - Type `#` followed by tool name to reference directly
   - Works in all chat modes (ask, edit, agent)

5. **MCP Resources**
   - Use **Add Context > MCP Resources** to add data context
   - Browse available resources with `MCP: Browse Resources` command

6. **MCP Prompts**
   - Use `/mcp.openmetadata.promptname` for predefined prompts
   - Available prompts depend on OpenMetadata MCP server capabilities

### Step 5: Advanced VS Code MCP Features

#### **MCP Server Management**
- **View Servers**: `MCP: Show Installed Servers` in Extensions view
- **Server Actions**: Right-click servers to start/stop/restart/configure
- **Output Logs**: `MCP: Show Output` for debugging
- **Browse Resources**: `MCP: Browse Resources` to explore available data

#### **Settings Sync**
- Enable Settings Sync to synchronize MCP configs across devices
- Run `Settings Sync: Configure` and include "MCP Servers"
- Maintain consistent development environment across machines

#### **Dev Container Integration**
Add to your `devcontainer.json`:
```json
{
  "image": "mcr.microsoft.com/devcontainers/typescript-node:latest",
  "customizations": {
    "vscode": {
      "mcp": {
        "servers": {
          "OpenMetadata": {
            "type": "stdio",
            "command": "npx",
            "args": ["-y", "mcp-remote", "http://host.docker.internal:8585/mcp/sse"],
            "env": {
              "AUTH_HEADER": "Bearer ${localEnv:OPENMETADATA_TOKEN}"
            }
          }
        }
      }
    }
  }
}
```

#### **Auto-discovery**
Enable automatic detection of MCP servers:
```json
{
  "chat.mcp.discovery.enabled": true
}
```
This will detect OpenMetadata MCP configs from Claude Desktop and other tools.

---

## Troubleshooting

### Common Issues

#### 1. **MCP Connection Failed**

```bash
# Check OpenMetadata MCP server status (both transports)
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8585/mcp

# Test SSE endpoint
curl -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: text/event-stream" \
  http://localhost:8585/mcp/sse

# Verify token validity
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8585/api/v1/users/me

# Check if MCP Application is installed
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8585/api/v1/apps/name/McpApplication
```

**Solutions:**
- Verify OpenMetadata is running and accessible  
- Check that MCP Application is installed (Settings → Apps → MCP Application)
- Verify token expiration and permissions
- Ensure correct MCP endpoint URLs (SSE vs Streamable HTTP)
- Check network connectivity and firewall rules

#### 2. **Authentication Errors**

```bash
# Test token manually
export AUTH_TOKEN="your-token-here"
curl -H "Authorization: Bearer $AUTH_TOKEN" \
  http://localhost:8585/api/v1/tables
```

**Solutions:**
- Regenerate Personal Access Token
- Check token format (must include "Bearer " prefix)
- Verify user permissions in OpenMetadata
- Ensure token hasn't expired

#### 3. **Claude Desktop Not Recognizing MCP**

**Solutions:**
- Restart Claude Desktop completely
- Check `claude_desktop_config.json` syntax
- Verify file location and permissions
- Enable developer mode in Claude settings

#### 4. **VS Code MCP Extension Issues**

**Solutions:**
- Ensure VS Code v1.102+ (MCP generally available)
- Check if MCP is enabled in organization policies
- Verify `.vscode/mcp.json` syntax and location
- Use `MCP: Show Installed Servers` to check status
- Run `MCP: List Servers` for detailed server info
- Check MCP server output with `MCP: Show Output`

#### 5. **Tool Limits in VS Code**

**Error: "Cannot have more than 128 tools per request"**

**Solutions:**
- Reduce enabled tools in agent mode tools picker
- Deselect unnecessary MCP servers
- Use tool sets to group related tools
- Reference specific tools with `#toolname` syntax

#### 6. **VS Code Dev Container MCP Issues**

**Solutions:**
- Verify `devcontainer.json` MCP configuration
- Check container network connectivity to OpenMetadata
- Ensure MCP server dependencies are installed in container
- Validate environment variables in containerized environment

### Debug Commands

```bash
# Test MCP server directly (SSE transport)
npx -y mcp-remote http://localhost:8585/mcp/sse \
  --auth-server-url=http://localhost:8585/mcp \
  --client-id=openmetadata \
  --header "Authorization:Bearer YOUR_TOKEN" \
  --verbose

# Test Streamable HTTP transport  
curl -X POST http://localhost:8585/mcp \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":"test","method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test-client","version":"1.0.0"}}}'

# Check OpenMetadata server logs
docker logs openmetadata_server

# Verify MCP Application installation and configuration
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8585/api/v1/apps/name/McpApplication

# Check available tools list via MCP
curl -X POST http://localhost:8585/mcp \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -H "Mcp-Session-Id: test-session" \
  -d '{"jsonrpc":"2.0","id":"tools-test","method":"tools/list"}'

# VS Code specific debugging
# Check MCP server status in VS Code
# Command Palette: "MCP: List Servers"
# Command Palette: "MCP: Show Installed Servers" 
# Command Palette: "MCP: Show Output" (for specific server)

# Test VS Code MCP configuration
# Open .vscode/mcp.json and use editor lenses to start/stop servers
```

---

## Best Practices

### 🔐 Security

1. **Token Management**
   - Use short-lived tokens (30-60 days)
   - Rotate tokens regularly
   - Store tokens securely (environment variables)
   - Never commit tokens to version control

2. **Access Control**
   - Create dedicated service accounts for MCP
   - Apply principle of least privilege
   - Use role-based access control
   - Monitor token usage and access patterns

3. **Network Security**
   - Use HTTPS in production
   - Implement network firewalls
   - Consider VPN for remote access
   - Monitor network traffic

### 🚀 Performance

1. **Query Optimization**
   - Use specific queries instead of broad searches
   - Implement caching where appropriate
   - Limit result sets for large datasets
   - Use pagination for large responses

2. **Resource Management**
   - Monitor MCP server resource usage
   - Configure appropriate timeouts
   - Implement rate limiting
   - Scale OpenMetadata appropriately

### 📋 Operational

1. **Monitoring**
   - Set up health checks for MCP server
   - Monitor authentication failures
   - Track query performance in VS Code agent mode
   - Alert on service disruptions
   - Use VS Code's MCP server output logs

2. **Configuration Management**
   - Version control `.vscode/mcp.json` files
   - Use Settings Sync for user configurations
   - Document MCP server configurations
   - Manage MCP configs in Dev Containers
   - Enable auto-discovery for team consistency

3. **Backup & Recovery**
   - Regular OpenMetadata backups
   - Document MCP configurations
   - Test disaster recovery procedures
   - Version control configurations
   - Backup VS Code user settings

4. **Team Collaboration**
   - Share workspace MCP configs via `.vscode/mcp.json`
   - Use consistent server naming conventions
   - Document team MCP usage patterns
   - Create reusable prompt files with MCP tools
   - Set up tool sets for common workflows

### 🎯 Usage Patterns

1. **Efficient Queries**
   ```python
   # Good: Specific queries
   "Show me tables in the sales database with customer data"
   
   # Avoid: Overly broad queries
   "Show me everything in the database"
   ```

2. **VS Code Agent Mode Best Practices**
   ```python
   # Use tool selection strategically
   # Enable only needed OpenMetadata tools to stay under 128 tool limit
   
   # Reference tools directly when needed
   # Use #metadata_search instead of enabling all tools
   
   # Use MCP resources for context
   # Add specific table schemas as context before analysis
   ```

3. **Contextual Requests**
   ```python
   # Good: Provide context
   "I'm working on GDPR compliance. Find all tables with PII data and their retention policies"
   
   # Avoid: Vague requests
   "Find some data"
   ```

4. **Iterative Exploration**
   ```python
   # Start broad, then narrow down
   "What databases do we have?" → 
   "What tables are in the customer database?" → 
   "Show me the schema for the users table"
   ```

5. **Tool Sets and Custom Modes**
   ```python
   # Create tool sets for common workflows
   # Group OpenMetadata tools with related VS Code tools
   # Use in custom chat modes or prompt files
   ```

---

## Conclusion

OpenMetadata's MCP integration represents a significant step forward in AI-powered data management. By providing direct access to your metadata graph, AI tools can now offer intelligent assistance for:

- **Data Discovery** - Find and explore data assets naturally
- **Impact Analysis** - Understand dependencies and changes  
- **Governance** - Automate compliance and quality checks
- **Documentation** - Generate and maintain data documentation
- **Monitoring** - Proactive data pipeline and quality monitoring

Whether we choose OpenMetadata or DataHub for MCP depends on your specific needs, but OpenMetadata's integrated approach offers a compelling vision for the future of AI-assisted data management.

### Next Steps

1. **Try the Setup** - Follow our [quick start guide](#setup-guide)
2. **Explore Use Cases** - Experiment with different [MCP capabilities](#use-cases--examples)
3. **Join the Community** - Connect with other users on [OpenMetadata Slack](https://slack.open-metadata.org/)
4. **Contribute** - Share your MCP experiences and use cases
5. **Stay Updated** - Follow [OpenMetadata releases](https://github.com/open-metadata/OpenMetadata/releases) for new MCP features

---

## Additional Resources

### **Official Documentation**
- 📖 [OpenMetadata MCP Documentation](https://docs.open-metadata.org/latest/how-to-guides/mcp)
- 📖 [OpenMetadata v1.8.x MCP Guide](https://docs.open-metadata.org/v1.8.x/how-to-guides/mcp)
- 📖 [VS Code MCP Documentation](https://code.visualstudio.com/docs/copilot/chat/mcp-servers)
- 🌐 [Model Context Protocol Specification](https://modelcontextprotocol.io/)

### **OpenMetadata Resources**
- 💬 [OpenMetadata Slack #mcp Channel](https://slack.open-metadata.org/)
- 🔧 [OpenMetadata GitHub Repository](https://github.com/open-metadata/OpenMetadata)
- 🔧 [OpenMetadata MCP Source Code](https://github.com/open-metadata/OpenMetadata/tree/main/openmetadata-mcp)
- 📋 [OpenMetadata MCP Application Config](https://github.com/open-metadata/OpenMetadata/tree/main/openmetadata-ui/src/main/resources/ui/public/locales/en-US/Applications/McpApplication.md)

### **MCP Ecosystem**
- 🛠️ [VS Code Curated MCP Servers](https://code.visualstudio.com/mcp)
- 🔧 [MCP Server Repository](https://github.com/modelcontextprotocol/servers)
- 📋 [DataHub MCP Server](https://github.com/acryldata/mcp-server-datahub)

### **Video & Community**
- 🎥 [MCP Introduction Video](https://www.youtube.com/watch?v=AuYBaXC8-M4)
- 📺 [OpenMetadata YouTube Channel](https://www.youtube.com/@open-metadata)
- 💬 [OpenMetadata Community Forums](https://github.com/open-metadata/OpenMetadata/discussions)

---

*Last updated: July 17, 2025*  
*OpenMetadata Version: 1.8.0+ (MCP support added)*  
*VS Code MCP Support: v1.102+ (Generally Available)*  
*MCP Protocol Version: 2024-11-05*
