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
    # Email for the admin user (optional, can be omitted and set later through the website)
    admin_email: "${ADMIN_EMAIL}"
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
    database: "${POSTGRES_DB}"
    # username to connect to postgres
    user: "lemmy"
    # password to connect to postgres
    password: "${POSTGRES_PASSWORD}"
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
  # Email sending configuration. All options except login/password are mandatory
  email: {
    # Hostname and port of the smtp server
    smtp_server: "${SMTP_SERVER}"
    # Login name for smtp server
    smtp_login: "${SMTP_LOGIN}"
    # Password to login to the smtp server
    smtp_password: "${SMTP_PASSWORD}"
    # Address to send emails from, eg noreply@your-instance.com
    smtp_from_address: "${SMTP_FROM_ADDRESS}"
    # Whether or not smtp connections should use tls. Can be none, tls, or starttls
    tls_type: "${SMTP_TLS_TYPE}"
  }
  # Settings related to activitypub federation
  federation: {
    # Whether to enable activitypub federation.
    enabled: true
    # Allows and blocks are described here:
    # https://join-lemmy.org/docs/en/administration/federation_getting_started.html
    # 
    # list of instances with which federation is allowed
    allowed_instances: [
      lemmy.ml
    ]
    # Instances which we never federate anything with (but previously federated objects are unaffected)
    blocked_instances: []
    # If true, only federate with instances on the allowlist and block everything else. If false
    # use allowlist only for remote communities, and posts/comments in local communities
    # (meaning remote communities will show content from arbitrary instances).
    strict_allowlist: true
    # Number of workers for sending outgoing activities. Search logs for Activity queue stats to
    # see information. If running number is consistently close to the worker_count, you should
    # increase it.
    worker_count: 16
  }
  # rate limits for various user actions, by user ip
  rate_limit: {
    # Maximum number of messages created in interval
    message: 180
    # Interval length for message limit, in seconds
    message_per_second: 60
    # Maximum number of posts created in interval
    post: 6
    # Interval length for post limit, in seconds
    post_per_second: 600
    # Maximum number of registrations in interval
    register: 3
    # Interval length for registration limit, in seconds
    register_per_second: 3600
    # Maximum number of image uploads in interval
    image: 6
    # Interval length for image uploads, in seconds
    image_per_second: 3600
    # Maximum number of comments created in interval
    comment: 6
    # Interval length for comment limit, in seconds
    comment_per_second: 600
    search: 60
    # Interval length for search limit, in seconds
    search_per_second: 600
  }
}

