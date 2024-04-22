# Ensemble

An all-star cast of ARIA roles for Phoenix.[LiveViewTest](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveViewTest.html).

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
    {:ok, view, _html} = live(conn, "/todo")

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

  test "works", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/todo")

    assert view |> has_role?(:form, "New item")
    assert view |> has_role?(:textbox, "Description")
    assert view |> has_role?(:checkbox, "High priority")

    assert view
           |> role(:button, "Add item")
           |> render_click() =~ "Item created."
  end
end
```
