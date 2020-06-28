defmodule TrivialWeb.UserController do
  use TrivialWeb, :controller

  alias Trivial.Accounts

  plug :ensure_logged_out when action in [:new, :create]

  def new(conn, _params) do
    changeset = Accounts.User.changeset(%Accounts.User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    Accounts.create_user(%{email: email, password: password})
    |> case do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_status(:created)
        |> put_view(TrivialWeb.DashboardView)
        |> render("index.html")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("new.html", changeset: changeset)
    end
  end

  defp ensure_logged_out(conn, nil), do: conn

  defp ensure_logged_out(conn, %Accounts.User{}) do
    conn
    |> put_flash(:error, "You are already logged in")
    |> redirect(to: "/")
    |> halt()
  end

  defp ensure_logged_out(conn, _) do
    user =
      get_session(conn, :user_id)
      |> Accounts.get_user()

    ensure_logged_out(conn, user)
  end
end
