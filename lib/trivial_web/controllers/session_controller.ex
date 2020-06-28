defmodule TrivialWeb.SessionController do
  use TrivialWeb, :controller
  plug :ensure_logged_out when action in [:new, :create]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"email" => email, "password" => password}) do
    Trivial.Accounts.authenticate(email, password)
    |> case do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_flash(:error, "Invalid Email or Password")
        |> render("new.html")

      user ->
        conn
        |> put_session(:user_id, user.id)
        |> put_view(TrivialWeb.DashboardView)
        |> render("index.html")
    end
  end

  defp ensure_logged_out(conn, nil), do: conn

  defp ensure_logged_out(conn, %Trivial.Accounts.User{}) do
    conn
    |> put_flash(:error, "A user is already logged in")
    |> put_status(:forbidden)
    |> put_view(TrivialWeb.DashboardView)
    |> render("index.html")
    |> halt()
  end

  defp ensure_logged_out(conn, _) do
    user =
      get_session(conn, :user_id)
      |> Trivial.Accounts.get_user()

    ensure_logged_out(conn, user)
  end
end
