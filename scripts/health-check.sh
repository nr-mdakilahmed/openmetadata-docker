#!/bin/bash
# OpenMetadata MCP Health Check Script
# This script checks the health of OpenMetadata services and MCP connectivity

# Load environment variables
ENV_FILE="${ENV_FILE:-.env.local}"
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
else
    echo "⚠️ Warning: Environment file $ENV_FILE not found. Using defaults."
fi

echo "🔍 Checking OpenMetadata services health..."

# Check Docker containers
echo "📦 Checking Docker containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep openmetadata

echo ""

# Check OpenMetadata server health
echo "🏥 Checking OpenMetadata server health:"
HEALTH_CHECK=$(curl -s http://localhost:8586/healthcheck 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "✅ OpenMetadata server is healthy"
    echo "$HEALTH_CHECK" | jq '.' 2>/dev/null || echo "$HEALTH_CHECK"
else
    echo "❌ OpenMetadata server is not responding"
    exit 1
fi

echo ""

# Check MySQL connection
echo "🗄️ Checking MySQL connection:"
MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD:-password}"
docker exec openmetadata_mysql mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1 as connection_test;" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ MySQL connection is working"
else
    echo "❌ MySQL connection failed"
fi

echo ""

# Check Elasticsearch
echo "🔍 Checking Elasticsearch:"
ELASTIC_HEALTH=$(curl -s http://localhost:9200/_cluster/health 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "✅ Elasticsearch is healthy"
    echo "$ELASTIC_HEALTH" | jq '.status' 2>/dev/null || echo "$ELASTIC_HEALTH"
else
    echo "❌ Elasticsearch is not responding"
fi

echo ""

# Test OpenMetadata API
echo "🔗 Testing OpenMetadata API:"
API_TEST=$(curl -s http://localhost:8585/api/v1/system/config 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "✅ OpenMetadata API is accessible"
else
    echo "❌ OpenMetadata API is not responding"
fi

echo ""
echo "🏁 Health check complete!"

# Restart containers if needed (uncomment the following lines if you want auto-restart)
# if [ "$1" = "--restart-on-failure" ]; then
#     echo "🔄 Restarting unhealthy services..."
#     docker-compose restart
# fi
