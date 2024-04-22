defmodule RolesTest do
  use ExUnit.Case
  doctest Ensemble.Roles

  test "link" do
    assert Ensemble.Roles.selector_for_role(:link) === ~S|a[href]:not([href=""])|
  end

  test "button" do
    assert Ensemble.Roles.selector_for_role(:button) ===
             ~S|button, input[type="button"], input[type="image"], input[type="reset"], input[type="submit"]|
  end
end
