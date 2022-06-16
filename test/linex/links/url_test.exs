defmodule Linex.Links.UrlTest do
  use Linex.DataCase, async: true

  import Linex.Factory

  alias Ecto.Changeset
  alias Linex.Links.Url

  describe "changeset/2" do
    test "when all params are valid, returns a valid changeset" do
      params = build(:url_params)

      response = Url.changeset(params)

      assert %Changeset{
               changes: %{
                 code: "ABSDAS",
                 clicks: 2,
                 url: "http://google.com"
               },
               valid?: true
             } = response
    end

    test "when updating a changeset, returns a valid changeset with the given changes" do
      params = build(:url_params)

      update_params = %{
        code: "testx"
      }

      response =
        params
        |> Url.changeset()
        |> Url.changeset(update_params)

      assert %Changeset{changes: %{code: "testx"}, valid?: true} = response
    end

    test "when there are some error, returns an invalid changeset" do
      params = build(:url_invalid_params)

      response = Url.changeset(params)

      expected_response = %{
        clicks: ["can't be blank"],
        code: ["can't be blank"],
        url: ["can't be blank"]
      }

      assert errors_on(response) == expected_response
    end

    test "test the minimum code size" do
      params = build(:url_params) |> Map.put("code", "123")

      response = Url.changeset(params)

      expected_response = %{
        code: ["should be at least 5 character(s)"]
      }

      assert errors_on(response) == expected_response
    end

    test "test the maximum code size" do
      params = build(:url_params) |> Map.put("code", "123adassf234j23klkdasjnd,asmdnlkj")

      response = Url.changeset(params)

      expected_response = %{
        code: ["should be at most 25 character(s)"]
      }

      assert errors_on(response) == expected_response
    end

    test "test the url invalids" do
      params_one = build(:url_params) |> Map.put("url", "://google.com")
      params_two = build(:url_params) |> Map.put("url", "google.com")
      # params_three = build(:url_params, url: "https://google...com")

      response_one = Url.changeset(params_one)
      response_two = Url.changeset(params_two)
      # response_three = Url.changeset(params_three)

      assert errors_on(response_one) == %{url: ["is missing a scheme (e.g. https)"]}
      assert errors_on(response_two) == %{url: ["is missing a scheme (e.g. https)"]}
      # assert errors_on(response_three) == %{url: ["invalid host"]}
    end
  end
end
