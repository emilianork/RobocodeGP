# ..... Example starts.
require './lib/rubytree-0.8.2/tree.rb'                 # Load the library

# ..... Create the root node first.  Note that every node has a name and an optional content payload.
root_node = Tree::TreeNode.new("ROOT", "Root Content")

# ..... Now insert the child nodes.  Note that you can "chain" the child insertions for a given path to any depth.
root_node << Tree::TreeNode.new("CHILD1", "Child1 Content") << Tree::TreeNode.new("GRANDCHILD1", "GrandChild1 Content")
root_node << Tree::TreeNode.new("CHILD2", "Child2 Content")
root_node << Tree::TreeNode.new("CHILD3", "Child3 Content") << Tree::TreeNode.new("GRANDCHILD3", "GrandChild3 Content")
root_node << Tree::TreeNode.new("CHILD4", "Child4 Content") << Tree::TreeNode.new("GRANDCHILD4", "GrandChild3 Content")
child5 = Tree::TreeNode.new("GRANDCHILD5", "GrandChild5 Content")
root_node << Tree::TreeNode.new("CHILD5", "Child5 Content") << child5

# ..... Lets print the representation to stdout.  This is primarily used for debugging purposes.
#root_node.print_tree
#puts root_node.node_height
puts root_node.print_tree

puts child5.parentage


