defmodule TrivialWeb.GameController do
  use TrivialWeb, :controller
  plug :ensure_logged_in
  plug :ensure_owner when action in [:edit, :update, :delete]

  def new(conn, _) do
    # conn
  end

  def create(conn, _) do
    # conn
  end

  def index(conn, _) do
    # conn
  end

  def show(conn, _) do
    # conn
  end

  def edit(conn, _) do
    # conn
  end

  def update(conn, _) do
    # conn
  end

  def delete(conn, _) do
    # conn
  end

  defp ensure_logged_in(conn, %Trivial.Accounts.User{} = user), do: conn |> assign(:user, user)

  defp ensure_logged_in(conn, nil) do
    conn
    |> put_flash(:error, "You must log in")
    |> put_status(:unauthorized)
    |> put_view(TrivialWeb.SessionView)
    |> render("new.html")
    |> halt()
  end

  defp ensure_logged_in(conn, _) do
    user =
      get_session(conn, :user_id)
      |> Trivial.Accounts.get_user()

    ensure_logged_in(conn, user)
  end

  defp ensure_owner(conn, params) do
    game = Trivial.Hosts.get_game(params["id"])
    user = conn.assigns(:user)

    case game.owner do
      ^user ->
        conn

      _ ->
        conn
        |> put_flash(:error, "You do not own this game")
        |> put_status(:forbidden)
        |> put_view(TrivialWeb.GamesView)
        |> render("index.html")
        |> halt()
    end
  end
end
