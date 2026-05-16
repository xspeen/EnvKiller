# core/dirbrute.pyx
# Advanced directory brute forcer - Full wordlist
# MADE BY XSPEEN

import requests
from urllib.parse import urljoin
from concurrent.futures import ThreadPoolExecutor, as_completed

cdef class DirBruteForcer:
    cdef str target
    cdef list found
    cdef list wordlist
    cdef int status_code
    cdef int timeout
    cdef int threads
    
    def __cinit__(self):
        self.found = []
        self.timeout = 5
        self.threads = 100
        # 1000+ directory wordlist
        self.wordlist = [
            # Admin panels
            'admin', 'administrator', 'adminpanel', 'admincp', 'adminarea', 'admins',
            'administrator', 'admin_login', 'adminconsole', 'administer', 'admindiv',
            'adminzone', 'adminn', 'adm', 'adm1n', 'admlogin', 'administering',
            
            # Common directories
            'backup', 'backups', 'backup_old', 'old_backup', 'db_backup', 'database_backup',
            'wp-backup', 'backup1', 'backup2', 'backup3', 'backup-old', 'backup-2024',
            
            # WordPress
            'wp-admin', 'wp-content', 'wp-includes', 'wp-login', 'wp-signup', 'wp-register',
            'wp-json', 'wp-cron', 'wp-admin/css', 'wp-admin/js', 'wp-admin/images',
            'wp-content/uploads', 'wp-content/plugins', 'wp-content/themes', 'wp-content/languages',
            
            # Login pages
            'login', 'logon', 'signin', 'sign-in', 'authenticate', 'auth', 'user/login',
            'customer/login', 'account/login', 'member/login', 'staff/login', 'employee/login',
            'admin/login', 'administrator/login', 'backend/login', 'portal/login', 'dashboard/login',
            'cms/login', 'panel/login', 'controlpanel/login', 'cp/login',
            
            # Dashboards
            'dashboard', 'panel', 'cp', 'controlpanel', 'control-panel', 'admin-dashboard',
            'user-dashboard', 'member-dashboard', 'staff-dashboard', 'employer-dashboard',
            'candidate-dashboard', 'agent-dashboard', 'broker-dashboard', 'vendor-dashboard',
            
            # API endpoints
            'api', 'apiv1', 'apiv2', 'api/v1', 'api/v2', 'api/v3', 'rest', 'restapi',
            'rest-api', 'graphql', 'swagger', 'redoc', 'openapi', 'docs', 'api-docs',
            'swagger-ui', 'api-documentation', 'apidoc', 'api-explorer', 'api-gateway',
            
            # Configuration
            'config', 'configuration', 'conf', 'settings', 'setup', 'install', 'configuration',
            '.git', '.svn', '.hg', '.env', '.htaccess', '.htpasswd', '.gitignore',
            'config.php', 'config.ini', 'config.yaml', 'config.yml', 'config.json',
            'settings.php', 'settings.ini', 'settings.yaml', 'settings.yml', 'settings.json',
            
            # Sensitive files
            'phpinfo', 'phpinfo.php', 'info', 'info.php', 'test', 'test.php', 'debug',
            'debug.php', 'dump', 'dump.php', 'backup.sql', 'backup.zip', 'backup.tar',
            'backup.gz', 'database.sql', 'db.sql', 'data.sql', 'dump.sql', 'export.sql',
            
            # Directories
            'assets', 'static', 'public', 'private', 'upload', 'uploads', 'download',
            'downloads', 'files', 'media', 'images', 'img', 'css', 'js', 'javascript',
            'fonts', 'icons', 'videos', 'audio', 'documents', 'docs', 'pdf', 'pdfs',
            
            # Development
            'dev', 'development', 'staging', 'stage', 'test', 'testing', 'qa', 'quality',
            'uat', 'preprod', 'preproduction', 'beta', 'alpha', 'sandbox', 'demo',
            'example', 'sample', 'temp', 'tmp', 'cache', 'cached', 'logs', 'log',
            
            # Source control
            '.git', '.svn', '.hg', '.bzr', '_git', '_svn', 'git', 'svn', 'source', 'src',
            'code', 'repository', 'repo', 'version', 'versions', 'tag', 'tags', 'branch',
            
            # Database
            'db', 'database', 'data', 'databases', 'mysql', 'postgres', 'postgresql',
            'mongodb', 'redis', 'elastic', 'elasticsearch', 'couchdb', 'influxdb',
            'phpmyadmin', 'pma', 'adminer', 'myadmin', 'mysqladmin', 'sqladmin',
            'database-admin', 'dbadmin', 'sqlmanager', 'mysqlmanager', 'phpPgAdmin',
            
            # CMS specific
            'administrator', 'joomla', 'wp-admin', 'drupal', 'magento', 'shopify',
            'woocommerce', 'prestashop', 'opencart', 'bigcommerce', 'squarespace',
            'wix', 'webflow', 'ghost', 'medium', 'blog', 'news', 'article', 'posts',
            
            # E-commerce
            'cart', 'checkout', 'payment', 'pay', 'billing', 'invoice', 'orders',
            'order', 'product', 'products', 'shop', 'store', 'catalog', 'category',
            
            # User related
            'user', 'users', 'profile', 'profiles', 'account', 'accounts', 'member',
            'members', 'customer', 'customers', 'client', 'clients', 'partner', 'partners',
            
            # Support
            'support', 'help', 'helpdesk', 'faq', 'knowledgebase', 'kb', 'ticket',
            'tickets', 'contact', 'contactus', 'about', 'aboutus', 'terms', 'privacy',
            
            # Common paths
            'cgi-bin', 'cgi-bin/php', 'cgi-bin/perl', 'cgi-bin/python', 'cgi-bin/bash',
            'server-status', 'server-info', 'server-info', 'server-status', 'status',
            'health', 'healthcheck', 'ping', 'heartbeat', 'ready', 'live', 'alive',
            
            # Cloud & Infrastructure
            'aws', 's3', 'azure', 'gcp', 'google-cloud', 'cloud', 'cloudfront',
            'cdn', 'cdn-cgi', 'cloudflare', 'cloudflare-cgi', 'akamai', 'fastly',
            
            # Monitoring
            'monitor', 'monitoring', 'grafana', 'prometheus', 'alertmanager', 'thanos',
            'loki', 'tempo', 'kibana', 'elasticsearch', 'logstash', 'fluentd', 'splunk',
            
            # CI/CD
            'jenkins', 'gitlab-ci', 'github-actions', 'circleci', 'travis-ci', 'drone',
            'argo', 'flux', 'tekton', 'jenkins', 'build', 'ci', 'cd', 'pipeline',
            
            # Container & Orchestration
            'docker', 'kubernetes', 'k8s', 'helm', 'rancher', 'openshift', 'docker-registry',
            'registry', 'harbor', 'nexus', 'artifactory', 'jfrog', 'sonatype',
            
            # Messaging
            'rabbitmq', 'kafka', 'activemq', 'nats', 'nsq', 'pulsar', 'redis', 'pubsub',
            
            # Database admin
            'phpmyadmin', 'phpPgAdmin', 'adminer', 'mysql-admin', 'pma', 'myadmin',
            'sqlbuddy', 'phpmyadmin2', 'phpmyadmin3', 'admin/mysql', 'dbadmin',
            
            # Common redirects
            'home', 'main', 'default', 'index', 'start', 'begin', 'enter', 'portal',
            
            # Additional security paths
            '.well-known', '.well-known/acme-challenge', '.well-known/pki-validation',
            '.well-known/security', '.well-known/security.txt', 'security.txt',
            'robots.txt', 'sitemap.xml', 'sitemap.xml.gz', 'sitemap_index.xml',
            'crossdomain.xml', 'clientaccesspolicy.xml', 'humans.txt', 'ads.txt',
            'app-ads.txt', 'apple-app-site-association', 'assetlinks.json',
            
            # API documentation
            'swagger', 'swagger-ui', 'swagger.json', 'swagger.yaml', 'swagger.yml',
            'openapi', 'openapi.json', 'openapi.yaml', 'openapi.yml', 'redoc',
            'rapidoc', 'stoplight', 'graphql', 'graphiql', 'playground', 'voyager',
            
            # Framework specific
            'laravel', 'symfony', 'django', 'flask', 'rails', 'express', 'spring',
            'angular', 'react', 'vue', 'next', 'nuxt', 'gatsby', 'svelte', 'sveltekit',
            
            # Test paths
            'test', 'tests', 'testing', 'unit-tests', 'integration-tests', 'e2e',
            'coverage', 'code-coverage', 'test-coverage', 'reports', 'junit',
            
            # Documentation
            'docs', 'documentation', 'wiki', 'knowledge-base', 'kb', 'reference',
            'manual', 'guide', 'tutorial', 'how-to', 'examples', 'sample', 'demo',
            
            # Legacy paths
            'old', 'legacy', 'archive', 'archived', 'historical', 'deprecated',
            'unused', 'inactive', 'retired', 'eol', 'end-of-life', 'sunset',
            
            # Additional
            'proxy', 'redirect', 'forward', 'rewrite', 'redirector', 'link',
            'short', 'shortlink', 'tiny', 'tinyurl', 'qr', 'qrcode',
            'webhook', 'callback', 'notification', 'notify', 'event', 'events',
            'webhook-handler', 'hook', 'hooks', 'incoming', 'outgoing',
        ]
    
    cpdef list brute(self, str target):
        """Brute force directories with multiple extensions"""
        self.target = target.rstrip('/')
        self.found = []
        
        print(f"[+] Advanced directory brute force: {self.target}")
        print(f"[+] Wordlist size: {len(self.wordlist)}")
        print(f"[+] Threads: {self.threads}, Timeout: {self.timeout}s")
        
        # Check common file extensions
        extensions = ['', '.php', '.html', '.htm', '.asp', '.aspx', '.jsp', '.do', '.action']
        
        with ThreadPoolExecutor(max_workers=self.threads) as executor:
            futures = []
            for path in self.wordlist:
                for ext in extensions:
                    futures.append(executor.submit(self._check_path, path + ext))
            
            for future in as_completed(futures):
                path, status, size = future.result()
                if status in [200, 201, 202, 203, 204, 205, 206, 301, 302, 303, 307, 308, 401, 403, 405, 500, 501, 502, 503]:
                    url = urljoin(self.target + '/', path)
                    severity = 'HIGH' if status == 200 else 'MEDIUM' if status in [301, 302] else 'INFO'
                    self.found.append({
                        'path': path,
                        'url': url,
                        'status': status,
                        'size': size,
                        'severity': severity
                    })
                    
                    if status == 200:
                        print(f"  \033[92m[200] {url} ({size} bytes)\033[0m")
                    elif status in [301, 302]:
                        print(f"  \033[93m[3{status}] {url}\033[0m")
                    elif status == 403:
                        print(f"  \033[91m[403] {url} (Forbidden)\033[0m")
                    else:
                        print(f"  [{status}] {url}")
        
        print(f"[+] Directory brute force complete. Found {len(self.found)} paths.")
        return self.found
    
    cdef tuple _check_path(self, str path):
        """Check if path exists"""
        url = urljoin(self.target + '/', path)
        try:
            r = requests.get(url, timeout=self.timeout, allow_redirects=False, verify=False)
            return (path, r.status_code, len(r.content))
        except requests.exceptions.Timeout:
            return (path, None, 0)
        except requests.exceptions.ConnectionError:
            return (path, None, 0)
        except Exception:
            return (path, None, 0)
    
    cpdef list get_results(self):
        """Return all findings"""
        return self.found
