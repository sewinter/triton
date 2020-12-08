defmodule Triton.NodeConfig do
  # https://hexdocs.pm/xandra/Xandra.html#start_link/1
  @xandra_start_link_options [
    :nodes,
    :compressor,
    :authentication,
    :atom_keys,
    :default_consistency,
    :protocol_version,
    :keyspace,
    :encryption,
    :transport_options,
    :load_balancing,
    :autodiscovery,
    :autodiscovered_nodes_port
  ]

  def node_config(expected_conn) do
    node_config = Application.get_env(:triton, :clusters)
    |> Enum.find(&(&1[:conn] == expected_conn))
    |> Keyword.take(@xandra_start_link_options)

    Keyword.put(node_config, :nodes, [node_config[:nodes] |> Enum.random()])
  end
end
