class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class BST
  attr_accessor :root
  attr_reader :array

  def initialize(array)
    @array = array.sort.uniq
    @root = build_tree
  end

  def build_tree(array = @array, start = 0, a_end = array.length - 1)
    return nil if start > a_end

    mid = start + (a_end - start) / 2

    root = Node.new(array[mid])

    root.left = build_tree(array, start, mid - 1)
    root.right = build_tree(array, mid + 1, a_end)

    root
  end
end

bulsheesh = BST.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
p bulsheesh.root
