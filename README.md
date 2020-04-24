# Docker-Phoenix

## Getting Started

1. Create the directory where your app will live

		$ mkdir path/to/blog

2. Clone this repo into that directory

		$ git clone git@github.com:cdevine49/docker-phoenix.git path/to/blog

3. Build the service

		$ docker-compose build

4. Create the application

		$ docker-compose run web mix phx.new . --app blog

5. Modify `config/dev.exs` to point to the `db` container
		
		# Configure your database
		config :blog, Blog.Repo,
			username: "postgres",
			password: "postgres",
			database: "blog_dev",
			hostname: "db",
			show_sensitive_data_on_connection_error: true,
			pool_size: 10

6. Create the database

		$ docker-compose run web mix ecto.create

7. Start the application

		$ docker-compose up
