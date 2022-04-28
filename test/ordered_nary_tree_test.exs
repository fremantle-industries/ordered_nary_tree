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
    [node_a, node_b, node_c, node_d] = build_nodes(["a", "b", "c", "d"])
    [node_c_1, node_c_2] = build_nodes(["c_1", "c_2"])
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
    assert {:ok, tree} = OrderedNaryTree.add_child(tree, node_root.id, node_c)
    assert {:ok, node_root_children} = OrderedNaryTree.children(tree, node_root.id)
    assert length(node_root_children) == 3
    assert {:ok, tree} = OrderedNaryTree.add_child(tree, node_root.id, node_d)
    assert {:ok, node_root_children} = OrderedNaryTree.children(tree, node_root.id)
    assert length(node_root_children) == 4
    assert Enum.at(node_root_children, 0) == node_a
    assert Enum.at(node_root_children, 1) == node_b
    assert Enum.at(node_root_children, 2) == node_c
    assert Enum.at(node_root_children, 3) == node_d

    assert {:ok, tree} = OrderedNaryTree.add_child(tree, node_c.id, node_c_1)
    assert {:ok, node_c_children} = OrderedNaryTree.children(tree, node_c.id)
    assert length(node_c_children) == 1
    assert Enum.at(node_c_children, 0) == node_c_1
    assert {:ok, node_root_children} = OrderedNaryTree.children(tree, node_root.id)
    assert length(node_root_children) == 4

    assert {:ok, tree} = OrderedNaryTree.add_child(tree, node_c.id, node_c_2)
    assert {:ok, node_c_children} = OrderedNaryTree.children(tree, node_c.id)
    assert length(node_c_children) == 2
    assert Enum.at(node_c_children, 0) == node_c_1
    assert Enum.at(node_c_children, 1) == node_c_2
    assert {:ok, node_root_children} = OrderedNaryTree.children(tree, node_root.id)
    assert length(node_root_children) == 4
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

  test ".find/2 returns the node when the given function evaluates to true" do
    assert OrderedNaryTree.find(@empty_tree, & &1.value == "empty_root") == {:error, :empty_root}

    [root, child_1, child_2, grandchild_1] = build_nodes(["root", "child_1", "child_2", "grandchild_1"])
    tree = OrderedNaryTree.new(root)
    {:ok, tree} = OrderedNaryTree.add_child(tree, root.id, child_1)
    {:ok, tree} = OrderedNaryTree.add_child(tree, root.id, child_2)
    {:ok, tree} = OrderedNaryTree.add_child(tree, child_2.id, grandchild_1)

    assert {:ok, found_node} = OrderedNaryTree.find(tree, & &1.value == grandchild_1.value)
    assert found_node == grandchild_1

    assert OrderedNaryTree.find(tree, & &1.value == "not_found") == {:error, :not_found}
  end

  defp build_node(value) do
    OrderedNaryTree.Node.new(value)
  end

  defp build_nodes(values) do
    Enum.map(values, &build_node/1)
  end
end
