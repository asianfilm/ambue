defmodule Ambue.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @email ~r/^[a-z0-9._%+-+']+@[a-z0-9.-]+\.[a-z]+$/i

  schema "users" do
    field :email, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> unique_constraint(:email, name: "users_email_index", message: "Email already in use")
    |> unique_constraint(:name, name: "users_name_index", message: "Name already in use")
    |> validate_length(:name, min: 3, max: 30)
    |> validate_format(:email, @email, message: "Please enter a valid email!")
  end
end
