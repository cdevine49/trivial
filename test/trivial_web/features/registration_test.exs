defmodule Trivial.Features.RegistrationTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  import Wallaby.Query, only: [text_field: 1, button: 1]

  feature "user signs up with invalid attributes", %{session: session} do
    session
    |> visit("/users/new")
    |> fill_in(text_field("Email"), with: "me[at]example.com")
    |> fill_in(text_field("Password"), with: "")
    |> click(button('Submit'))

    assert_text(session, "has invalid format")
    assert_text(session, "can't be blank")
  end

  feature "user signs up with valid attributes", %{session: session} do
    session
    |> visit("/users/new")
    |> fill_in(text_field("Email"), with: "me@example.com")
    |> fill_in(text_field("Password"), with: "Good pass 1")
    |> click(button('Submit'))

    assert_text(session, "Dashboard")
  end
end
