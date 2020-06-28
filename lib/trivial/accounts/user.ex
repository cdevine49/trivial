defmodule Trivial.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :verified, :boolean, default: false

    timestamps()
  end

  def changeset(%Trivial.Accounts.User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> unique_constraint([:email])
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{changes: %{password: pass}, errors: []} = changeset) do
    put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))
  end

  defp put_pass_hash(%Ecto.Changeset{} = changeset) do
    changeset
  end
end
