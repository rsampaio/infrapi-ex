defmodule Infrapi.Util do
  import Ecto.Query, only: [from: 1, from: 2, where: 2]
  defmacro __using__(_opts) do
    quote do
      def by_name_or_id(query, name_or_id) do
        filter = case ni = Integer.parse(name_or_id) do
                   :error ->
                     [name: name_or_id]
                   _ ->
                     [id: elem(ni, 0)]
                 end

        from c in query,
        where: ^filter,
        select: c
      end

      def for_project(query, project) do
        from c in query,
        join: p in assoc(c, :project),
        where: p.id == ^project.id,
        select: c
      end
    end
  end
end
