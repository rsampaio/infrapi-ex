ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Infrapi.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Infrapi.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Infrapi.Repo)

