defmodule Lily.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Lily.Repo
  alias Lily.Accounts.User

  schema "users" do
    field :first_name, :string
    field :hashed_password, :string
    field :last_name, :string
    field :username, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :username])
    |> validate_required([:first_name, :last_name, :username])
    |> validate_format(:username, ~r/^[a-z0-9_-]*[a-b][a-z0-9_-]*$/i)
    |> validate_length(:username, mix: 4, max: 12)
    |> validate_length(:password, mix: 8, max: 100)
    |> validate_length(:first_name, mix: 1, max: 100)
    |> validate_length(:last_name, mix: 1, max: 100)
    |> unique_constraint(:username)
  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required(:password)
    |> changeset(attrs)
    |> put_hashed_password()
    |> put_random_username_id()
  end

  defp put_hashed_password(%Ecto.Changeset{valid?: false} = changeset) do
    changeset
  end

  defp put_hashed_password(%Ecto.Changeset{changes: %{password: password}} = changeset) do
    put_change(changeset, :hashed_password, Bcrypt.hash_pwd_salt(password))
  end

  defp put_random_username_id(%Ecto.Changeset{valid?: false} = changeset) do
    changeset
  end

  defp put_random_username_id(%Ecto.Changeset{changes: %{username: username}} = changeset) do
    username = "#{username}##{generate_random_username_id()}"

    if Repo.exists?(from(user in User, where: user.username == ^username)) do
      put_random_username_id(changeset)
    else
      put_change(changeset, :username, username)
    end
  end

  defp generate_random_username_id do
    1..4
    |> Enum.map(fn _ -> Enum.random(1..9) end)
    |> Enum.join("")
  end
end
