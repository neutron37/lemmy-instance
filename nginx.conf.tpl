limit_req_zone ${DOLLAR}binary_remote_addr zone=${LEMMY_EXTERNAL_HOST}_ratelimit:10m rate=1r/s;

server {
    listen 80;
    listen [::]:80;
    server_name localhost;
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
    location / {
        return 301 https://${DOLLAR}host${DOLLAR}request_uri;
    }
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name ${LEMMY_EXTERNAL_HOST};
    resolver 127.0.0.11 [::1]:5353;

    ssl_certificate /etc/letsencrypt/live/${LEMMY_EXTERNAL_HOST}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${LEMMY_EXTERNAL_HOST}/privkey.pem;

    # Various TLS hardening settings
    # https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256';
    ssl_session_timeout  10m;
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets on;
    ssl_stapling on;
    ssl_stapling_verify on;

    # Hide nginx version
    server_tokens off;

    # Enable compression for JS/CSS/HTML bundle, for improved client load times.
    # It might be nice to compress JSON, but leaving that out to protect against potential
    # compression+encryption information leak attacks like BREACH.
    gzip on;
    gzip_types text/css application/javascript image/svg+xml;
    gzip_vary on;

    # Only connect to this site via HTTPS for the two years
    add_header Strict-Transport-Security "max-age=63072000";

    # Various content security headers
    add_header Referrer-Policy "same-origin";
    add_header X-Content-Type-Options "nosniff";
    add_header X-Frame-Options "DENY";
    add_header X-XSS-Protection "1; mode=block";

    # Upload limit for pictrs
    client_max_body_size 20M;

    # frontend
    location / {
      # The default ports:
      # lemmy_ui_port: 1235
      # lemmy_port: 8536

      set ${DOLLAR}proxpass "http://lemmy-ui:1234";
      if (${DOLLAR}http_accept ~ "^application/.*$") {
        set ${DOLLAR}proxpass "http://lemmy:8536";
      }
      if (${DOLLAR}request_method = POST) {
        set ${DOLLAR}proxpass "http://lemmy:8536";
      }
      proxy_pass ${DOLLAR}proxpass;

      rewrite ^(.+)/+${DOLLAR} ${DOLLAR}1 permanent;

      # Send actual client IP upstream
      proxy_set_header X-Real-IP ${DOLLAR}remote_addr;
      proxy_set_header Host ${DOLLAR}host;
      proxy_set_header X-Forwarded-For ${DOLLAR}proxy_add_x_forwarded_for;
    }

    # backend
    location ~ ^/(api|pictrs|feeds|nodeinfo|.well-known) {
      proxy_pass http://lemmy:8536;
      proxy_http_version 1.1;
      proxy_set_header Upgrade ${DOLLAR}http_upgrade;
      proxy_set_header Connection "upgrade";

      # Rate limit
      limit_req zone=${LEMMY_EXTERNAL_HOST}_ratelimit burst=30 nodelay;

      # Add IP forwarding headers
      proxy_set_header X-Real-IP ${DOLLAR}remote_addr;
      proxy_set_header Host ${DOLLAR}host;
      proxy_set_header X-Forwarded-For ${DOLLAR}proxy_add_x_forwarded_for;
    }


    # Redirect pictshare images to pictrs
    location ~ /pictshare/(.*)$ {
      return 301 /pictrs/image/$1;
    }

}

# Anonymize IP addresses
# https://www.supertechcrew.com/anonymizing-logs-nginx-apache/
map ${DOLLAR}remote_addr ${DOLLAR}remote_addr_anon {
  ~(?P<ip>\d+\.\d+\.\d+)\.    ${DOLLAR}ip.0;
  ~(?P<ip>[^:]+:[^:]+):       ${DOLLAR}ip::;
  127.0.0.1                   ${DOLLAR}remote_addr;
  ::1                         ${DOLLAR}remote_addr;
  default                     0.0.0.0;
}
access_log /var/log/nginx/access.log combined;
