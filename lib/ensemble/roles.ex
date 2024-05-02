defmodule Ensemble.Roles do
  @moduledoc """
  Index of ARIA roles.
  """

  # See https://github.com/A11yance/aria-query/blob/main/src/etc/roles/literal/gridcellRole.js

  @roles_to_selectors %{
    link: ~w|a[href]:not([href=""])|,
    main: ~w|main|,
    navigation: ~w|nav|,
    banner: ~w|body>header header[role="banner"]|,
    contentinfo: ~w|body>footer footer[role="contentinfo"]|,
    article: ~w|article|,
    region: ~w|section[aria-label] section[aria-labelledby]|,
    heading: ~w|h1 h2 h3 h4 h5 h6|,
    list: ~w|ul ol|,
    listitem: ~w|ul>li ol>li|,
    group: ~w|details fieldset optgroup address|,
    figure: ~w|figure|,
    img: ~w|img:not([alt]) img:not([alt=""])|,
    presentation: ~w|img[alt=""]|,
    term: ~w|dt dfn|,
    definition: ~w|dd|,
    table: ~w|table|,
    rowgroup: ~w|thead tbody tfoot|,
    row: ~w|tr|,
    cell: ~w|td|,
    button:
      ~w|button input[type="button"] input[type="image"] input[type="reset"] input[type="submit"]|,
    status: ~w|output|,
    dialog: ~w|dialog|,
    # form: ~w|form[aria-label] form[aria-labelledby]|,
    form: ~w|form|,
    radio: ~w|input[type="radio"]|,
    checkbox: ~w|input[type="checkbox"]|,
    option: ~w|option|,
    listbox: ~w|select:not([size="0"]):not([size="1"]) select[multiple]|,
    textbox:
      ~w|textarea input:not([type])| ++
        Enum.map(~w(text email tel url), fn type ->
          ~s|input[type="#{type}"]:not([list])|
        end),
    search: ~w|search form[role="search"]|,
    searchbox: ~w|input[type="search"]:not([list])|
  }

  # https://www.w3.org/WAI/ARIA/apg/practices/names-and-descriptions/
  @roles_named_by_content ~w(button cell checkbox columnheader gridcell heading link menuitem menuitemcheckbox menuitemradio option radio row rowheader switch tab tooltip)a

  @doc """
  Lookup the selector for an ARIA role.
  """
  def selector_for_role(role)

  for {role, selector} <- @roles_to_selectors do
    def selector_for_role(unquote(role)) do
      unquote(selector |> List.wrap() |> Enum.join(", "))
    end
  end

  @doc """
  Lookup the selector for an ARIA role with accessible name.
  """
  def selectors_for_role_named(role, accessible_name)

  def selectors_for_role_named(:img, accessible_name) do
    [~s|img[alt="#{escape_double_quotes(accessible_name)}"]|]
  end

  for role <- ~w(textbox checkbox radio status)a do
    def selectors_for_role_named(unquote(role), accessible_name) do
      for sel <- unquote(@roles_to_selectors[role]) do
        ~s|label:fl-contains("#{escape_double_quotes(accessible_name)}") #{sel}|
      end
    end
  end

  # for role <- ~w(group)a do
  #   def selectors_for_role_named(unquote(role), accessible_name) do
  #     [~s|fieldset:has(legend:fl-contains("#{escape_double_quotes(accessible_name)}"))|]
  #   end
  # end

  for role <- @roles_named_by_content -- ~w(checkbox radio)a do
    def selectors_for_role_named(unquote(role), accessible_name) do
      base_selectors = unquote(List.wrap(@roles_to_selectors[role]))

      List.flatten(
        for sel <- base_selectors do
          [
            ~s|#{sel}[aria-label="#{escape_double_quotes(accessible_name)}"]|,
            {sel, accessible_name}
          ]
        end
      )
    end
  end

  for role <- Map.keys(@roles_to_selectors) -- @roles_named_by_content,
      role not in ~w(img textbox status)a do
    def selectors_for_role_named(unquote(role), accessible_name) do
      base_selectors = unquote(List.wrap(@roles_to_selectors[role]))

      for sel <- base_selectors do
        ~s|#{sel}[aria-label="#{escape_double_quotes(accessible_name)}"]|
      end
    end
  end

  defp escape_double_quotes(s), do: String.replace(s, ~S|"|, ~S|\"|)
end
