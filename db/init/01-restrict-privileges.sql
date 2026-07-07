-- Restrict application user privileges (run after schema import)
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'zxtunes_u'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON zxtunes_db.* TO 'zxtunes_u'@'%';
FLUSH PRIVILEGES;
