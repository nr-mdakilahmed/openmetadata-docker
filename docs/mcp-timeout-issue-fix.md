# OpenMetadata MCP Server Timeout Fix - Summary

## Problem
Your OpenMetadata MCP (Model Context Protocol) server was experiencing timeout issues after a few minutes of idle time, requiring VS Code or the client to be restarted to restore functionality.

## Root Causes Identified
1. **Database Connection Timeouts**: MySQL connections were being closed after idle periods
2. **Insufficient Connection Pooling**: Default database connection parameters weren't optimized for long-running connections
3. **Default Timeout Settings**: Standard timeout configurations were too aggressive for MCP usage
4. **Missing Health Checks**: No monitoring for connection states

## Solutions Implemented

### 1. Enhanced MySQL Configuration
- **Increased timeouts**: `wait_timeout=86400` (24 hours) and `interactive_timeout=86400`
- **More connections**: `max_connections=200`
- **Better connection handling**: Added `innodb_lock_wait_timeout=120`

### 2. Optimized Database Connection Parameters
Enhanced the `DB_PARAMS` with connection pooling and caching:
```
allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC&autoReconnect=true&maxReconnects=10&initialTimeout=1&useConnectionPooling=true&cachePrepStmts=true&useServerPrepStmts=true&prepStmtCacheSize=250&prepStmtCacheSqlLimit=2048&useLocalSessionState=true&useLocalTransactionState=true&rewriteBatchedStatements=true&cacheResultSetMetadata=true&cacheServerConfiguration=true&elideSetAutoCommits=true&maintainTimeStats=false&socketTimeout=300000&connectTimeout=60000
```

### 3. Enhanced ElasticSearch Configuration
- **Extended timeouts**: `ELASTICSEARCH_CONNECTION_TIMEOUT_SECS=30`, `ELASTICSEARCH_SOCKET_TIMEOUT_SECS=300`
- **Longer keep-alive**: `ELASTICSEARCH_KEEP_ALIVE_TIMEOUT_SECS=1200`

### 4. Improved Memory Management
- **Better JVM settings**: `-XX:+UseG1GC -XX:MaxGCPauseMillis=200`
- **Increased heap size**: `-Xmx2G -Xms1G`

### 5. Enhanced Health Checks
- **More robust health checks**: Increased intervals and timeouts
- **Start period buffers**: Added `start_period` to allow services to fully initialize

### 6. VS Code Settings for MCP
Created `.vscode/settings.json` with MCP-specific timeout configurations:
```json
{
  "mcp.timeout": 30000,
  "mcp.retryAttempts": 3,
  "mcp.keepAlive": true,
  "mcp.reconnectOnError": true
}
```

## Files Created/Modified

### New Files
1. **`docker-compose-optimized.yml`** - Enhanced Docker Compose configuration
2. **`.env`** - Environment variables for easier configuration management
3. **`.vscode/settings.json`** - VS Code MCP timeout settings
4. **`health-check.sh`** - Health monitoring script

### Modified Files
1. **`docker-compose.yml`** - Enhanced MySQL command with additional timeout parameters

## Usage Instructions

### 1. Switch to Optimized Configuration
```bash
# Stop current services
docker-compose down

# Start with optimized configuration
docker-compose -f docker-compose-optimized.yml up -d
```

### 2. Monitor Health
```bash
# Run health check anytime
./health-check.sh

# Monitor logs if needed
docker-compose -f docker-compose-optimized.yml logs -f
```

### 3. VS Code MCP Configuration
The `.vscode/settings.json` file has been created with MCP-specific timeout settings. Restart VS Code to apply these settings.

## Expected Improvements

1. **No More Idle Timeouts**: Connections will remain stable for 24 hours of inactivity
2. **Better Connection Resilience**: Automatic reconnection with retry logic
3. **Improved Performance**: Connection pooling and caching reduce overhead
4. **Health Monitoring**: Easy way to check system status

## Troubleshooting

### If MCP Still Times Out
1. Check health status: `./health-check.sh`
2. Verify VS Code settings are applied (restart VS Code)
3. Check container logs: `docker-compose -f docker-compose-optimized.yml logs openmetadata_server`

### If Performance Issues Occur
- Monitor memory usage: `docker stats`
- Adjust heap settings in `.env` file if needed
- Check MySQL connection count: `docker exec openmetadata_mysql mysql -u root -ppassword -e "SHOW STATUS LIKE 'Threads_connected';"`

## Maintenance

### Regular Health Checks
Run `./health-check.sh` periodically to ensure all services are healthy.

### Log Monitoring
```bash
# Check for connection issues
docker-compose -f docker-compose-optimized.yml logs | grep -i "connection\|timeout\|error"
```

### Backup Configuration
Keep the `.env` file and `docker-compose-optimized.yml` backed up for easy restoration.

## Notes
- The optimized configuration is backward-compatible with your existing data
- All original functionality is preserved
- Performance should be improved due to connection pooling and caching
- The health check script can be automated with cron if desired

Your MCP server connection issues should now be resolved! The system is configured for stable, long-running connections that won't timeout during idle periods.
