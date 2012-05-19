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
    # Hash para la funcion OnHead                              
    @functOnHeadNum = {1=>"Head"}
    @functOnHeadJAVA = {"Head" => "ahead(#1);"} 
    @functOnHeadArity = {"Head" => 1}
    
    #Hash para la funcion TurnRight
    @functTurnRightNum = {1=>"TurnRigth"}
    @functTurnRightJAVA = {"TurnRigth" => "turnRight(#1);"} 
    @functTurnRightArity = {"TurnRigth" => 1}
    
    # Hash para la funcion Fire
    @functFireNum = {1 => "Fire"}
    @functFireJAVA = {"Fire" => "fire(#1);"} 
    @functFireArity = {"Fire" => 1}
    
    
    # Creamos el nodo raiz y sus 3 nodos principales      
    @tree = Tree::TreeNode.new("Main", "Nodo Raiz") 
    onScannedRobot = Tree::TreeNode.new("onScannedRobot","Nodo del evento onScannedRobot")
    onHitBullet = Tree::TreeNode.new("onHitBullet","Nodo del evento onHitBullet")
    onHitByBullet = Tree::TreeNode.new("onHitByBullet","Nodo del evento")
    
    # onScannedRobot solo tendra tres funciones importantes
    # ahead(double distance) para moverse hacia tras o hacia delante
    # fire(double power) para disparar hacia el tanke
    # turnRight(double degrees) para saber que direccion tomar
    onScannedRobot << Tree::TreeNode.new("onHead1", Funct.new(@functOnHeadNum,@functOnHeadJAVA,@functOnHeadArity,true))
    onScannedRobot << Tree::TreeNode.new("TurnRigth1",Funct.new(@functTurnRightNum,@functTurnRightJAVA,@functTurnRightArity,true))
    onScannedRobot << Tree::TreeNode.new("Fire", Funct.new(@functFireNum,@functFireJAVA,@functFireArity,true))
    
    # onHitBullet solo debe de decidir que direccion tomar y hacia
    # que direccion moverse por lo que debe de implementar
    # ahead(double distance) para moverse hacia tras o hacia delante
    # turnRight(double degrees) para saber que direccion tomar
    onHitBullet << Tree::TreeNode.new("onHead2", Funct.new(@functOnHeadNum,@functOnHeadJAVA,@functOnHeadArity,true))
    onHitBullet << Tree::TreeNode.new("TurnRigth2",Funct.new(@functTurnRightNum,@functTurnRightJAVA,@functTurnRightArity,true))
    
    # onHitByBullet solo debe de decidir que direccion tomar y hacia
    # que direccion moverse por lo que debe de implementar
    # ahead(double distance) para moverse hacia tras o hacia delante
    # turnRight(double degrees) para saber que direccion tomar
    onHitByBullet << Tree::TreeNode.new("onHead3", Funct.new(@functOnHeadNum,@functOnHeadJAVA,@functOnHeadArity,true))
    onHitByBullet << Tree::TreeNode.new("TurnRigth3",Funct.new(@functTurnRightNum,@functTurnRightJAVA,@functTurnRightArity,true))
    
    # Agrego todos los nodos a la raiz
    @tree << onScannedRobot
    @tree << onHitBullet
    @tree << onHitByBullet
  end
  
  # Modifica al objeto para que este cree
  # un arbol usando el metodo de full
  # para hacer un arbol random.
  def fullMethod
    @tree.children{
      |child|
      name = child.name 
      child.children {
        |grandChild|
        parent = name + " " + grandChild.name
        fullMethodAux(0,grandChild,parent)
      }
    }
  end
  # Metodo auxiliar para crear los subarboles
  # del metodo anterior.
  def fullMethodAux(level,subtree,parent)
    arity = subtree.content.arity
    if (level != @maxDepth) then
      for i in 1..arity
        newNode = Funct.new(@listFunctNum,@listFunctJAVA,@listFunctArity,true)
        subtree << Tree::TreeNode.new("Parent: " + parent + " Function: " + newNode.funct +
                                      " Level: " + level.to_s + " Node: "+ i.to_s,
                                      newNode)
      end
      subtree.children {
        |child|
        fullMethodAux(level+1,child,parent)
      }
    else
      if (parent[0..13] == "onScannedRobot") then
        for i in 1..arity
          newNode = Funct.new(@listTermNum.merge(@listTermOnScannedRobot),
                              @listTermJAVA.merge(@listTermJAVAOnScannedRobot),nil,false)
          subtree << Tree::TreeNode.new("Parent: " + parent + " Function: " + newNode.funct +
                                        " Level: " + level.to_s + " Node: "+ i.to_s,
                                        newNode)
        end
      end
      if (parent[0..10] == "onHitBullet") then
        for i in 1.. arity
          newNode = Funct.new(@listTermNum.merge(@listTermOnHitBullet),
                              @listTermJAVA.merge(@listTermJAVAOnHitBullet),nil,false)
          subtree << Tree::TreeNode.new("Parent: " + parent + " Function: " + newNode.funct +
                                        " Level: " + level.to_s + " Node: "+ i.to_s,
                                        newNode)
        end
     end
      if (parent[0..12] == "onHitByBullet") then
        for i in 1..arity
          newNode = Funct.new(@listTermNum.merge(@listTermOnHitByBullet),
                              @listTermJAVA.merge(@listTermJAVAOnHitByBullet),nil,false)
          subtree << Tree::TreeNode.new("Parent: " + parent + " Function: " + newNode.funct +
                                        " Level: " + level.to_s + " Node: "+ i.to_s,
                                        newNode)
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
      name = child.name 
      child.children {
        |grandChild|
        parent = name + " " + grandChild.name
        growMethodAux(0,grandChild,parent)
      }
    }
  end
  
  # Metodo auxiliar para crear los subarboles
  # del metodo anterior.
  def growMethodAux(level,subtree,parent)
    terminal = false
    terminal = true if (rand() < 0.5)
    arity = subtree.content.arity
    if (level != @maxDepth && !terminal) then
      for i in 1..arity
        newNode = Funct.new(@listFunctNum,@listFunctJAVA,@listFunctArity,true)
        subtree << Tree::TreeNode.new("Parent: " + parent + " Function: " + newNode.funct +
                                      " Level: " + level.to_s + " Node: "+ i.to_s,
                                      newNode)
      end
      subtree.children {
        |child|
        growMethodAux(level+1,child,parent)
      }
    else
      if (parent[0..13] == "onScannedRobot") then
        for i in 1..arity
          newNode = Funct.new(@listTermNum.merge(@listTermOnScannedRobot),
                              @listTermJAVA.merge(@listTermJAVAOnScannedRobot),nil,false)
          subtree << Tree::TreeNode.new("Parent: " + parent + " Function: " + newNode.funct +
                                        " Level: " + level.to_s + " Node: "+ i.to_s,
                                        newNode)
        end
      end
      if (parent[0..10] == "onHitBullet") then
        for i in 1.. arity
          newNode = Funct.new(@listTermNum.merge(@listTermOnHitBullet),
                              @listTermJAVA.merge(@listTermJAVAOnHitBullet),nil,false)
          subtree << Tree::TreeNode.new("Parent: " + parent + " Function: " + newNode.funct +
                                        " Level: " + level.to_s + " Node: "+ i.to_s,
                                        newNode)
        end
     end
      if (parent[0..12] == "onHitByBullet") then
        for i in 1..arity
          newNode = Funct.new(@listTermNum.merge(@listTermOnHitByBullet),
                              @listTermJAVA.merge(@listTermJAVAOnHitByBullet),nil,false)
          subtree << Tree::TreeNode.new("Parent: " + parent + " Function: " + newNode.funct +
                                        " Level: " + level.to_s + " Node: "+ i.to_s,
                                        newNode)
        end
      end
    end
  end

  # Guarda al individuo en la carpeta poblacion
  # primero convirtiendo el arbol en un archivo
  # java para finalizar compilandolo
  def save
    
  end
end