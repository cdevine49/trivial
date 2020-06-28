defmodule TrivialWeb.SessionControllerTest do
  use TrivialWeb.ConnCase

  import Trivial.AuthTest, only: [login: 2, logged_in: 2]

  @valid_params %{email: "a@a.io", password: "G00d_pass! dogs-21 cats-13"}

  describe "new" do
    test "navigating to login page as unknown user", %{conn: conn} do
      conn = get(conn, "/session/new")
      assert html_response(conn, 200) =~ "Log in"
    end

    test "navigating to login page when user id in session", %{conn: conn} do
      {:ok, user} = Trivial.Accounts.create_user(%{email: "a@a.io", password: "abc123"})

      conn =
        conn
        |> login(user)
        |> get("/session/new")

      assert logged_in(conn, user)
      assert html_response(conn, 403) =~ "Dashboard"
      assert get_flash(conn, :error) == "A user is already logged in"
    end
  end

  describe "create" do
    test "logging in with registered email and correct password", %{conn: conn} do
      {:ok, user} = Trivial.Accounts.create_user(@valid_params)

      conn = post(conn, "/session", @valid_params)
      assert logged_in(conn, user)
      assert html_response(conn, 200) =~ "Dashboard"
    end

    test "logging in when already logged in", %{conn: conn} do
      {:ok, user} = Trivial.Accounts.create_user(@valid_params)

      conn =
        conn
        |> login(user)
        |> post("/session", @valid_params)

      assert logged_in(conn, user)
      assert html_response(conn, 403) =~ "Dashboard"
      assert get_flash(conn, :error) == "A user is already logged in"
    end

    test "logging in with an empty email", %{conn: conn} do
      {:ok, user} = Trivial.Accounts.create_user(@valid_params)
      conn = post(conn, "/session", %{@valid_params | email: ""})
      assert html_response(conn, 404) =~ "Log in"
      refute logged_in(conn, user)
      assert get_flash(conn, :error) == "Invalid Email or Password"
    end

    test "logging in with an unregistered email", %{conn: conn} do
      {:ok, user} = Trivial.Accounts.create_user(@valid_params)
      conn = post(conn, "/session", %{@valid_params | email: "bad@example.co.uk"})
      assert html_response(conn, 404) =~ "Log in"
      refute logged_in(conn, user)
      assert get_flash(conn, :error) == "Invalid Email or Password"
    end

    test "logging in with an empty password", %{conn: conn} do
      {:ok, user} = Trivial.Accounts.create_user(@valid_params)
      conn = post(conn, "/session", %{@valid_params | password: ""})
      assert html_response(conn, 404) =~ "Log in"
      refute logged_in(conn, user)
      assert get_flash(conn, :error) == "Invalid Email or Password"
    end

    test "logging in with wrong password", %{conn: conn} do
      {:ok, user} = Trivial.Accounts.create_user(@valid_params)
      session = %{@valid_params | password: "not my password"}
      conn = post(conn, "/session", session)
      assert html_response(conn, 404) =~ "Log in"
      refute logged_in(conn, user)
      assert get_flash(conn, :error) == "Invalid Email or Password"
    end
  end
end
