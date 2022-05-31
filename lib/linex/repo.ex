defmodule Linex.Repo do
  use Ecto.Repo,
    otp_app: :linex,
    adapter: Ecto.Adapters.Postgres
end
