defmodule Ambue.Repo do
  use Ecto.Repo,
    otp_app: :ambue,
    adapter: Ecto.Adapters.Postgres
end
