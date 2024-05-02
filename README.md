# Ensemble

[Docs](https://hexdocs.pm/ensemble/)

An all-star cast of ARIA roles for Phoenix [LiveViewTest](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveViewTest.html).

Ensemble is a library for testing Phoenix LiveView. You write your test using ARIA roles instead of CSS selectors. It means you are incentivised to improve your accessibility, have easier to read tests, and your test is less coupled to a particular implementation making refactoring easier.

If you are new to the concepts of ARIA roles or accessible names I recommend reading W3C’s guides:

- [Landmark roles](https://www.w3.org/WAI/ARIA/apg/practices/landmark-regions/)
- [Structual content roles](https://www.w3.org/WAI/ARIA/apg/practices/structural-roles/)
- [Accessible names](https://www.w3.org/WAI/ARIA/apg/practices/names-and-descriptions/)

## Installation

Install via [Hex](https://hex.pm/) by adding `ensemble` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ensemble, "~> 0.0.1"}
  ]
end
```

## Usage

Write a [LiveViewTest](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveViewTest.html) and `import Ensemble`.

```elixir
defmodule TodoLiveTest do
  use YourAppWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Ensemble

  test "has navigation", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/todos")

    assert view |> has_role?(:banner)
    assert view |> has_role?(:contentinfo)

    assert view |> has_role?(:navigation, "Primary")
    assert view |> has_role?(:link, "Home")
    assert view |> has_role?(:link, "About")
    assert view |> has_role?(:button, "Sign Out")

    refute view |> has_role?(:link, "Does not exist")

    assert view
           |> role(:link, "Home")
           |> render() == ~S|<a href="/">Home</a>|
  end

  test "form", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/todos")

    assert view |> has_role?(:form, "New item")
    assert view |> has_role?(:textbox, "Description")
    assert view |> has_role?(:checkbox, "High priority")

    assert view
           |> role(:button, "Add item")
           |> render_click() =~ "Item created."
  end
end
```
