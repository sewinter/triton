defmodule Triton.Setup.Keyspace do
  def setup(blueprint) do
    try do
      node_config = Triton.NodeConfig.node_config(blueprint)
      {:ok, _apps} = Application.ensure_all_started(:xandra)
      {:ok, conn} = Xandra.start_link(node_config)

      statement = build_cql(blueprint |> Map.delete(:__struct__))
      Xandra.execute!(conn, statement, _params = [])
    rescue
      err -> IO.inspect(err)
    end
  end

  defp build_cql(blueprint) do
    create_cql(blueprint[:__name__]) <>
    with_options_cql(blueprint[:__with_options__])
  end

  defp create_cql(name), do: "CREATE KEYSPACE IF NOT EXISTS #{name}"

  defp with_options_cql(opts) when is_list(opts) do
    cql = opts
      |> Enum.map(fn opt -> with_option_cql(opt) end)
      |> Enum.join(" AND ")

    " WITH " <> cql
  end
  defp with_options_cql(_), do: ""

  defp with_option_cql({option, value}), do: "#{String.upcase(to_string(option))} = #{value}"
end
