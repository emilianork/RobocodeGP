require './lib/rubytree-0.8.2/tree.rb'
require './src/GA/Funct.rb'

class Individuo
  attr_accessor :maxDepth, :tree
  # * *Args*    :
  #   - +maxDepth+ La profundidad maxima del arbol 
  # * *Returns* :
  #   - +Individuo+ Inicializa solamente las funciones que se van a usar
  # * *Raises* :
  #
  def initialize(maxDepth)
    @maxDepth = maxDepth
    #Lista de Funciones
    @listFunctNum = { 1 => "Abs", 2 => "Neg",3 => "Sin",4 => "Cos",5 => "ArcSin",6 => "ArcCos",
                      7 => "IfPositive",8 => "IfGreater",9 => "Add",10 => "Sub",11 => "Mult",
                      12 => "Div"}
    #Lista de la aridad de cada funcion
    @listFunctArity = {"Abs" => 1, "Neg" => 1, "Sin" => 1,
                  "Cos" => 1, "ArcSin" => 1, "ArcCos" => 1,
                  "IfPositive" => 3,
                  "IfGreater" => 4,
                  "Add" => 2, "Sub" => 2, "Mult" => 2,
                  "Div" => 2}
    #Lista de las funciones hechas en java
    @listFunctJAVA = {"Abs" => "Math.abs(#1)", "Neg" => "-1*Math.asb(#1)", "Sin" => "Math.sin(#1)",
                  "Cos" => "Math.cos(#1)", "ArcSin" => "Math.asin(#1)", "ArcCos" => "Math.acos(#1)",
                  "IfPositive" => "if (0 < #1) {\n #2;\n } else { \n#3;\n}",
                  "IfGreater" => "if (#1 < #2) {\n #3;\n } else { \n#4;\n}",
                  "Add" => "(#1 + #2)", "Sub" => "(#1 - #2)", "Mult" => "(#1 * #2)",
                  "Div" => "(#1 / #2)"}
    #Lista de Terminos
    @listTermNum = {1 =>"Energy", 2 => "Velocity",3=>"X", 4 =>"Y", 5 =>"BattleFieldHeight",
                   6 =>"BattleFieldWidth",7 => "Zero", 8 => "PI", 9 => "Random"}
    # Lista de terminos para el metodo onScannedRobot
    @listTermOnScannedRobot = {10 => "Bearing",11 => "VelocityRobot", 12 => "DistanceRobot", 13=>"EnergyRobot"}
    # Lista de terminos para el metodo onHitBullet
    @listTermOnHitBullet = {10 => "EnergyRobot"}
    # Lista de terminos para el metodo onHitByBullet
    @listTermOnHitByBullet = {10 => "Bearing", 11 => "Power",12 => "VelocityRobot"}
    # Lista de terminos hechos en java
    @listTermJAVA = {"Energy" => "getEnergy()","Velocity" => "getVelocity()","X" => "getX()",
                  "Y" => "getY()", "BattleFieldHeight" => "getBattleFieldHeight()",
                  "BattleFieldWidth" => "getBattleFieldWidth()", "Zero" => "0",
                  "PI" => "Math.PI", "Random" => "this.random"}
    @listTermJAVAOnScannedRobot = {"Bearing" => "e.getBearing()", "VelocityRobot" => "e.getVelocity()",
                                    "DistanceRobot" => "e.getDistance()","EnergyRobot" => "e.getEnergy()"}
    @listTermJAVAOnHitBullet = {"EnergyRobot" => "e.getEnergy()"}
    @listTermJAVAOnHitByBullet = {"Bearing" => "e.getBearing()","Power" => "e.getPower()", 
                                  "VelocityRobot" => "e.getVelocity()"}
    # Creamos el nodo raiz y sus 3 nodos principales      
    @tree = Tree::TreeNode.new("Main", "Nodo Raiz") 
    @tree << Tree::TreeNode.new("onScannedRobot",Funct.new(@listFunctNum,@listFunctJAVA,@listFunctArity,true))
    @tree << Tree::TreeNode.new("onHitBullet",Funct.new(@listFunctNum,@listFunctJAVA,@listFunctArity,true))
    @tree << Tree::TreeNode.new("onHitByBullet",Funct.new(@listFunctNum,@listFunctJAVA,@listFunctArity,true))
  end
  
  # Modifica al objeto para que este cree
  # un arbol usando el metodo de full
  # para hacer un arbol random.
  def fullMethod
   @tree.children{
     |child|
     fullMethodAux(0,child,child.name)
   }
  end
  # Metodo auxiliar para crear los subarboles
  # del metodo anterior.
  def fullMethodAux(level,subtree,name)
    arity = subtree.content.arity
    if (level != @maxDepth) then
      for i in 1..arity
        subtree << Tree::TreeNode.new(name + " Level: " + level.to_s+" Node: "+ i.to_s,
                                      Funct.new(@listFunctNum,@listFunctJAVA,@listFunctArity,true))
      end
      subtree.children {
        |child|
        fullMethodAux(level+1,child,name)
      }
    else
      if (name == "onScannedRobot") then
        for i in 1..arity
          subtree << Tree::TreeNode.new(name + " Level: " + level.to_s + " Node: " + i.to_s,
                                        Funct.new(@listTermNum.merge(@listTermOnScannedRobot),
                                                  @listTermJAVA.merge(@listTermJAVAOnScannedRobot),nil,false))
        end
      end
      if (name == "onHitBullet") then
        for i in 1.. arity
          subtree << Tree::TreeNode.new(name + " Level: " + level.to_s + " Node: " + i.to_s,
                                        Funct.new(@listTermNum.merge(@listTermOnHitBullet),
                                                  @listTermJAVA.merge(@listTermJAVAOnHitBullet),nil,false))
        end
     end
      if (name == "onHitByBullet") then
        for i in 1..arity
          subtree << Tree::TreeNode.new(name + " Level: " + level.to_s + " Node: " + i.to_s,
                                        Funct.new(@listTermNum.merge(@listTermOnHitByBullet),
                                        @listTermJAVA.merge(@listTermJAVAOnHitByBullet),nil,false))
        end
      end
    end
  end
  # Modifica al objeto para que este cree
  # un arbol usando el metodo de grow
  # para hacer un arbol random.
  def growMethod
    @tree.children{
      |child|
      growMethodAux(0,child,child.name)
    }
  end
  
  # Metodo auxiliar para crear los subarboles
  # del metodo anterior.
  def growMethodAux(level,subtree,name)
    terminal = false
    terminal = true if (rand() < 0.5)
    arity = subtree.content.arity
    if (level != @maxDepth && !terminal) then
      for i in 1..arity
        subtree << Tree::TreeNode.new(name + " Level: " + level.to_s+" Node: "+ i.to_s,
                                      Funct.new(@listFunctNum,@listFunctJAVA,@listFunctArity,true))
      end
      subtree.children {
        |child|
        fullMethodAux(level+1,child,name)
      }
    else
      if (name == "onScannedRobot") then
        for i in 1..arity
          subtree << Tree::TreeNode.new(name + " Level: " + level.to_s + " Node: " + i.to_s,
                                        Funct.new(@listTermNum.merge(@listTermOnScannedRobot),
                                                  @listTermJAVA.merge(@listTermJAVAOnScannedRobot),nil,false))
        end
      end
      if (name == "onHitBullet") then
        for i in 1.. arity
          subtree << Tree::TreeNode.new(name + " Level: " + level.to_s + " Node: " + i.to_s,
                                        Funct.new(@listTermNum.merge(@listTermOnHitBullet),
                                                  @listTermJAVA.merge(@listTermJAVAOnHitBullet),nil,false))
        end
     end
      if (name == "onHitByBullet") then
        for i in 1..arity
          subtree << Tree::TreeNode.new(name + " Level: " + level.to_s + " Node: " + i.to_s,
                                        Funct.new(@listTermNum.merge(@listTermOnHitByBullet),
                                        @listTermJAVA.merge(@listTermJAVAOnHitByBullet),nil,false))
        end
      end
    end
  end
end