class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  # check if the node is a leaf that is, it has not child.
  def leaf?
    return true if left.nil? && right.nil?
    false
  end

  # check if node only has 1 child.
  def only_child?
    if left.nil? && right || right.nil? && left
      return true
    else 
      return false
    end
  end

  # check for both childs
  def childs?
    return true if left && right
    false
  end

  def get_child
    return left if left
    return right if right
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

  # get child
  

  # fin the node
  def find(value, root=@root)
    return root if root.data == value

    if value < root.data
      find(value, root.left)
    else
      find(value, root.right)
    end

    
  end

  # find the last node before the current one.
  def find_last(value, root =@root,last = nil)
    return last if root.data == value
    
    if value < root.data
      find_last(value, root.left, last = root)
    else
      find_last(value, root.right, last = root)
    end 
  end

  # Insert a node with a given value
  def insert(value, root = @root)
    if root.leaf?
      return root.left = Node.new(value) if value < root.data
      return root.right = Node.new(value) if value > root.data
    end

    if value < root.data
      insert(value, root.left)
    else
      insert(value, root.right)
    end
  end

  def delete(key, root = @root, last = nil)
    

    if root.data == key
      if root.leaf? && last.data < key
        return last.right = nil
      elsif root.leaf? && last.data > key
        return last.left = nil
      end

      if root.only_child? && last.data < key
        return last.right = root.get_child
      elsif root.only_child? && last.data > key
        return last.left = root.get_child
      end
      
      if root.childs?
        swap = min_valuenode(root.right)
        delete(swap.data)
        return root.data = swap.data
      end

    end

    if key < root.data
      delete(key, root.left, root)
    elsif key > root.data
      delete(key, root.right, root)
    end
  end

  def inorder(root = @root)
    if !root.nil?
      inorder(root.left)
      p (root.data)
      inorder(root.right)
    end
  end

  # return the min value node in the tree
  def min_valuenode(node = @root)
    current = node

    while current.left != nil
      current = current.left
    end

    current
  end

  def max_valuenode(node = @root)
    current = node

    while current.right != nil
      current = current.right
    end

    current
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def level_order
    #ini empty queue
    queue = []
    values = []
    #store first item in the queue
    queue.push(root)
    #loop throught the queue check the items
    while queue.length > 0 
      childs = []
      #get childs from all the items
      for item in queue
        if item == nil
          next
        else
          values.push(item.data)
          yield(item) if block_given?
          childs.push(item.left)
          childs.push(item.right)
        end
      end
      #remove item from the queue
      queue.clear
      # add the childs to the queue
      for item in childs
        queue.push(item)
      end 
    end
    return values if !block_given?
  end

  def recursive_level_oder(queue = [].push(root), &block)
    return if queue.length < 1

    yield queue.first 
    
    if queue.first.left != nil
      queue.push(queue.first.left)
    end

    if queue.first.right != nil
      queue.push(queue.first.right)
    end

    queue.shift
    recursive_level_oder(queue,&block)
  end

end

bulsheesh = BST.new([20,30,32,34,36,40,50,60,65,70,75,80])

bulsheesh.pretty_print
bulsheesh.recursive_level_oder { |item| p item.data}


