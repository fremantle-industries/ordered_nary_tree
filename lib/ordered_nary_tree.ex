defmodule OrderedNaryTree do
  @moduledoc """
  A struct based implementation of a pure Elixir ordered n-ary tree
  """

  @type tree_node :: OrderedNaryTree.Node.t()
  @type tree_node_id :: OrderedNaryTree.Node.id()
  @type t :: %OrderedNaryTree{root: tree_node | nil}

  defstruct ~w[root]a

  @spec new(tree_node | nil) :: t
  def new(root \\ nil) do
    %OrderedNaryTree{root: root}
  end

  @spec root(t) :: {:ok, tree_node} | {:error, :empty_root}
  def root(tree) do
    case tree.root do
      %OrderedNaryTree.Node{} = n -> {:ok, n}
      nil -> {:error, :empty_root}
    end
  end

  @spec children(t) :: {:ok, [tree_node]} | {:error, :empty_root}
  def children(tree) do
    case OrderedNaryTree.root(tree) do
      {:ok, r} -> {:ok, r.children}
      {:error, :empty_root} = error -> error
    end
  end

  @spec children(t, tree_node_id) :: {:ok, [tree_node]} | {:error, :empty_root | :not_found}
  def children(tree, node_id) do
    case find_node(tree.root, node_id) do
      {:ok, n} -> {:ok, n.children}
      {:error, _} = error -> error
    end
  end

  @spec add_child(t, tree_node_id, tree_node) :: {:ok, t} | {:error, :empty_root | :not_found}
  def add_child(tree, parent_node_id, child_node) do
    tree.root
    |> replace_node(parent_node_id, & OrderedNaryTree.Node.add_child(&1, child_node))
    |> case do
      {:ok, root} -> {:ok, OrderedNaryTree.new(root)}
      {:error, _} = error -> error
    end
  end

  @spec add_child(t, tree_node) :: {:ok, t} | {:error, :empty_root}
  def add_child(tree, child_node) do
    case OrderedNaryTree.root(tree) do
      {:ok, root} -> OrderedNaryTree.add_child(tree, root.id, child_node)
      {:error, :empty_root} = error -> error
    end
  end

  defp find_node([], _search_id), do: {:error, :not_found}
  defp find_node(nil, _search_id), do: {:error, :empty_root}
  defp find_node(%OrderedNaryTree.Node{id: id} = n, search_id) when id == search_id, do: {:ok, n}
  defp find_node(%OrderedNaryTree.Node{children: c}, search_id), do: find_node(c, search_id)
  defp find_node([n | nodes], search_id) do
    case find_node(n, search_id) do
      {:ok, _n} = result -> result
      {:error, :not_found} -> find_node(nodes, search_id)
    end
  end

  defp replace_node(n, search_id, func, parent_node \\ nil) do
    case n do
      nil ->
        {:error, :empty_root}

      [] ->
        {:error, :not_found}

      %OrderedNaryTree.Node{id: id} = n when id == search_id ->
        {:ok, func.(n)}

      %OrderedNaryTree.Node{children: c} = n ->
        replace_node(c, search_id, func, n)

      [n | nodes] ->
        case replace_node(n, search_id, func, parent_node) do
          {:ok, n} -> {:ok, %{parent_node | children: [n] ++ nodes}}
          {:error, :not_found} -> replace_node(nodes, search_id, func, parent_node)
        end
    end
  end
end
