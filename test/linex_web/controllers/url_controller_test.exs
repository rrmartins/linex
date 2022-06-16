defmodule LinexWeb.UrlControllerTest do
  use LinexWeb.ConnCase

  import Linex.Factory

  describe "index" do
    test "lists all urls", %{conn: conn} do
      url_one = insert(:url, code: "ABSA")
      url_two = insert(:url, code: "USAF")

      conn = get(conn, Routes.url_path(conn, :index))

      assert html_response(conn, 200) =~ url_one.code
      assert html_response(conn, 200) =~ url_two.code
    end
  end

  describe "new url" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.url_path(conn, :new))
      assert html_response(conn, 200) =~ "New Url"
    end
  end

  describe "create url" do
    test "redirects to show when data is valid", %{conn: conn} do
      url_attrs = build(:url_params)
      conn = post(conn, Routes.url_path(conn, :create), url: url_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.url_path(conn, :show, id)

      conn = get(conn, Routes.url_path(conn, :show, id))
      assert html_response(conn, 200) =~ url_attrs["url"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      invalid_attrs = build(:url_invalid_params)
      conn = post(conn, Routes.url_path(conn, :create), url: invalid_attrs)

      assert html_response(conn, 200) =~
               "<span class=\"invalid-feedback\" phx-feedback-for=\"url[url]\">can&#39;t be blank</span>"

      assert html_response(conn, 200) =~
               "Oops, something went wrong! Please check the errors below"
    end
  end
end
