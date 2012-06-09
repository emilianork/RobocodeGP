# ..... Example starts.
require './lib/rubytree-0.8.2/tree.rb'                 # Load the library

# ..... Create the root node first.  Note that every node has a name and an optional content payload.
root_node = Tree::TreeNode.new("ROOT", "Root Content")

# ..... Now insert the child nodes.  Note that you can "chain" the child insertions for a given path to any depth.
root_node << Tree::TreeNode.new("CHILD1", "Child1 Content") << Tree::TreeNode.new("GRANDCHILD1", "GrandChild1 Content")
root_node << Tree::TreeNode.new("CHILD2", "Child2 Content")
root_node << Tree::TreeNode.new("CHILD3", "Child3 Content") << Tree::TreeNode.new("GRANDCHILD3", "GrandChild3 Content")
root_node << Tree::TreeNode.new("CHILD4", "Child4 Content") << Tree::TreeNode.new("GRANDCHILD4", "GrandChild3 Content")
child5 = Tree::TreeNode.new("CHILD5", "Child5 Content")
grad = Tree::TreeNode.new("GRANDCHILD5", "GrandChild5 Content")
root_node << child5 << grad
grandchild6 = Tree::TreeNode.new("GRANDCHILD6","GrandChild6 Content")
child5 << grandchild6
seven = Tree::TreeNode.new("GRANDCHILD7","GrandChild7 Content")

# ..... Lets print the representation to stdout.  This is primarily used for debugging purposes.

#puts root_node.node_height
#puts root_node[4][1].name
puts root_node[10].class

