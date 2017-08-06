defmodule GetInputTest do
  use ExUnit.Case
  use ExVCR.Mock

  setup _session do
    {:ok, [id: "53616c7465645f5fb35d2e8e7973229fde2a3e9651ee924da36341f3f3c282b826575283cf90a7bf183048ec5a1a1614", url: "http://adventofcode.com/2015/day/1/input"]}
  end

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end

  test "does it run" do
    assert GetInput.getInput(1,'23') == :ok
  end

  test "can it make http requests", session do
    use_cassette("makerequest_valid") do
      {:ok, values} = GetInput.makeRequest(session[:url], session[:id])
      assert values =~ ~r/\)\(\)\(\(\(\(\(\(\(\)\(\)\)\)\)\)\(\)\(\)\(\(\(\(\)\(/
    end
  end

  test "invalid session should fail", session do 
    use_cassette("makerequest_invalid_session") do 
      assert {:fail, _values} = GetInput.makeRequest(session[:url], "veryinvalid")
    end
  end

  test "invalid url should fail" do 
    use_cassette("makerequest_invalid_url") do
      assert {:fail, _values} = GetInput.makeRequest("http://adgrentofcode.com/2015/day/1/input","i dont matter")
    end
  end

end