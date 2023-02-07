defmodule NasaProgram do
  @moduledoc """
  Module for inexplicably complicated computations
  required by NASA space program
  """

  @doc """
  Calculates the amount of fuel for the mission.
  Accepts the mass of the ship not including fuel as the first argument, and
  a list of launches and landings as the second argument
  """
  @spec fuel_amount(pos_integer(), list({:launch, float()} | {:land, float()})) :: pos_integer()
  def fuel_amount(rocket_mass, stops) do
    fuel =
      stops
      # we have to think from the end here, dynamic programming & all that.
      # Intuitive way to understand this is as follows:
      # if we calculate it without reversing the order
      # then when we calculate the amount of fuel for the second step,
      # we'd have to adjust the amount of fuel in the first step.
      # Calculating from the end does not have such weakness.
      |> Enum.reverse()
      |> Enum.reduce(rocket_mass, fn
        {:launch, gravity}, acc -> acc + launch(acc, gravity)
        {:land, gravity}, acc -> acc + land(acc, gravity)
      end)

    fuel - rocket_mass
  end

  defp launch(mass, gravity, acc \\ 0)

  defp launch(mass, gravity, acc) do
    fuel = launching_fuel_amount(mass, gravity)

    # if amount of fuel required to lift the mass is greater
    # than 0, then we have to bring more fuel with us.
    if fuel > 0 do
      launch(fuel, gravity, acc + fuel)
    else
      acc
    end
  end

  # it's perhaps a better idea to use a decimal in the fuel calculations,
  # since we are dealing with a very high precision requirements.
  # But I didn't
  defp launching_fuel_amount(mass, gravity), do: (mass * gravity * 0.042 - 33) |> trunc()

  defp land(mass, gravity, acc \\ 0)

  defp land(mass, gravity, acc) do
    fuel = landing_fuel_amount(mass, gravity)

    if fuel > 0 do
      land(fuel, gravity, acc + fuel)
    else
      acc
    end
  end

  defp landing_fuel_amount(mass, gravity), do: (mass * gravity * 0.033 - 42) |> trunc()
end
