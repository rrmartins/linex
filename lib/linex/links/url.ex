defmodule Linex.Links.Url do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "urls" do
    field :clicks, :integer
    field :code, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(url \\ %__MODULE__{}, attrs) do
    url
    |> cast(attrs, [:clicks, :url, :code])
    |> validate_required([:clicks, :url, :code])
    |> validate_length(:code, min: 5, max: 25)
    |> validate_url(:url)
  end

  defp validate_url(changeset, field, opts \\ []) do
    validate_change(changeset, field, fn _, value ->
      value
      |> URI.parse()
      |> handle_parse()
      |> case do
        error when is_binary(error) -> [{field, Keyword.get(opts, :message, error)}]
        _ -> []
      end
    end)
  end

  defp handle_parse(%URI{scheme: nil}), do: "is missing a scheme (e.g. https)"
  defp handle_parse(%URI{host: nil}), do: "is missing a host"

  defp handle_parse(%URI{host: host}) do
    host = Kernel.to_charlist(host)

    case :inet.gethostbyname(host) do
      {:ok, _} -> nil
      {:error, _} -> "invalid host"
    end
  end
end
