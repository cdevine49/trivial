# defmodule TrivialWeb.GameControllerTest do
#  use TrivialWeb.ConnCase
#
#  import Ecto.Query, only: [from: 2]
#  import Trivial.AuthTest, only: [login: 2]
#
#  alias Trivial.Repo
#  alias Trivial.Hosts.Game
#  """
#  Game
#
#  has a host
#  has a title
#
#  has many rounds
#
#  has many participation requests
#  has many participants
#
#  """
#
#  describe "when unauthenticated" do
#    test "GET /games/new", %{conn: conn} do
#      conn = get(conn, "/games/new")
#      assert html_response(conn, 401) =~ "Log in"
#      assert get_flash(conn, :error) == "You must log in"
#    end
#
#    test "POST /games", %{conn: conn} do
#      conn = post(conn, "/games")
#      assert Repo.one(from u in Game, select: count()) == 0
#      assert html_response(conn, 401) =~ "Log in"
#      assert get_flash(conn, :error) == "You must log in"
#    end
#
#    test "GET /games", %{conn: conn} do
#      conn = get(conn, "/games")
#      assert html_response(conn, 401) =~ "Log in"
#      assert get_flash(conn, :error) == "You must log in"
#    end
#
#    test "GET /games/:id", %{conn: conn} do
#      conn = get(conn, "/games/1")
#      assert html_response(conn, 401) =~ "Log in"
#      assert get_flash(conn, :error) == "You must log in"
#    end
#
#    test "GET /games/:id/edit", %{conn: conn} do
#      conn = get(conn, "/games/1/edit")
#      assert html_response(conn, 401) =~ "Log in"
#      assert get_flash(conn, :error) == "You must log in"
#    end
#
#    test "PUT /games/:id", %{conn: conn} do
#      conn = get(conn, "/games/1")
#      assert html_response(conn, 401) =~ "Log in"
#      assert get_flash(conn, :error) == "You must log in"
#    end
#
#    test "DELETE /games/:id", %{conn: conn} do
#      conn = get(conn, "/games/1")
#      assert html_response(conn, 401) =~ "Log in"
#      assert get_flash(conn, :error) == "You must log in"
#    end
#  end
#
#  describe "when forbidden" do
#    setup %{conn: conn} do
#      {:ok, user} = create_user
#      {:ok, game} = create_game
#      {:ok, conn: conn |> login(user), game: game}
#    end
#
#    test "GET /games/:id", %{conn: conn, game: %{id: id}} do
#      conn = get(conn, "/games/#{id}")
#      assert html_response(conn, 403) =~ "My Games"
#      assert get_flash(conn, :error) == "You do not own this game"
#    end
#
#    test "GET /games/:id/edit", %{conn: conn, game: %{id: id}} do
#      conn = get(conn, "/games/#{id}/edit")
#      assert html_response(conn, 403) =~ "My Games"
#      assert get_flash(conn, :error) == "You do not own this game"
#    end
#
#    test "PUT /games/:id", %{conn: conn, game: %{id: id}} do
#      conn = get(conn, "/games#{id}")
#      assert html_response(conn, 403) =~ "My Games"
#      assert get_flash(conn, :error) == "You do not own this game"
#    end
#
#    test "DELETE /games/:id", %{conn: conn, game: %{id: id}} do
#      conn = get(conn, "/games#{id}")
#      assert html_response(conn, 403) =~ "My Games"
#      assert get_flash(conn, :error) == "You do not own this game"
#    end
#  end
#
#  describe "not found" do
#    test "GET /games/:id", %{conn: conn} do
#      conn = get(conn, "/games/1")
#      assert html_response(conn, 404) =~ "Log in"
#      assert get_flash(conn, :error) == "You must log in"
#    end
#
#    test "GET /games/:id/edit", %{conn: conn} do
#      conn = get(conn, "/games/1/edit")
#      assert html_response(conn, 404) =~ "Log in"
#      assert get_flash(conn, :error) == "You must log in"
#    end
#
#    test "PUT /games/:id", %{conn: conn} do
#      conn = get(conn, "/games/1")
#      assert html_response(conn, 404) =~ "Log in"
#      assert get_flash(conn, :error) == "You must log in"
#    end
#
#    test "DELETE /games/:id", %{conn: conn} do
#      conn = get(conn, "/games/1")
#      assert html_response(conn, 404) =~ "Log in"
#      assert get_flash(conn, :error) == "You must log in"
#    end
#  end
#
#  defp create_user(email \\ "a@a.io") do
#    Trivial.Accounts.create_user(%{email: email, password: "abc123"})
#  end
#
#  defp create_game do
#    {:ok, user} = create_user("b@b.io")
#    {:ok, game} = Trivial.Hosts.create_game(%{title: "My Game", user_id: user.id})
#  end
# end
#
