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
      case URI.parse(value) do
        %URI{scheme: nil} ->
          "is missing a scheme (e.g. https)"

        %URI{host: nil} ->
          "is missing a host"

        %URI{host: host} ->
          case :inet.gethostbyname(Kernel.to_charlist(host)) do
            {:ok, _} -> nil
            {:error, _} -> "invalid host"
          end
      end
      |> case do
        error when is_binary(error) -> [{field, Keyword.get(opts, :message, error)}]
        _ -> []
      end
    end)
  end
end
