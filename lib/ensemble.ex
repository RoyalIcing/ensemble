defmodule Ensemble do
  @moduledoc """
  Test LiveView with ARIA roles.

  If you are new to the concepts of accessible names or roles I recommend reading W3C’s guides:

  - [Landmark roles](https://www.w3.org/WAI/ARIA/apg/practices/landmark-regions/)
  - [Structual content roles](https://www.w3.org/WAI/ARIA/apg/practices/structural-roles/)
  - [Accessible names](https://www.w3.org/WAI/ARIA/apg/practices/names-and-descriptions/)

  Note: Ensemble has only a partial implementation of the accessible name algorithm, specifically it supports `aria-label` and descendant content but does not yet support `aria-labelledby` due to the constraints of selectors.
  """

  @doc """
  Find element with a unique `role` or accessible name combo to scope a function to.

  It expects the current LiveView, a role, and an [accessible name](https://www.w3.org/WAI/ARIA/apg/practices/names-and-descriptions/#whatareaccessiblenamesanddescriptions?).

  ## Examples

  ```elixir
  defmodule TodoLiveTest do
    use YourAppWeb.ConnCase, async: true

    import Phoenix.LiveViewTest
    import Ensemble

    test "has landmarks and nav", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/todos")

      assert view |> role(:banner) |> render() =~ ~r|^<header|
      assert view |> role(:main) |> render() =~ ~r|^<main|
      assert view |> role(:contentinfo) |> render() =~ ~r|^<footer|

      assert view |> role(:navigation, "Primary") =~ ~r|^<nav|
      assert view |> role(:link, "Home") =~ ~r|^<a href="/"|

    end

    test "subscribe form", %{conn: conn} do
      assert view |> role(:form) =~ ~r|^<form|
      assert view |> role(:textbox, "Email") =~ ~r|^<input type="text"|
      assert view |> role(:checkbox, "Send newsletter") =~ ~r|^<input type="checkbox"|
      assert view |> role(:button, "Subscribe") =~ ~r|^<button type="submit"|
    end

    test "submit form", %{conn: conn} do
      assert view
             |> role(:button, "Subscribe")
             |> render_click() =~ "Thanks for subscribing!"
    end
  end
  ```
  """
  def role(view, role, opts_or_accessible_name \\ [])

  def role(view, role, accessible_name) when is_atom(role) and is_binary(accessible_name) do
    selectors = Ensemble.Roles.selectors_for_role_named(role, accessible_name)

    selectors
    |> Enum.find_value(fn
      selector when is_binary(selector) ->
        if Phoenix.LiveViewTest.has_element?(view, selector) do
          Phoenix.LiveViewTest.element(view, selector)
        end

      {selector, text_content} when is_binary(selector) and is_binary(text_content) ->
        if Phoenix.LiveViewTest.has_element?(view, selector, text_content) do
          Phoenix.LiveViewTest.element(view, selector, text_content)
        end
    end)
  end

  def role(view, role, opts) when is_atom(role) and is_list(opts) do
    selector = Ensemble.Roles.selector_for_role(role)
    text_filter = opts[:text_filter]
    Phoenix.LiveViewTest.element(view, selector, text_filter)
  end

  @doc """
  Checks if the given element with `role` (and optional [accessible name](https://www.w3.org/WAI/ARIA/apg/practices/names-and-descriptions/#whatareaccessiblenamesanddescriptions?)) exists within `view`.

  ## Examples

  ```elixir
  defmodule TodoLiveTest do
    use YourAppWeb.ConnCase, async: true

    import Phoenix.LiveViewTest
    import Ensemble

    test "has landmarks", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/todos")

      assert view |> has_role?(:banner)
      assert view |> has_role?(:main)
      assert view |> has_role?(:contentinfo)

      assert view |> has_role?(:navigation, "Primary")

      refute view |> has_role?(:link, "Does not exist")
    end
  end
  ```
  """
  def has_role?(view, role, opts_or_accessible_name \\ [])

  def has_role?(view, role, accessible_name) when is_atom(role) and is_binary(accessible_name) do
    selectors = Ensemble.Roles.selectors_for_role_named(role, accessible_name)

    selectors
    |> Enum.any?(fn
      selector when is_binary(selector) ->
        Phoenix.LiveViewTest.has_element?(view, selector)

      {selector, text_content} when is_binary(selector) and is_binary(text_content) ->
        Phoenix.LiveViewTest.has_element?(view, selector, text_content)
    end)
  end

  def has_role?(view, role, opts) when is_atom(role) and is_list(opts) do
    selector = Ensemble.Roles.selector_for_role(role)
    text_filter = opts[:text_filter]
    Phoenix.LiveViewTest.has_element?(view, selector, text_filter)
  end
end
