Per  https://join-lemmy.org/docs/en/administration/install_docker.html ...

```
wget https://raw.githubusercontent.com/LemmyNet/lemmy/main/docker/prod/docker-compose.yml
wget https://raw.githubusercontent.com/LemmyNet/lemmy/main/docker/prod/lemmy.hjson
wget https://raw.githubusercontent.com/LemmyNet/lemmy-ansible/main/templates/nginx.conf
mkdir -p volumes/pictrs
```

Generate localhost keys

```
mkdir -p letsencrypt/localhost/
cd letsencrypt/localhost/
openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -subj "/C=DE/ST=Berlin/L=Berlin/O=Lemmy/OU=Org/CN=localhost" -keyout privkey.pem -out fullchain.pem
```