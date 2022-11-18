Try `docker compose up` and visit https://localhost/.

Notes:
* It may take a few moments to get started.
* You must choose to bypass the HTTPS/TLS warning in the browser.
* You may need to run `docker compose up` more than once, as it seems database may time out on first attempt.



# How I got it working

_Roughly_ following https://join-lemmy.org/docs/en/administration/install_docker.html ...

I started with the following files, and modified them to work locally. No need for further edits at this point.
```
wget https://raw.githubusercontent.com/LemmyNet/lemmy/main/docker/prod/docker-compose.yml
wget https://raw.githubusercontent.com/LemmyNet/lemmy/main/docker/prod/lemmy.hjson
wget https://raw.githubusercontent.com/LemmyNet/lemmy-ansible/main/templates/nginx.conf
mkdir -p volumes/pictrs
```

I generate localhost keys like this. Saved to repository for convenience. No need to regenerate for the next year.

```
mkdir -p letsencrypt/localhost/
cd letsencrypt/localhost/
openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -subj "/C=DE/ST=Berlin/L=Berlin/O=Lemmy/OU=Org/CN=localhost" -keyout privkey.pem -out fullchain.pem
```
