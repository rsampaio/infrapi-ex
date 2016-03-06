defmodule Infrapi.User do
  use Infrapi.Web, :model

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true

    timestamps
  end

  @required_fields ~w(email encrypted_password)
  @login_fields ~w(email password)
  @optional_fields ~w(password)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> ensure_encrypted
  end

  def login_changeset(model, params) do
    model
    |> cast(params, @login_fields, ~w())
    |> validate_password
  end

  def valid_password?(nil, _), do: false
  def valid_password?(_, nil), do: false
  def valid_password?(password, crypted), do: Comeonin.Bcrypt.checkpw(password, crypted)

  def validate_password(changeset) do
    case Ecto.Changeset.get_field(changeset, :encrypted_password) do
      nil -> password_incorrect(changeset)
      crypted -> validate_password(changeset, crypted)
    end
  end

  def validate_password(changeset, crypted) do
    password = Ecto.Changeset.get_change(changeset, :password)
    if valid_password?(password, crypted) do
      changeset
    else
      password_incorrect(changeset)
    end
  end

  defp password_incorrect(changeset) do
    Ecto.Changeset.add_error(changeset, :error, "invalid credentials")
  end

  def ensure_encrypted(changeset) do
    case Ecto.Changeset.fetch_change(changeset, :password) do
      {:ok, password} ->
        changeset
        |> Ecto.Changeset.put_change(:encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      :error -> changeset
    end
  end
end
