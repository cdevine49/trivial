defmodule Trivial.Features.LoginTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  import Wallaby.Query, only: [text_field: 1, button: 1]

  feature "user logs in with unregistered email", %{session: session} do
    session
    |> visit("/session/new")
    |> fill_in(text_field("Email"), with: "me@example.com")
    |> fill_in(text_field("Password"), with: "some-password")
    |> click(button('Submit'))

    assert_text(session, "Invalid Email or Password")
    assert_text(session, "Log in")
  end

  feature "user logs in with incorrect password", %{session: session} do
    {:ok, _} = Trivial.Accounts.create_user(%{email: "a@a.io", password: "G00d_pass! "})

    session
    |> visit("/session/new")
    |> fill_in(text_field("Email"), with: "a@a.io")
    |> fill_in(text_field("Password"), with: "Bad pass? ")
    |> click(button('Submit'))

    assert_text(session, "Invalid Email or Password")
    assert_text(session, "Log in")
  end

  feature "user logs in with valid credentials", %{session: session} do
    {:ok, _} = Trivial.Accounts.create_user(%{email: "a@a.io", password: "G00d_pass! "})

    session
    |> visit("/session/new")
    |> fill_in(text_field("Email"), with: "a@a.io")
    |> fill_in(text_field("Password"), with: "G00d_pass! ")
    |> click(button('Submit'))

    assert_text(session, "Dashboard")
  end
end
