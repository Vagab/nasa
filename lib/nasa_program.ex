defmodule NasaProgram do
  @moduledoc """
  Module for inexplicably complicated computations
  required by NASA space program
  """

  @doc """
  Calculates the amount of fuel for the mission.
  Accepts the mass of the ship not including fuel as the first argument, and
  a list of tuples, where the first element is either :launch or :land, and
  the second element is the gravity of the planet from/on which we intend to
  launch/land as the second argument.g
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

  defp launch(mass, gravity), do: do_launch(gravity, [launching_fuel_amount(mass, gravity)])
  defp do_launch(_, [mass | masses]) when mass <= 0, do: Enum.sum(masses)

  defp do_launch(gravity, [mass | _] = acc) do
    do_launch(gravity, [launching_fuel_amount(mass, gravity) | acc])
  end

  # it's perhaps a better idea to use a decimal in the fuel calculations,
  # since we are dealing with a very high precision requirements.
  # But I didn't
  defp launching_fuel_amount(mass, gravity), do: (mass * gravity * 0.042 - 33) |> trunc()

  defp land(mass, gravity), do: do_land(gravity, [landing_fuel_amount(mass, gravity)])
  defp do_land(_, [mass | masses]) when mass <= 0, do: Enum.sum(masses)

  defp do_land(gravity, [mass | _] = acc) do
    do_land(gravity, [landing_fuel_amount(mass, gravity) | acc])
  end

  defp landing_fuel_amount(mass, gravity), do: (mass * gravity * 0.033 - 42) |> trunc()
end
