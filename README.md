# OpenMetadata Docker Setup

A **secure, production-ready** OpenMetadata deployment with comprehensive security hardening, automated management scripts, and optimized configurations for stability and performance.

## 🔒 Security Features

- ✅ **No hardcoded secrets** - All credentials in `.env` with secure placeholders
- ✅ **Environment validation** - Automated checks for proper configuration
- ✅ **Security auditing** - Built-in scripts for ongoing security monitoring
- ✅ **Git security** - Enhanced `.gitignore` prevents credential leaks
- ✅ **File permissions** - Secure `.env` permissions (600 - owner-only)
- ✅ **Production-ready** - Follow security best practices out of the box

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Minimum 4GB RAM available
- Ports 8585, 8586, 8080, 9200, 3306 available

### Initial Setup
```bash
# 1. Configure environment (REQUIRED)
cp .env .env.local   # Create local environment file
nano .env.local      # Replace YOUR_*_HERE placeholders with real values

# 2. Set secure permissions
chmod 600 .env.local

# 3. Validate configuration
./scripts/validate-env.sh .env.local

# 4. Run security audit
./scripts/manage.sh security
```

### Start OpenMetadata
```bash
# Start all services with local environment
docker-compose --env-file .env.local up -d

# Check service health
./scripts/health-check.sh

# View logs
docker-compose logs -f
```

### Access OpenMetadata
- **Web UI**: http://localhost:8585
- **API Documentation**: http://localhost:8585/docs
- **Health Check**: http://localhost:8586/healthcheck

## ⚡ Management Commands

```bash
# Complete service management
./scripts/manage.sh start|stop|restart|health|logs|backup|restore|security

# Environment & security validation
./scripts/validate-env.sh .env.local # Validate local environment configuration
./scripts/manage.sh security         # Run comprehensive security audit

# Service monitoring
./scripts/health-check.sh            # Check service health status

# Manual service control with local environment
docker-compose --env-file .env.local up -d    # Start all services
docker-compose down                            # Stop all services
```

## 📁 Project Structure

```
openmetadata-docker/
├── docker-compose.yml          # Main Docker Compose configuration
├── .env                        # Consolidated environment variables
├── .gitignore                  # Enhanced file exclusion patterns
├── .vscode/                    # VS Code settings for MCP
│   └── settings.json
├── config/                     # Configuration files
│   └── connectors/            # Data source connector configs
│       ├── databases/         # Database connectors (3 Snowflake configs)
│       └── pipelines/         # Pipeline connectors (Fivetran)
├── scripts/                   # Management & security scripts
│   ├── health-check.sh       # Service health monitoring
│   ├── manage.sh             # Unified management operations (with security)
│   ├── validate-env.sh       # Environment validation
│   └── security-audit.sh     # Comprehensive security audit script
├── docs/                      # Comprehensive documentation
│   ├── MCP_TIMEOUT_FIX_SUMMARY.md
│   ├── PROJECT_CLEANUP_SUMMARY.md
│   ├── PROJECT_RESTRUCTURE_SUMMARY.md
│   ├── SECURITY_ENVIRONMENT_SETUP.md
│   ├── ENVIRONMENT_VALIDATION_REPORT.md
│   └── FINAL_SECURITY_AUDIT_REPORT.md
├── backups/                   # Backup directory
│   └── README.md
└── docker-volume/            # Persistent data storage
    └── db-data/              # MySQL data directory
```

## 🔧 Configuration & Security

### Environment Variables (.env)
All configuration is **securely centralized** in the `.env` file with:
- **Security**: All secrets stored as environment variables with secure placeholders
- **Database**: Enhanced connection pooling and timeout configurations  
- **ElasticSearch**: Extended timeout settings for better stability
- **Memory**: Optimized JVM heap settings for performance
- **Connectors**: Snowflake and Fivetran configurations using env vars
- **Production-Ready**: No hardcoded secrets, secure file permissions (600)

⚠️ **IMPORTANT**: Replace all `YOUR_*_HERE` placeholders with real values before production use!

### Security & Validation Scripts
- **Security Audit**: Run `./scripts/manage.sh security` for comprehensive security checks
- **Environment Validation**: Use `./scripts/validate-env.sh` to verify setup
- **Health Monitoring**: Use `./scripts/health-check.sh` for service status
- **Unified Management**: Use `./scripts/manage.sh` for all operations

### MCP Server Settings
VS Code MCP timeout issues have been resolved with:
- Extended database connection timeouts (24 hours)
- Enhanced connection pooling
- Automatic reconnection logic
- Optimized health checks

## 📊 Monitoring

### Health Check Script
```bash
./scripts/health-check.sh
```

Monitors:
- Docker container status
- OpenMetadata server health
- Database connectivity
- ElasticSearch cluster status
- API accessibility

### Service Status
```bash
# Check running containers
docker-compose ps

# View resource usage
docker stats

# Check specific service logs
docker-compose logs openmetadata_server
```

## 🔌 Data Connectors

Connector configurations are stored in `config/connectors/`:

### Available Connectors
- **Databases**: Snowflake configurations (ingest, lineage, query usage)
- **Pipelines**: Fivetran configuration

### Adding New Connectors
1. Place configuration files in appropriate subdirectory
2. Update docker-compose.yml if needed
3. Restart services: `docker-compose restart`

## 🛠️ Management Commands

### Unified Management Script

Use the comprehensive management script for all operations:

```bash
# Start all services
./scripts/manage.sh start

# Stop all services  
./scripts/manage.sh stop

# Restart all services
./scripts/manage.sh restart

# Check service health
./scripts/manage.sh health

# View logs
./scripts/manage.sh logs [service_name]

# Run security audit (NEW!)
./scripts/manage.sh security

# Backup database
./scripts/manage.sh backup

# Restore database
./scripts/manage.sh restore <backup_file>

# Show script help
./scripts/manage.sh help
```

### Docker Compose Commands
```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# Restart specific service
docker-compose restart openmetadata_server

# View logs
docker-compose logs -f [service_name]
```

### Database Management
```bash
# Access MySQL shell
docker exec -it openmetadata_mysql mysql -u root -p

# Check database connections
docker exec openmetadata_mysql mysql -u root -ppassword -e "SHOW STATUS LIKE 'Threads_connected';"
```

### Backup & Restore
```bash
# Backup database
docker exec openmetadata_mysql mysqldump -u root -ppassword --all-databases > backup_$(date +%Y%m%d).sql

# Restore database
docker exec -i openmetadata_mysql mysql -u root -ppassword < backup_file.sql
```

## 🔒 Security Configuration

### Secure Environment Setup

This project implements **production-grade security** with comprehensive safeguards:

**✅ Security Features Implemented:**
- All sensitive information stored in `.env` with secure placeholders
- No hardcoded secrets in any configuration files  
- Secure file permissions (`.env` set to 600 - owner-only access)
- Enhanced `.gitignore` to prevent credential leaks
- Automated security audit script for ongoing monitoring
- Environment validation with security checks

### Environment Variables Setup

All sensitive information is stored in the `.env` file and referenced through environment variables. This ensures:

- ✅ **No hardcoded secrets** in version control
- ✅ **Easy credential management** with centralized configuration
- ✅ **Production-ready security** practices
- ✅ **Automated validation** and security auditing

**Key environment variables configured:**
- `OPENMETADATA_JWT_TOKEN` - JWT token for API authentication  
- `SNOWFLAKE_*` - Snowflake connection credentials
- `FIVETRAN_API_KEY/SECRET` - Fivetran API credentials
- `MYSQL_*` - Database connection credentials

### Security Validation & Auditing

**Environment Validation:**
```bash
./scripts/validate-env.sh
```
- ✅ Verifies all required environment variables are set
- 🔒 Hides sensitive values for security
- ⚠️ Warns about optional variables that aren't set
- 📝 Provides next steps for setup

**Comprehensive Security Audit:**
```bash
./scripts/manage.sh security
```
- 🔍 Scans for hardcoded secrets in all files
- 🔐 Checks file permissions and security settings
- 📋 Validates environment configuration
- 🛡️ Ensures no sensitive data exposure
- 📊 Generates security audit reports

### Connector Security

All connector YAML files now use environment variables instead of hardcoded values:

- `config/connectors/databases/snowflake-*.yaml` - Snowflake connectors
- `config/connectors/pipelines/fivetran.yaml` - Fivetran pipeline connector

**Security Features:**
- All sensitive data referenced via `${VARIABLE_NAME}` syntax
- No API keys, passwords, or tokens in configuration files
- Ready for production deployment

### Production Security Checklist

Before deploying to production:

1. **✅ Update Credentials**: Replace all `YOUR_*_HERE` placeholders with real values
2. **🔐 Secure Permissions**: Ensure `.env` has 600 permissions (`chmod 600 .env`)
3. **🔑 Strong Passwords**: Set strong passwords for all database connections
4. **🌐 Enable SSL/TLS**: Configure HTTPS for OpenMetadata server
5. **🛡️ Network Security**: Restrict access to internal networks only
6. **💾 Backup Secrets**: Store `.env` file securely and separately from code
7. **🔄 Regular Rotation**: Implement regular credential rotation policies
8. **🔍 Security Auditing**: Run `./scripts/manage.sh security` regularly

**🚨 Critical Security Notes:**
- Never commit `.env` to version control (protected by `.gitignore`)
- Always use environment variables for sensitive data
- Regularly audit for exposed credentials
- Keep backup copies of `.env` in secure locations

## 🐛 Troubleshooting

### Common Issues

1. **Service won't start**
   ```bash
   # Check logs
   docker-compose logs [service_name]
   
   # Restart all services
   docker-compose down && docker-compose up -d
   ```

2. **MCP connection timeouts**
   - Restart VS Code to apply new settings
   - Check health status: `./scripts/health-check.sh`
   - Verify container health: `docker-compose ps`

3. **Database connection issues**
   ```bash
   # Check MySQL status
   docker exec openmetadata_mysql mysql -u root -ppassword -e "SELECT 1"
   
   # Review connection parameters in .env
   ```

4. **Memory issues**
   ```bash
   # Monitor resource usage
   docker stats
   
   # Adjust heap settings in .env if needed
   ```

### Log Locations
- Container logs: `docker-compose logs [service_name]`
- Application logs: Available through OpenMetadata UI
- Health check logs: Run `./scripts/health-check.sh`

## 📚 Additional Resources

- [OpenMetadata Documentation](https://docs.open-metadata.org/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [Security Best Practices](./docs/FINAL_SECURITY_AUDIT_REPORT.md)
- [Environment Setup Guide](./docs/SECURITY_ENVIRONMENT_SETUP.md)
- [Troubleshooting Guide](./docs/MCP_TIMEOUT_FIX_SUMMARY.md)

## 🤝 Contributing

1. **Security First**: Run `./scripts/manage.sh security` before committing
2. **Test Changes**: Validate with `./scripts/validate-env.sh` and `./scripts/health-check.sh`
3. **Document Updates**: Update documentation for any configuration changes
4. **Backward Compatibility**: Ensure compatibility with existing data
5. **No Secrets**: Never commit credentials or sensitive data

---

**🔒 Security Notice**: This setup implements production-grade security with comprehensive auditing, automated validation, and secure credential management. All sensitive data is protected and no secrets are exposed in version control.

**📈 Performance**: Optimized for MCP server stability with enhanced connection pooling, extended timeouts, and robust health monitoring.
