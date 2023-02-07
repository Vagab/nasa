defmodule NasaProgramTest do
  use ExUnit.Case
  doctest NasaProgram

  test "Apollo 11" do
    assert NasaProgram.fuel_amount(28801, [
             {:launch, 9.807},
             {:land, 1.62},
             {:launch, 1.62},
             {:land, 9.807}
           ]) == 51898
  end

  test "mission on Mars" do
    assert NasaProgram.fuel_amount(14606, [
             {:launch, 9.807},
             {:land, 3.711},
             {:launch, 3.711},
             {:land, 9.807}
           ]) == 33388
  end

  test "I am the passenger" do
    assert NasaProgram.fuel_amount(75432, [
             {:launch, 9.807},
             {:land, 1.62},
             {:launch, 1.62},
             {:land, 3.711},
             {:launch, 3.711},
             {:land, 9.807}
           ]) == 212_161
  end
end
