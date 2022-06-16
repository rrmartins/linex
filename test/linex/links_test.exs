defmodule Linex.LinksTest do
  use Linex.DataCase, async: true

  import Linex.Factory

  alias Ecto.UUID
  alias Linex.Links
  alias Linex.Links.Url

  describe "list_urls/0" do
    test "returns all urls" do
      url_one = insert(:url)
      url_two = insert(:url)
      assert Links.list_urls() == [url_one, url_two]
    end

    test "not returns urls" do
      assert Links.list_urls() == []
    end
  end

  describe "get_url!/1" do
    test "returns the url with given id and add more one click" do
      url = insert(:url, clicks: 0)
      assert url.clicks == 0

      assert fetch_url = Links.get_url(url.id)

      assert fetch_url.clicks == 1
    end

    test "returns error when not found the url" do
      assert Links.get_url(UUID.generate()) == {:error, "not found"}
    end
  end

  describe "create_url/1" do
    test "returns valid data creates a url" do
      url_params = build(:url_params)
      assert {:ok, %Url{} = url} = Links.create_url(url_params)
      assert url.clicks == 2
      assert url.url == "http://google.com"
      assert not is_nil(url.code)
    end

    test "returns invalid data returns error changeset" do
      invalid_attrs = build(:url_invalid_params)
      assert {:error, %Ecto.Changeset{}} = Links.create_url(invalid_attrs)
    end
  end

  describe "change_url/1" do
    test "returns a url changeset" do
      url = insert(:url)
      assert %Ecto.Changeset{} = Links.change_url(url)
    end
  end
end
