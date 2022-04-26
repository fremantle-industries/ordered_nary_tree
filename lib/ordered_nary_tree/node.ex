defmodule OrderedNaryTree.Node do
  @type id :: reference
  @type t :: %__MODULE__{
    id: id,
    value: term,
    children: [t]
  }

  @enforce_keys ~w[id value children]a
  defstruct ~w[id value children]a

  @spec new(term) :: t
  def new(value) do
    id = generate_id()

    %__MODULE__{
      id: id,
      value: value,
      children: []
    }
  end

  @spec add_child(parent :: t, child :: t) :: updated_parent :: t
  def add_child(parent_node, child_node) do
    children = parent_node.children ++ [child_node]
    %{parent_node | children: children}
  end

  defp generate_id do
    make_ref()
  end
end
