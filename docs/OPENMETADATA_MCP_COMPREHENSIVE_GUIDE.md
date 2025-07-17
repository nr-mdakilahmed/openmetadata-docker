# OpenMetadata MCP (Model Context Protocol) - Comprehensive Guide

A complete guide to setting up and using OpenMetadata's integrated MCP server with Claude Desktop, VS Code with GitHub Copilot, and other AI tools.

## 📖 Table of Contents

1. [What is MCP?](#what-is-mcp)
2. [OpenMetadata MCP Overview](#openmetadata-mcp-overview)
3. [Setup Guide](#setup-guide)
4. [Supported Tools & Integrations](#supported-tools--integrations)
5. [MCP Capabilities & Features](#mcp-capabilities--features)
6. [Use Cases & Examples](#use-cases--examples)
7. [OpenMetadata vs DataHub MCP](#openmetadata-vs-datahub-mcp)
8. [Pros and Cons](#pros-and-cons)
9. [Troubleshooting](#troubleshooting)
10. [Best Practices](#best-practices)

---

## What is MCP?

**Model Context Protocol (MCP)** is an open standard that enables AI models and tools to securely access and interact with external data sources and systems. It provides a standardized way for:

- **AI Models** (Claude, GPT, etc.) to connect to data platforms
- **Tools** (VS Code, Cursor, etc.) to integrate with metadata systems
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

### Key Features:
- ✅ **Embedded MCP Server** - Built directly into OpenMetadata
- ✅ **Same Authorization Engine** - Uses OpenMetadata's existing security model
- ✅ **Complete Metadata Access** - Full access to your data catalog
- ✅ **Real-time Updates** - Live data and lineage information
- ✅ **Role-based Access** - Respects user permissions and policies

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
4. Submit the configuration (Origin Header URI can be skipped for SSE)

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

1. Install the MCP extension for VS Code
2. Configure in VS Code settings:

```json
{
  "mcp.servers": {
    "openmetadata": {
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

#### For Cursor IDE

Similar configuration in Cursor's settings with MCP server definition.

### Step 4: Test the Connection

1. Restart your AI tool
2. Allow MCP connections when prompted
3. Test with: `"What tables do you have access to in OpenMetadata?"`

---

## Supported Tools & Integrations

### ✅ Officially Supported

| Tool | Status | Features |
|------|--------|----------|
| **Claude Desktop** | ✅ Full Support | Complete metadata access, search, lineage |
| **VS Code + GitHub Copilot** | ✅ Full Support | Integrated development workflow |
| **Cursor IDE** | ✅ Full Support | AI-powered code assistance |
| **OpenAI GPT** | ✅ Compatible | API-based integration |

### 🔄 Community Supported

| Tool | Status | Notes |
|------|--------|-------|
| **Goose Desktop** | 🔄 Experimental | Community-maintained |
| **Continue.dev** | 🔄 In Progress | VS Code extension |
| **Cody** | 🔄 Planned | Sourcegraph integration |

### 🛠️ Integration Methods

1. **Desktop Applications** - Direct MCP server connection
2. **VS Code Extensions** - Through MCP protocol
3. **API Integration** - REST API with MCP compatibility
4. **Custom Tools** - Using MCP SDK/libraries

---

## MCP Capabilities & Features

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
- users.customer_profiles (SSN, email, phone)
- payments.billing_info (credit card data)

🟡 Medium Risk:
- analytics.user_behavior (user IDs, IP addresses)
- marketing.campaigns (email preferences)

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

## Troubleshooting

### Common Issues

#### 1. **MCP Connection Failed**

```bash
# Check OpenMetadata MCP server status
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8585/mcp/health

# Verify token validity
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8585/api/v1/users/me
```

**Solutions:**
- Verify OpenMetadata is running and accessible
- Check token expiration and permissions
- Ensure MCP app is installed in OpenMetadata
- Verify network connectivity

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
- Update VS Code and GitHub Copilot extension
- Check MCP extension installation
- Verify settings.json configuration
- Restart VS Code after configuration changes

### Debug Commands

```bash
# Test MCP server directly
npx -y mcp-remote http://localhost:8585/mcp/sse \
  --auth-server-url=http://localhost:8585/mcp \
  --client-id=openmetadata \
  --header "Authorization:Bearer YOUR_TOKEN" \
  --verbose

# Check OpenMetadata logs
docker logs openmetadata_server

# Verify MCP app installation
curl http://localhost:8585/api/v1/apps/name/McpApplication
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
   - Track query performance
   - Alert on service disruptions

2. **Backup & Recovery**
   - Regular OpenMetadata backups
   - Document MCP configurations
   - Test disaster recovery procedures
   - Version control configurations

3. **Documentation**
   - Document MCP use cases and queries
   - Maintain configuration templates
   - Create troubleshooting runbooks
   - Train users on MCP capabilities

### 🎯 Usage Patterns

1. **Efficient Queries**
   ```python
   # Good: Specific queries
   "Show me tables in the sales database with customer data"
   
   # Avoid: Overly broad queries
   "Show me everything in the database"
   ```

2. **Contextual Requests**
   ```python
   # Good: Provide context
   "I'm working on GDPR compliance. Find all tables with PII data and their retention policies"
   
   # Avoid: Vague requests
   "Find some data"
   ```

3. **Iterative Exploration**
   ```python
   # Start broad, then narrow down
   "What databases do we have?" → 
   "What tables are in the customer database?" → 
   "Show me the schema for the users table"
   ```

---

## Conclusion

OpenMetadata's MCP integration represents a significant step forward in AI-powered data management. By providing direct access to your metadata graph, AI tools can now offer intelligent assistance for:

- **Data Discovery** - Find and explore data assets naturally
- **Impact Analysis** - Understand dependencies and changes  
- **Governance** - Automate compliance and quality checks
- **Documentation** - Generate and maintain data documentation
- **Monitoring** - Proactive data pipeline and quality monitoring

Whether you choose OpenMetadata or DataHub for MCP depends on your specific needs, but OpenMetadata's integrated approach offers a compelling vision for the future of AI-assisted data management.

### Next Steps

1. **Try the Setup** - Follow our [quick start guide](#setup-guide)
2. **Explore Use Cases** - Experiment with different [MCP capabilities](#use-cases--examples)
3. **Join the Community** - Connect with other users on [OpenMetadata Slack](https://slack.open-metadata.org/)
4. **Contribute** - Share your MCP experiences and use cases
5. **Stay Updated** - Follow [OpenMetadata releases](https://github.com/open-metadata/OpenMetadata/releases) for new MCP features

---

## Additional Resources

- 📖 [OpenMetadata MCP Official Docs](https://docs.open-metadata.org/latest/how-to-guides/mcp/claude)
- 🎥 [MCP Introduction Video](https://www.youtube.com/watch?v=AuYBaXC8-M4)
- 💬 [OpenMetadata Slack #mcp Channel](https://slack.open-metadata.org/)
- 🔧 [OpenMetadata GitHub](https://github.com/open-metadata/OpenMetadata)
- 🌐 [Model Context Protocol Specification](https://modelcontextprotocol.io/)
- 📋 [DataHub MCP Server](https://github.com/acryldata/mcp-server-datahub)

---

*Last updated: July 17, 2025*
*OpenMetadata Version: 1.8.0+*
