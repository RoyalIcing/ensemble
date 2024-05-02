defmodule EnsembleTest do
  use ExUnit.Case
  doctest Ensemble

  import Phoenix.LiveViewTest

  defmodule Example do
    use Phoenix.LiveView

    def render(_assigns) do
      assigns = %{name: "Mary"}

      ~H"""
      <body>
        <header>Banner</header>
        <main>Hello, <%= @name %>!</main>
        <footer>Contentinfo</footer>

        <nav aria-label="Primary">
          <a href="/">Home</a>
          <a href="/about">About</a>
          <a href="/privacy-policy">Privacy Policy</a>
          <a>Anchor</a>
        </nav>

        <img>
        <img alt="">
        <img alt="Really funny gif">

        <form aria-label="Sign Up">
          <label>Username <input></label>
          <fieldset>
            <legend>Theme</legend>
            <label><input type="radio" name="theme" value="scarlet"> Scarlet</label>
            <label><input type="radio" name="theme" value="violet"> Violet</label>
          </fieldset>
          <button>Create Account</button>
        </form>

        <form aria-label="Newsletter">
          <label>Email <input type="email"></label>
          <button type="button" aria-label="More info"><icon-info></icon-info></button>
          <label><input type="checkbox"> Send me daily updates</label>
          <button type="submit">Subscribe</button>
          <output>You are now subscribed!</output>
        </form>
      </body>
      """
    end
  end

  @endpoint Ensemble.TestEndpoint

  test "content" do
    conn = Phoenix.ConnTest.build_conn()
    {:ok, view, _html} = live_isolated(conn, Example)

    assert view
           |> Ensemble.role(:main)
           |> render() == "<main>Hello, Mary!</main>"

    role = &Ensemble.role(view, &1)

    assert role.(:banner) |> render() ==
             "<header>Banner</header>"

    assert role.(:contentinfo) |> render() ==
             "<footer>Contentinfo</footer>"

    assert view |> Ensemble.has_role?(:navigation)

    assert view |> Ensemble.role(:navigation) |> render() =~
             ~r|^<nav|

    assert view |> Ensemble.role(:navigation, "Primary") |> render() =~
             ~r|^<nav|

    assert view |> Ensemble.has_role?(:link)
    assert view |> Ensemble.has_role?(:link, "Home")
    assert view |> Ensemble.has_role?(:link, "About")
    assert view |> Ensemble.has_role?(:link, "Privacy Policy")
    assert view |> Ensemble.has_role?(:link, text_filter: "Home")
    assert view |> Ensemble.has_role?(:link, text_filter: "About")
    assert view |> Ensemble.has_role?(:link, text_filter: "Privacy Policy")

    refute view |> Ensemble.has_role?(:link, "Legal")
    refute view |> Ensemble.has_role?(:link, text_filter: "Legal")

    assert view |> Ensemble.role(:link, "Home") |> render() ==
             ~S|<a href="/">Home</a>|

    assert view |> Ensemble.role(:link, "About") |> render() ==
             ~S|<a href="/about">About</a>|

    assert view |> Ensemble.role(:link, text_filter: "Home") |> render() ==
             ~S|<a href="/">Home</a>|

    refute view |> Ensemble.role(:link, "Legal")

    assert view |> Ensemble.role(:img, "Really funny gif") |> render() ==
             ~S|<img alt="Really funny gif"/>|

    assert view |> Ensemble.role(:form, "Sign Up") |> render() =~ ~r|^<form|

    assert view |> Ensemble.has_role?(:textbox)
    assert view |> Ensemble.has_role?(:textbox, "Username")
    assert view |> Ensemble.has_role?(:textbox, "Email")
    refute view |> Ensemble.has_role?(:textbox, "Foo")
    assert view |> Ensemble.role(:textbox, "Username") |> render() == ~S|<input/>|
    assert view |> Ensemble.role(:textbox, "Email") |> render() =~ ~r|^<input type="email"|
    refute view |> Ensemble.role(:textbox, "Foo")

    # assert view |> Ensemble.has_role?(:group, "Theme")

    assert view |> Ensemble.has_role?(:radio, "Scarlet")
    assert view |> Ensemble.has_role?(:radio, "Violet")

    assert view |> Ensemble.role(:radio, "Violet") |> render() =~
             ~r|^<input type="radio" name="theme" value="violet"|

    assert view |> Ensemble.role(:button, text_filter: "Create Account") |> render() ==
             ~S|<button>Create Account</button>|

    assert view |> Ensemble.role(:button, "Create Account") |> render() ==
             ~S|<button>Create Account</button>|

    assert view |> Ensemble.role(:button, "More info") |> render() ==
             ~S|<button type="button" aria-label="More info"><icon-info></icon-info></button>|

    assert view |> Ensemble.role(:checkbox, "Send me daily updates")

    assert view |> Ensemble.role(:button, "Subscribe") |> render() ==
             ~S|<button type="submit">Subscribe</button>|

    assert view |> Ensemble.has_role?(:status)
  end
end

# Copied from https://github.com/phoenixframework/phoenix_live_view/blob/37bcbc4515efbedd3e85b3c0fbd39c4f88cea9f7/test/support/endpoint.ex#L21C1-L41C4
defmodule Ensemble.TestEndpoint do
  use Phoenix.Endpoint, otp_app: :ensemble

  # @before_compile Phoenix.LiveViewTest.EndpointOverridable

  socket("/live", Phoenix.LiveView.Socket)

  defoverridable url: 0, script_name: 0, config: 1, config: 2, static_path: 1
  def url(), do: "http://localhost:4004"
  def script_name(), do: []
  def static_path(path), do: "/static" <> path
  def config(:live_view), do: [signing_salt: "112345678212345678312345678412"]
  def config(:secret_key_base), do: String.duplicate("57689", 50)
  def config(:cache_static_manifest_latest), do: Process.get(:cache_static_manifest_latest)
  def config(:otp_app), do: :ensemble
  def config(:pubsub_server), do: Phoenix.LiveView.PubSub
  def config(:render_errors), do: [view: __MODULE__]
  def config(:static_url), do: [path: "/static"]
  def config(:live_reload), do: nil
  def config(which), do: super(which)
  def config(which, default), do: super(which, default)
end
