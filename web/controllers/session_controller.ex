defmodule Infrapi.SessionController do
  use Infrapi.Web, :controller

  alias Infrapi.User

  def new(_conn, _params) do

  end

  def create(conn, params = %{}) do
    user = Repo.one(User, email: params["email"])
    if user != nil do
      changeset = User.login_changeset(user, params)
      if changeset.valid? do
        {:ok, jwt, full_claims} = Guardian.encode_and_sign(user, :token)
        json(conn, %{:jwt => jwt, :claims => full_claims})
      else
        put_status(conn, 401)
        |> json(%{:error => "invalid credentials: password"})
      end
    else
      put_status(conn, 401)
      |> json(%{:error => "invalid credentials: user"})
    end
  end

  def unauthenticated(conn, _params) do
    put_status(conn, 401)
    |> json(%{:error => "authentication required"})
  end
end
