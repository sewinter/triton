defmodule Triton.NodeConfig do
  # https://hexdocs.pm/xandra/Xandra.html#start_link/1
  @xandra_start_link_options [
    :nodes,
    :compressor,
    :authentication,
    :atom_keys,
    :pool_size,
    :default_consistency,
    :protocol_version,
    :keyspace,
    :encryption,
    :transport_options
  ]

  def node_config(block) do
    node_config = Application.get_env(:triton, :clusters)
    |> Enum.find(&(&1[:conn] == block[:__schema__].__keyspace__.__struct__.__conn__))
    |> Keyword.take(@xandra_start_link_options)

    Keyword.put(node_config, :nodes, [node_config[:nodes] |> Enum.random()])
  end
end
