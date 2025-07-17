# Backup Directory

This directory stores database backups created by the management script.

## Backup Commands

```bash
# Create a backup
./scripts/manage.sh backup

# Restore from backup
./scripts/manage.sh restore backups/openmetadata_backup_YYYYMMDD_HHMMSS.sql.gz
```

## Backup Files

Backups are automatically compressed with gzip and include timestamps in the filename format:
`openmetadata_backup_YYYYMMDD_HHMMSS.sql.gz`

## Retention

Consider implementing a backup retention policy for production environments to manage disk space.
