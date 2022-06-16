defmodule LinexWeb.UrlController do
  use LinexWeb, :controller

  alias Linex.Links
  alias Linex.Links.Url

  def index(conn, _params) do
    urls = Links.list_urls()
    render(conn, "index.html", urls: urls)
  end

  def new(conn, _params) do
    changeset = Links.change_url(%Url{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"url" => url_params}) do
    case Links.create_url(url_params) do
      {:ok, url} ->
        conn
        |> put_flash(:info, "Url created successfully.")
        |> redirect(to: Routes.url_path(conn, :show, url))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    url = Links.get_url(id)
    render(conn, "show.html", url: url)
  end
end
