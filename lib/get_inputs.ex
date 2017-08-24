defmodule AdventOfCodeHelper.GetInputs do
  alias AdventOfCodeHelper.FileCache
  @moduledoc """
  Contains all the logic for actually grabbing data from the website
  """

  @doc """
  Checks to see if we already have this input, else will go and get it
  ## Parameters
    - Year: Int for year of puzzle
    - Day: Int for day of puzzle
    - Session: Session variable for authenticating against AoC
  """
  def get_value(year, day, session, http_mod \\ Tesla, cache_mod \\ FileCache) do
    case cache_mod.in_cache?(year,day) do
      true -> cache_mod.get_file(year,day)
      false -> save_and_return(year,day,session, http_mod, cache_mod)
    end
  end

  defp save_and_return(year,day,session, http_mod, cache_mod) do
    case generate_url(year,day) |> get_from_url(session, http_mod) do
      {:ok, contents} -> cache_mod.save_file(year,day,contents)
                         {:ok, contents}
      {:fail, message} -> {:fail, message}
    end
  end

  defp get_from_url(url, session, http_mod) do
    response = http_mod.get(url, [headers: %{"cookie" => "session=#{session}"}])
    case response.status do
      200 -> {:ok, response.body}
      _ -> {:fail, response.body}
    end
  end

  defp generate_url(year,day) do
    "http://adventofcode.com/#{year}/day/#{day}/input"
  end
end
