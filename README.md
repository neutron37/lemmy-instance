# Getting started locally

Run this command to generate configuration, load envvars, and start docker compose.

`./lemmy-up.sh dev`

# Visit the local site

Visit https://localhost/.

Login with:
* user: lemmy
* password: lemmylemmy

Notes:
* It may take a few moments to get started.
* You must choose to bypass the HTTPS/TLS warning in the browser.
* You may need to run `docker compose up` more than once, as it seems database may time out on first attempt.

# Other utility scripts

In addition to `./lemmy-up.sh`, the following utility scripts are available.

* `./lemmy-down.sh`
  * Stop all lemmy services.
* `./lemmy-logs.sh`
  * Tail all lemmy logs.
* `./lemmy-genconf.sh`
  * Generate config if it's not already present.
  * This script is also used by `./lemmy-up.sh`.

# Creating a production environment and starting it

To create an enironment called "prod".

```
# Use dev.env as a tmplate.
cp dev.env prod.env

# Update all relevant values in the new .env file
vi prod.env

# Create configuration for production 
./lemmy-genconf.sh prod

# Edit nginx to use localhost certs initially.
vi nginx.prod.conf
    # Change the following lines from...
    #    ssl_certificate /etc/letsencrypt/live/{{mydomain}}/fullchain.pem;
    #    ssl_certificate_key /etc/letsencrypt/live/{{mydomain}}/privkey.pem;
    # to...
    #    ssl_certificate /etc/letsencrypt/live/localhost/fullchain.pem;
    #    ssl_certificate_key /etc/letsencrypt/live/localhost/privkey.pem;

# Start lemmy with self-signed certs...
./lemmy-up.sh prod

# At this point you may be able to access lemmy
# by bypassing browser warnings at https://$YOURDOMAIN

# Do certbot steps on the nginx instance.
docker exec -it lemmy-instance_proxy_1 sh
    # Installs dependencies
    apk add certbot certbot-nginx
    # Hopefully this succeed... be sure to replace indicated $VARS!
    certbot --nginx -d $YOURDOMAIN -m $ADMIN_EMAIL --agree-tos
    # Should make the nginx instance bounce and boot you out of the shell.
    nginx -s stop 

# Finally try to access https://$YOURDOMAIN in a browser.
```

# How I got it working initially

_Roughly_ following https://join-lemmy.org/docs/en/administration/install_docker.html ...

I started with the following files, and modified them to work locally. No need for further edits at this point.
```
wget https://raw.githubusercontent.com/LemmyNet/lemmy/main/docker/prod/docker-compose.yml
wget https://raw.githubusercontent.com/LemmyNet/lemmy/main/docker/prod/lemmy.hjson
wget https://raw.githubusercontent.com/LemmyNet/lemmy-ansible/main/templates/nginx.conf
mkdir -p volumes/pictrs
```

I generated localhost keys like this. Saved to repository for convenience. No need to regenerate for the next year.

```
mkdir -p letsencrypt/localhost/
cd letsencrypt/localhost/
openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -subj "/C=DE/ST=Berlin/L=Berlin/O=Lemmy/OU=Org/CN=localhost" -keyout privkey.pem -out fullchain.pem
```
