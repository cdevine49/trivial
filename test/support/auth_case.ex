defmodule Trivial.AuthTest do
  alias Trivial.Accounts.User
  def login(conn, user), do: Plug.Test.init_test_session(conn, user_id: user.id)
  def logged_in(conn, %User{id: id}), do: id == Plug.Conn.get_session(conn, :user_id)
end
