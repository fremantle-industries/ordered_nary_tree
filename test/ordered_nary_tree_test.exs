defmodule OrderedNaryTreeTest do
  use ExUnit.Case
  doctest OrderedNaryTree

  @empty_tree OrderedNaryTree.new()

  test ".new/0 creates an empty tree" do
    assert %OrderedNaryTree{} = tree = OrderedNaryTree.new()
    assert tree.root == nil
  end

  test ".root/1 returns the root node of the tree" do
    assert OrderedNaryTree.root(@empty_tree) == {:error, :empty_root}

    node_a = build_node("a")
    tree = OrderedNaryTree.new(node_a)
    assert {:ok, root_node} = OrderedNaryTree.root(tree)
    assert root_node == node_a
  end

  test ".children/1 returns the child nodes of the root node" do
    assert OrderedNaryTree.children(@empty_tree) == {:error, :empty_root}

    node_a = build_node("a")
    tree = OrderedNaryTree.new(node_a)
    assert OrderedNaryTree.children(tree) == {:ok, []}
  end

  test ".children/2 returns the child nodes of the given node id when found" do
    tree = OrderedNaryTree.new()
    id_not_found = make_ref()
    assert OrderedNaryTree.children(tree, id_not_found) == {:error, :empty_root}

    node_b = build_node("b")
    node_a = "a" |> build_node() |> OrderedNaryTree.Node.add_child(node_b)
    tree = OrderedNaryTree.new(node_a)

    assert {:ok, node_a_children} = OrderedNaryTree.children(tree, node_a.id)
    assert length(node_a_children) == 1
    assert Enum.at(node_a_children, 0) == node_b

    assert {:ok, node_b_children} = OrderedNaryTree.children(tree, node_b.id)
    assert length(node_b_children) == 0

    assert OrderedNaryTree.children(tree, id_not_found) == {:error, :not_found}
  end

  test ".add_child/3 appends the given node to the matching parent node" do
    id_not_found = make_ref()
    node_root = build_node("root")
    [node_a, node_b] = build_nodes(["a", "b"])
    [node_b_1, node_b_2] = build_nodes(["b_1", "b_2"])
    assert OrderedNaryTree.add_child(@empty_tree, id_not_found, node_root) == {:error, :empty_root}

    tree = OrderedNaryTree.new(node_root)
    assert OrderedNaryTree.add_child(tree, id_not_found, node_a) == {:error, :not_found}

    assert {:ok, tree} = OrderedNaryTree.add_child(tree, node_root.id, node_a)
    assert {:ok, node_root_children} = OrderedNaryTree.children(tree, node_root.id)
    assert length(node_root_children) == 1
    assert Enum.at(node_root_children, 0) == node_a
    assert {:ok, tree} = OrderedNaryTree.add_child(tree, node_root.id, node_b)
    assert {:ok, node_root_children} = OrderedNaryTree.children(tree, node_root.id)
    assert length(node_root_children) == 2
    assert Enum.at(node_root_children, 0) == node_a
    assert Enum.at(node_root_children, 1) == node_b

    assert {:ok, tree} = OrderedNaryTree.add_child(tree, node_b.id, node_b_1)
    assert {:ok, node_b_children} = OrderedNaryTree.children(tree, node_b.id)
    assert length(node_b_children) == 1
    assert Enum.at(node_b_children, 0) == node_b_1
    assert {:ok, tree} = OrderedNaryTree.add_child(tree, node_b.id, node_b_2)
    assert {:ok, node_b_children} = OrderedNaryTree.children(tree, node_b.id)
    assert length(node_b_children) == 2
    assert Enum.at(node_b_children, 0) == node_b_1
    assert Enum.at(node_b_children, 1) == node_b_2
    assert {:ok, node_root_children} = OrderedNaryTree.children(tree, node_root.id)
    assert length(node_root_children) == 1
  end

  test ".add_child/2 appends the given node to the root" do
    [node_a, node_b] = build_nodes(["a", "b"])
    assert OrderedNaryTree.add_child(@empty_tree, node_b) == {:error, :empty_root}

    tree = OrderedNaryTree.new(node_a)
    assert {:ok, tree} = OrderedNaryTree.add_child(tree, node_b)
    assert {:ok, root_children} = OrderedNaryTree.children(tree)
    assert length(root_children) == 1
    assert Enum.at(root_children, 0) == node_b
  end

  defp build_node(value) do
    OrderedNaryTree.Node.new(value)
  end

  defp build_nodes(values) do
    Enum.map(values, &build_node/1)
  end
end
