defmodule Ensemble do
  @moduledoc """
  Test LiveView with ARIA roles.
  """

  @doc """
  Lookup the selector for an ARIA role.
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
  Checks if the given element with `role` exists on the page.
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
