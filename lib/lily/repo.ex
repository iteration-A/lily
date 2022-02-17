defmodule Lily.Repo do
  use Ecto.Repo,
    otp_app: :lily,
    adapter: Ecto.Adapters.Postgres
end
