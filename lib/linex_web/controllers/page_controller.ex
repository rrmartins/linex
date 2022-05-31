defmodule LinexWeb.PageController do
  use LinexWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
