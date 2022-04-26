defmodule OrderedNaryTree.NodeTest do
  use ExUnit.Case

  test ".new/1 returns a node struct with the value & generated id" do
    assert %OrderedNaryTree.Node{} = node_1 = OrderedNaryTree.Node.new("a")
    assert node_1.id != nil
    assert node_1.value == "a"

    assert %OrderedNaryTree.Node{} = node_2 = OrderedNaryTree.Node.new("b")
    assert node_2.id != nil
    assert node_2.value == "b"
    assert node_2.id != node_1.id
  end

  test ".add_child/2 appends the given child node to the parent" do
    node_a = OrderedNaryTree.Node.new("a")
    node_b = OrderedNaryTree.Node.new("b")
    node_c = OrderedNaryTree.Node.new("c")

    updated_node_a = OrderedNaryTree.Node.add_child(node_a, node_b)
    assert length(updated_node_a.children) == 1
    assert Enum.at(updated_node_a.children, 0) == node_b

    updated_node_a = OrderedNaryTree.Node.add_child(updated_node_a, node_c)
    assert length(updated_node_a.children) == 2
    assert Enum.at(updated_node_a.children, 1) == node_c
  end
end
