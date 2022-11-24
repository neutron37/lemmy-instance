{
  # for more info about the config, check out the documentation
  # https://join-lemmy.org/docs/en/administration/configuration.html
  # only few config options are covered in this example config

  setup: {
    # username for the admin user
    admin_username: "${ADMIN_USERNAME}"
    # password for the admin user
    admin_password: "${ADMIN_PASSWORD}"
    # name of the site (can be changed later)
    site_name: "${SITE_NAME}"
  }

  # the domain name of your instance (eg "lemmy.ml")
  hostname: "${LEMMY_EXTERNAL_HOST}"
  # address where lemmy should listen for incoming requests
  bind: "0.0.0.0"
  # port where lemmy should listen for incoming requests
  port: 8536
  # Whether the site is available over TLS. Needs to be true for federation to work.
  tls_enabled: true

  # pictrs host
  pictrs_url: "http://pictrs:8080"
  pictrs_api_key: "${PICTRS_API_KEY}"

  # settings related to the postgresql database
  database: {
    # name of the postgres database for lemmy
    database: "lemmy"
    # username to connect to postgres
    user: "lemmy"
    # password to connect to postgres
    password: "${DATABASE_PASSWORD}"
    # host where postgres is running
    host: "postgres"
    # port where postgres can be accessed
    port: 5432
    # maximum number of active sql connections
    pool_size: 5
  }
  captcha: {
    # Whether captcha is required for signup
    enabled: true
    # Can be easy, medium, or hard
    difficulty: "medium"
  }
}

