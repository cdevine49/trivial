defmodule Trivial.Accounts do
  alias Trivial.Accounts.User

  @doc """
  Creates a new user

  iex> { :ok, user } = Trivial.Accounts.create_user(%{ email: "a@a.io", password: "dingo blank square purple" })
  iex> %Trivial.Accounts.User{email: "a@a.io", verified: false} = user

  iex> { :error, changeset } = Trivial.Accounts.create_user(%{ email: "", password: "" })
  iex> %Ecto.Changeset{errors: [_|_]} = changeset
  """
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Trivial.Repo.insert()
  end

  @doc """
  Fetches a user

  iex> nil = Trivial.Accounts.get_user(nil)

  iex> alias Trivial.Accounts
  iex> alias Trivial.Accounts.User
  iex> { :ok, %User{id: id} } = Accounts.create_user(%{ email: "a@a.io", password: "passw3rd" })
  iex> %User{ id: ^id } = Accounts.get_user(id)

  iex> nil = Trivial.Accounts.get_user(0)
  """
  def get_user(nil), do: nil

  def get_user(id) do
    Trivial.Repo.get(User, id)
  end

  @doc """
  Authenticates a user

  iex> alias Trivial.Accounts
  iex> alias Trivial.Accounts.User
  iex> { :ok, %User{id: id} } = Accounts.create_user(%{ email: "a@a.io", password: "passw3rd" })
  iex> %User{ id: ^id } = Accounts.authenticate("a@a.io", "passw3rd")

  iex> Trivial.Accounts.create_user(%{ email: "a@a.io", password: "passw3rd" })
  iex> nil = Trivial.Accounts.authenticate("a@a.io", "wrong_pass")

  """
  def authenticate(email, password) do
    get_user_by_email(email)
    |> verify_password(password)
  end

  defp get_user_by_email(email), do: Trivial.Repo.get_by(User, email: email)

  defp verify_password(%User{} = user, password) do
    case Pbkdf2.verify_pass(password, user.password_hash) do
      true -> user
      false -> nil
    end
  end

  defp verify_password(nil, _) do
    Pbkdf2.no_user_verify()
    nil
  end
end
