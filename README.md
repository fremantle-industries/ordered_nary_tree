# OrderedNaryTree
[![Build Status](https://github.com/fremantle-industries/ordered_nary_tree/workflows/test/badge.svg?branch=main)](https://github.com/fremantle-industries/ordered_nary_tree/actions?query=workflow%3Atest)
[![hex.pm version](https://img.shields.io/hexpm/v/ordered_nary_tree.svg?style=flat)](https://hex.pm/packages/ordered_nary_tree)

A struct based implementation of a pure Elixir ordered n-ary tree

## Installation

Add the `ordered_nary_tree` package to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ordered_nary_tree, "~> 0.0.3"}
  ]
end
```

## Usage

```elixir
# create a tree with a parent node as the root
parent = OrderedNaryTree.Node.new("parent")
tree = OrderedNaryTree.new(parent)

# create 2 children as descendants of the parent
child_1 = OrderedNaryTree.Node.new("child_1")
child_2 = OrderedNaryTree.Node.new("child_2")
{:ok, tree} = OrderedNaryTree.add_child(tree, parent.id, child_1)
{:ok, tree} = OrderedNaryTree.add_child(tree, parent.id, child_2)
{:ok, children} = OrderedNaryTree.children(tree, parent.id)
children == [child_1, child_2]

# create 2 grandchildren of the first child
grandchild_1 = OrderedNaryTree.Node.new("grandchild_1")
grandchild_2 = OrderedNaryTree.Node.new("grandchild_2")
{:ok, tree} = OrderedNaryTree.add_child(tree, child_1.id, grandchild_1)
{:ok, tree} = OrderedNaryTree.add_child(tree, child_1.id, grandchild_2)
{:ok, grandchildren_1} = OrderedNaryTree.children(tree, child_1.id)
grandchildren_1 == [grandchild_1, grandchild_2]

# create 1 grandchild of the second child
grandchild_3 = OrderedNaryTree.Node.new("grandchild_3")
{:ok, tree} = OrderedNaryTree.add_child(tree, child_2.id, grandchild_3)
{:ok, grandchildren_2} = OrderedNaryTree.children(tree, child_2.id)
grandchildren_2 == [grandchild_3]

# the root node is the original parent
{:ok, root} = OrderedNaryTree.root(tree)
root == parent
```

## Authors

- Alex Kwiatkowski - alex+git@fremantle.io

## License

`ordered_nary_tree` is released under the [MIT license](./LICENSE)
