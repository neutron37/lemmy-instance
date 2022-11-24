# Getting started

Run this command to generate configuration, load envvars, and start docker compose.

```
lemmy-up.sh dev
```

# Visit the site

Visit https://localhost/.

Login with:
* user: lemmy
* password: lemmylemmy

Notes:
* It may take a few moments to get started.
* You must choose to bypass the HTTPS/TLS warning in the browser.
* You may need to run `docker compose up` more than once, as it seems database may time out on first attempt.
