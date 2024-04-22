defmodule Ensemble do
  @moduledoc """
  Documentation for `Ensemble`.
  """

  # See https://github.com/A11yance/aria-query/blob/main/src/etc/roles/literal/gridcellRole.js

  @roles_to_selectors %{
    link: ~S|a[href]:not([href=""])|,
    main: ~S|main|,
    navigation: ~S|nav|,
    banner: ~S|body > header, header[role="banner"]|,
    contentinfo: ~S|body > footer, footer[role="contentinfo"]|,
    article: ~S|article|,
    region: ~S|section[aria-label], section[aria-labelledby]|,
    heading: ~S|h1, h2, h3, h4, h5, h6|,
    list: ~S|ul, ol|,
    listitem: ~S|ul > li, ol > li|,
    group: ~S|details, fieldset, optgroup, address|,
    figure: ~S|figure|,
    img: ~S|img:not([alt]), img:not([alt=""])|,
    presentation: ~S|img[alt=""]|,
    term: ~S|dt, dfn|,
    definition: ~S|dd|,
    table: ~S|table|,
    rowgroup: ~S|thead, tbody, tfoot|,
    row: ~S|tr|,
    cell: ~S|td|,
    button:
      ~S|button, input[type="button"], input[type="image"], input[type="reset"], input[type="submit"]|,
    status: ~S|output|,
    dialog: ~S|dialog|,
    form: ~S|form[aria-label], form[aria-labelledby]|,
    radio: ~S|input[type="radio"]|,
    option: ~S|option|,
    listbox: ~S|select:not([size="0"]):not([size="1"]), select[multiple]|,
    textbox:
      ~S|textarea, input:not([type]), | <>
        Enum.map_join(~w(text email tel url), fn type ->
          ~s|input[type="#{type}"]:not([list])|
        end),
    search: ~S|search, form[role="search"]|,
    searchbox: ~S|input[type="search"]:not([list])|
  }

  @doc """
  Lookup the selector for an ARIA role.
  """
  def selector_for_role(role)

  for {role, selector} <- @roles_to_selectors do
    def selector_for_role(unquote(role)) do
      unquote(selector)
    end
  end
end
