defmodule Linex.Factory do
  use ExMachina.Ecto, repo: Linex.Repo

  alias Linex.Links.Url

  def url_params_factory do
    %{
      clicks: 2,
      code: "ABSDAS",
      url: "http://google.com"
    }
  end

  def url_factory do
    %Url{
      clicks: 2,
      code: "ABSDAS",
      url: "http://google.com"
    }
  end
end
