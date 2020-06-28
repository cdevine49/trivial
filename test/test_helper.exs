Application.put_env(:wallaby, :base_url, TrivialWeb.Endpoint.url())
{:ok, _} = Application.ensure_all_started(:wallaby)
ExUnit.start()
