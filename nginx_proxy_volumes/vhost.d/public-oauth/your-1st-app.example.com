# Include OAuth2 Proxy config file
include /etc/nginx/oauth2_proxy.conf;
