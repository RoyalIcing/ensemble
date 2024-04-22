defmodule EnsembleTest do
  use ExUnit.Case
  doctest Ensemble

  test "link" do
    assert Ensemble.selector_for_role(:link) == ~S|a[href]:not([href=""])|
  end
end
