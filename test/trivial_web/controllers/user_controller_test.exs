defmodule TrivialWeb.AccountControllerTest do
  use TrivialWeb.ConnCase
  doctest Trivial.Accounts

  import Ecto.Query, only: [from: 2]
  import Trivial.AuthTest, only: [login: 2, logged_in: 2]

  alias Trivial.Repo
  alias Trivial.Accounts.User

  @valid_params %{email: "a@a.io", password: "G00d_pass! dogs-21 cats-13"}

  describe "new" do
    test "navigating to account registration page as unknown user", %{conn: conn} do
      conn = get(conn, "/users/new")
      assert html_response(conn, 200) =~ "Create Your Account"
    end

    test "navigating to account registration page when logged in", %{conn: conn} do
      {:ok, user} = Trivial.Accounts.create_user(@valid_params)

      conn =
        conn
        |> login(user)
        |> get("/users/new")

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) == "You are already logged in"
    end
  end

  describe "create" do
    test "registering account with valid params", %{conn: conn} do
      conn = post(conn, "/users", user: @valid_params)
      assert user = Repo.get_by(User, email: @valid_params.email, verified: false)
      assert logged_in(conn, user)
      assert html_response(conn, 201) =~ "Dashboard"
    end

    test "registering account while session exists", %{conn: conn} do
      {:ok, user} = Trivial.Accounts.create_user(%{email: "b@a.io", password: "abc123"})

      conn =
        conn
        |> login(user)
        |> post("/users", user: @valid_params)

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) == "You are already logged in"
    end

    test "registering with empty email", %{conn: conn} do
      conn = post(conn, "/users", user: %{@valid_params | email: ""})
      assert Repo.one(from u in User, select: count()) == 0
      assert html_response(conn, 422) =~ "Create Your Account"
    end

    test "registering with empty password", %{conn: conn} do
      conn = post(conn, "/users", user: %{@valid_params | password: ""})
      assert Repo.one(from u in User, select: count()) == 0
      assert html_response(conn, 422) =~ "Create Your Account"
    end

    test "registering with illegal email", %{conn: conn} do
      account = %{@valid_params | email: "no-at"}
      conn = post(conn, "/users", user: account)
      assert Repo.one(from u in User, select: count()) == 0
      assert html_response(conn, 422) =~ "Create Your Account"
    end

    test "registering with short password", %{conn: conn} do
      user = %{@valid_params | password: "short"}
      conn = post(conn, "/users", user: user)
      assert Repo.one(from u in User, select: count()) == 0
      assert html_response(conn, 422) =~ "Create Your Account"
    end

    test "registering with previously used email", %{conn: conn} do
      post(conn, "/users", user: @valid_params)

      conn = post(conn, "/users", user: @valid_params)
      assert Repo.one(from u in User, select: count()) == 1
      assert html_response(conn, 422) =~ "Create Your Account"
    end
  end
end
