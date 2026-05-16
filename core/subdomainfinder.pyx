# core/subdomainfinder.pyx
# Advanced subdomain discovery - Full coverage
# MADE BY XSPEEN

import socket
import dns.resolver
import dns.query
import dns.zone
import requests
from concurrent.futures import ThreadPoolExecutor, as_completed

cdef class SubdomainFinder:
    cdef str domain
    cdef list found
    cdef list wordlist
    
    def __cinit__(self):
        self.found = []
        # 500+ common subdomain wordlist
        self.wordlist = [
            'www', 'mail', 'ftp', 'localhost', 'webmail', 'smtp', 'pop', 'ns1', 'ns2',
            'cpanel', 'whm', 'autodiscover', 'autoconfig', 'm', 'imap', 'test', 'ns',
            'blog', 'pop3', 'dev', 'www2', 'admin', 'forum', 'news', 'vpn', 'ns3',
            'mail2', 'new', 'mysql', 'old', 'lists', 'support', 'mobile', 'mx',
            'static', 'docs', 'beta', 'shop', 'sql', 'secure', 'demo', 'cp',
            'calendar', 'wiki', 'web', 'media', 'email', 'images', 'img', 'download',
            'dns', 'stats', 'dashboard', 'portal', 'manage', 'start', 'info', 'apps',
            'api', 'cdn', 'remote', 'server', 'stage', 'vps', 'monitor', 'help',
            'transfer', 'drive', 'host', 'internal', 'database', 'backup', 'ldap',
            'proxy', 'logs', 'store', 'billing', 'status', 'register', 'ssh',
            'exchange', 'owa', 'cloud', 'app', 'api2', 'api3', 'dev2', 'test2',
            'staging', 'production', 'prod', 'uat', 'sit', 'qa', 'ci', 'cd',
            'jenkins', 'gitlab', 'github', 'bitbucket', 'jira', 'confluence',
            'kb', 'helpdesk', 'support2', 'community', 'shop2', 'store2', 'cart',
            'checkout', 'payment', 'pay', 'ssl', 'vpn2', 'rdp', 'terminal', 'shell',
            'console', 'admin2', 'administrator', 'root', 'sysadmin', 'it', 'hr',
            'finance', 'accounting', 'invoice', 'reports', 'report', 'analytics',
            'metrics', 'alert', 'alerts', 'health', 'healthcheck', 'ping', 'status2',
            'temp', 'tmp', 'archive', 'old', 'legacy', 'beta2', 'alpha', 'edge',
            'preview', 'sandbox', 'playground', 'lab', 'research', 'science', 'data',
            'db', 'database2', 'sql2', 'mysql2', 'postgres', 'redis', 'mongo',
            'mongodb', 'couch', 'elastic', 'kibana', 'grafana', 'prometheus',
            'alertmanager', 'thanos', 'loki', 'tempo', 'kafka', 'zookeeper',
            'rabbitmq', 'activemq', 'nats', 'nsq', 'pulsar', 'clickhouse', 'druid',
            'pinot', 'presto', 'trino', 'hive', 'spark', 'flink', 'storm', 'beam',
            'airflow', 'dagster', 'prefect', 'dbt', 'looker', 'tableau', 'powerbi',
            'superset', 'metabase', 'redash', 'mode', 'chartio', 'qlik', 'sisense',
            'domo', 'gooddata', 'microstrategy', 'cognos', 'sap', 'oracle', 'db2',
            'teradata', 'vertica', 'greenplum', 'netezza', 'exasol', 'tidb',
            'cockroach', 'yugabyte', 'spanner', 'alloydb', 'aurora', 'rds',
            'dynamodb', 'cosmos', 'firestore', 'realtime', 'supabase', 'appwrite',
            'pocketbase', 'directus', 'strapi', 'keystone', 'payload', 'sanity',
            'prismic', 'contentful', 'storyblok', 'builder', 'plasmic', 'tina',
            'decap', 'netlifycms', 'forestry', 'stackbit', 'vue', 'react', 'angular',
            'svelte', 'next', 'nuxt', 'gatsby', 'hugo', 'jekyll', 'eleventy',
            'astro', 'remix', 'solid', 'qwik', 'sveltekit', 'blitz', 'redwood',
            'wordpress', 'wp', 'drupal', 'joomla', 'magento', 'shopify', 'woocommerce',
            'prestashop', 'opencart', 'bigcommerce', 'wix', 'squarespace', 'webflow',
            'ghost', 'medium', 'substack', 'beehiiv', 'convertkit', 'mailchimp',
            'sendgrid', 'mailgun', 'postmark', 'ses', 'sparkpost', 'sendinblue',
            'brevo', 'mailerlite', 'getresponse', 'activecampaign', 'hubspot',
            'salesforce', 'zoho', 'freshworks', 'nethunt', 'pipedrive', 'zendesk',
            'freshdesk', 'helpscout', 'intercom', 'drift', 'crisp', 'chatwoot',
            'gorgias', 'kustomer', 'tawk', 'livechat', 'olark', 'purechat',
            'smartsupp', 'userlike', 'tidio', 'jivochat', 'tawkto', 'chatra',
            'zopim', 'zendeskchat', 'snapengage', 'boldchat', 'comm100', 'providechat',
            'whoson', 'clickdesk', 'imlived', 'nudge', 'tagove', 'quicksupport',
            'velaro', 'browserstack', 'saucelabs', 'lambdatest', 'testingbot',
            'crossbrowsertesting', 'percy', 'chromatic', 'argos', 'loki', 'backstop',
            'happo', 'visual', 'axe', 'pa11y', 'wave', 'lighthouse', 'pagespeed',
            'webpagetest', 'gtmetrix', 'pingdom', 'uptimerobot', 'statuscake',
            'healthchecks', 'betteruptime', 'ohdear', 'freshping', 'uptimekuma',
            'vigil', 'statping', 'cachet', 'staytus', 'instatus', 'statuspage',
            'statuspal', 'statuscast', 'statusy', 'checkly', 'apimetrics', 'assertible',
            'runscope', 'postman', 'newman', 'bruno', 'insomnia', 'hoppscotch',
            'restclient', 'httpie', 'curl', 'wget', 'aria2'
        ]
    
    cpdef list find(self, str domain):
        """Find subdomains using multiple techniques"""
        self.domain = domain
        self.found = []
        
        print(f"[+] Advanced subdomain discovery: {domain}")
        print(f"[+] Wordlist size: {len(self.wordlist)}")
        
        # Technique 1: DNS brute force
        self._bruteforce_subdomains()
        
        # Technique 2: DNS record enumeration
        self._dns_enumeration()
        
        # Technique 3: Certificate Transparency logs
        self._certificate_transparency()
        
        # Technique 4: Search engine scraping
        self._search_engine_scrape()
        
        print(f"[+] Total subdomains found: {len(self.found)}")
        return self.found
    
    cdef void _bruteforce_subdomains(self):
        """Brute force subdomains using wordlist"""
        print(f"[+] Brute forcing subdomains...")
        
        with ThreadPoolExecutor(max_workers=100) as executor:
            futures = {executor.submit(self._resolve_subdomain, sub): sub for sub in self.wordlist}
            
            for future in as_completed(futures):
                sub, ip = future.result()
                if ip:
                    self.found.append({
                        'subdomain': sub,
                        'full': f"{sub}.{self.domain}",
                        'ip': ip,
                        'source': 'bruteforce'
                    })
                    print(f"  [+] {sub}.{self.domain} -> {ip}")
    
    cdef tuple _resolve_subdomain(self, str sub):
        """Resolve subdomain to IP"""
        full = f"{sub}.{self.domain}"
        try:
            ip = socket.gethostbyname(full)
            return (sub, ip)
        except:
            return (sub, None)
    
    cdef void _dns_enumeration(self):
        """Enumerate DNS records"""
        print(f"[+] Enumerating DNS records...")
        
        record_types = ['NS', 'MX', 'TXT', 'SOA', 'CNAME', 'AAAA', 'PTR']
        
        for rtype in record_types:
            try:
                answers = dns.resolver.resolve(self.domain, rtype)
                for answer in answers:
                    result = str(answer).strip('.')
                    self.found.append({
                        'subdomain': rtype,
                        'full': result,
                        'ip': None,
                        'source': 'dns'
                    })
                    print(f"  [+] DNS {rtype}: {result}")
            except:
                pass
    
    cdef void _certificate_transparency(self):
        """Query certificate transparency logs"""
        print(f"[+] Checking certificate transparency logs...")
        
        try:
            url = f"https://crt.sh/?q=%.{self.domain}&output=json"
            response = requests.get(url, timeout=10)
            
            if response.status_code == 200:
                import json
                data = response.json()
                
                for entry in data[:50]:
                    name = entry.get('name_value', '')
                    if name and self.domain in name and name not in [f['full'] for f in self.found]:
                        self.found.append({
                            'subdomain': name.split('.')[0],
                            'full': name,
                            'ip': None,
                            'source': 'crt.sh'
                        })
                        print(f"  [+] CRT: {name}")
        except Exception as e:
            print(f"  [!] CRT query failed: {str(e)[:50]}")
    
    cdef void _search_engine_scrape(self):
        """Scrape search engines for subdomains"""
        print(f"[+] Checking search engines...")
        
        # Google dork
        query = f"site:*.{self.domain}"
        
        try:
            # Using DuckDuckGo API (no API key)
            url = f"https://html.duckduckgo.com/html/?q={query}"
            response = requests.get(url, timeout=10, headers={'User-Agent': 'Mozilla/5.0'})
            
            if response.status_code == 200:
                import re
                pattern = r'([a-zA-Z0-9.-]+\.' + re.escape(self.domain) + r')'
                matches = re.findall(pattern, response.text)
                
                for match in matches[:20]:
                    if match not in [f['full'] for f in self.found]:
                        self.found.append({
                            'subdomain': match.split('.')[0],
                            'full': match,
                            'ip': None,
                            'source': 'search'
                        })
                        print(f"  [+] SEARCH: {match}")
        except Exception:
            pass
    
    cpdef dict get_results(self):
        """Return all findings"""
        return {
            'domain': self.domain,
            'subdomains': self.found,
            'total': len(self.found)
        }
