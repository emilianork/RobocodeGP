require './lib/rubytree-0.8.2/tree.rb'
require './src/GA/Funct.rb'
require './src/GA/Decode.rb'

# Clase que representa un nuevo
# Individuo de la poblacion,
# tiene un arbol que representa el
# programa y una profundidad maxima.

class Individuo
  attr_accessor :maxDepth, :tree, :newMaxDepth
  # * *Args*    :
  #   - +maxDepth+ La profundidad maxima del arbol 
  #   - +newMaxDepth+ La prufundidad maxima que puede tener si se muta 
  # le individuo.
  # * *Returns* :
  #   - +Individuo+ Inicializa solamente las funciones que se van a usar
  # * *Raises* :
  #
  def initialize(maxDepth,newMaxDepth)
    @maxDepth = maxDepth
    @newMaxDepth = newMaxDepth
    #Lista de Funciones
    @listFunctNum = { 1 => "Abs", 2 => "Neg",3 => "Sin",4 => "Cos",
      5 => "ArcSin",6 => "ArcCos",7 => "IfPositive",8 => "IfGreater",
      9 => "Add",10 => "Sub",11 => "Mult",12 => "Div"}
    
    #Lista de la aridad de cada funcion
    @listFunctArity = {"Abs" => 1, "Neg" => 1, "Sin" => 1,"Cos" => 1,
      "ArcSin" => 1, "ArcCos" => 1,"IfPositive" => 3,"IfGreater" => 4,
      "Add" => 2, "Sub" => 2, "Mult" => 2,"Div" => 2}
    
    #Lista de las funciones hechas en java
    @listFunctJAVA = {"Abs" => "Math.abs(#1)", "Neg" => "-1*Math.abs(#1)",
      "Sin" => "Math.sin(#1)","Cos" => "Math.cos(#1)", 
      "ArcSin" => "Math.asin(arco(#1))", "ArcCos" => "Math.acos(arco(#1))",
      "IfPositive" => "ifPositive(#1,#1,#1)",
      "IfGreater" => "ifGreater(#1,#1,#1,#1)",
      "Add" => "(#1 + #1)", "Sub" => "(#1 - #1)", "Mult" => "(#1 * #1)",
      "Div" => "div(#1,#1)"}
    
    #Lista de Terminos
    @listTermNum = {1 =>"Energy", 2 => "Velocity",3=>"X", 4 =>"Y",
      5 =>"BattleFieldHeight", 6 =>"BattleFieldWidth",7 => "Zero",
      8 => "PI", 9 => "Random"}
    
    # Lista de terminos para el metodo onScannedRobot
    @listTermOnScannedRobot = {10 => "Bearing",11 => "VelocityRobot",
      12 => "DistanceRobot", 13=>"EnergyRobot"}
    
    # Lista de terminos para el metodo onHitBullet
    @listTermOnHitBullet = {10 => "EnergyRobot"}
    
    # Lista de terminos para el metodo onHitByBullet
    @listTermOnHitByBullet = {10 => "Bearing", 11 => "Power",
      12 => "VelocityRobot"}
    
    # Lista de terminos hechos en java
    @listTermJAVA = {"Energy" => "getEnergy()","Velocity" => "getVelocity()",
      "X" => "getX()","Y" => "getY()", 
      "BattleFieldHeight" => "getBattleFieldHeight()",
      "BattleFieldWidth" => "getBattleFieldWidth()", "Zero" => "0",
      "PI" => "Math.PI", "Random" => "this.random"}
    
    @listTermJAVAOnScannedRobot = {"Bearing" => "e.getBearing()", 
      "VelocityRobot" => "e.getVelocity()","DistanceRobot" => "e.getDistance()",
      "EnergyRobot" => "e.getEnergy()"}
    
    @listTermJAVAOnHitBullet = {"EnergyRobot" => "e.getEnergy()"}
    
    @listTermJAVAOnHitByBullet = {"Bearing" => "e.getBearing()",
      "Power" => "e.getPower()", "VelocityRobot" => "e.getVelocity()"}
    
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
    onScannedRobot = Tree::TreeNode.new("onScannedRobot",
                                        "Nodo del evento onScannedRobot")
    onHitBullet = Tree::TreeNode.new("onHitBullet",
                                     "Nodo del evento onHitBullet")
    onHitByBullet = Tree::TreeNode.new("onHitByBullet","Nodo del evento")
    
    # onScannedRobot solo tendra tres funciones importantes
    # ahead(double distance) para moverse hacia tras o hacia delante
    # fire(double power) para disparar hacia el tanke
    # turnRight(double degrees) para saber que direccion tomar
    onScannedRobot << Tree::TreeNode.new("onHead1", 
                                         Funct.new(@functOnHeadNum,
                                                   @functOnHeadJAVA,
                                                   @functOnHeadArity,
                                                   true))
    onScannedRobot << Tree::TreeNode.new("TurnRigth1",
                                         Funct.new(@functTurnRightNum,
                                                   @functTurnRightJAVA,
                                                   @functTurnRightArity,
                                                   true))
    onScannedRobot << Tree::TreeNode.new("Fire", 
                                         Funct.new(@functFireNum,
                                                   @functFireJAVA,
                                                   @functFireArity,
                                                   true))
    
    # onHitBullet solo debe de decidir que direccion tomar y hacia
    # que direccion moverse por lo que debe de implementar
    # ahead(double distance) para moverse hacia tras o hacia delante
    # turnRight(double degrees) para saber que direccion tomar
    onHitBullet << Tree::TreeNode.new("onHead2", 
                                      Funct.new(@functOnHeadNum,
                                                @functOnHeadJAVA,
                                                @functOnHeadArity,
                                                true))
    onHitBullet << Tree::TreeNode.new("TurnRigth2",
                                      Funct.new(@functTurnRightNum,
                                                @functTurnRightJAVA,
                                                @functTurnRightArity,
                                                true))
    
    # onHitByBullet solo debe de decidir que direccion tomar y hacia
    # que direccion moverse por lo que debe de implementar
    # ahead(double distance) para moverse hacia tras o hacia delante
    # turnRight(double degrees) para saber que direccion tomar
    onHitByBullet << Tree::TreeNode.new("onHead3", 
                                        Funct.new(@functOnHeadNum,
                                                  @functOnHeadJAVA,
                                                  @functOnHeadArity,
                                                  true))
    onHitByBullet << Tree::TreeNode.new("TurnRigth3",
                                        Funct.new(@functTurnRightNum,
                                                  @functTurnRightJAVA,
                                                  @functTurnRightArity,
                                                  true))
    
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
        newNode = Funct.new(@listFunctNum,
                            @listFunctJAVA,
                            @listFunctArity,
                            true)
        subtree << Tree::TreeNode.new("Parent: " +
                                      parent + " Function: " +
                                      newNode.funct +
                                      " Level: " + level.to_s +
                                      " Node: "+ i.to_s,
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
                              @listTermJAVA.merge(@listTermJAVAOnScannedRobot),
                              nil,
                              false)
          subtree << Tree::TreeNode.new("Parent: " + parent +
                                        " Function: " + newNode.funct +
                                        " Level: " + level.to_s + " Node: " +
                                        i.to_s,
                                        newNode)
        end
      end
      if (parent[0..10] == "onHitBullet") then
        for i in 1.. arity
          newNode = Funct.new(@listTermNum.merge(@listTermOnHitBullet),
                              @listTermJAVA.merge(@listTermJAVAOnHitBullet),
                              nil,
                              false)
          subtree << Tree::TreeNode.new("Parent: " + parent + " Function: " +
                                        newNode.funct + " Level: " + 
                                        level.to_s + " Node: "+ i.to_s,
                                        newNode)
        end
      end
      if (parent[0..12] == "onHitByBullet") then
        for i in 1..arity
          newNode = Funct.new(@listTermNum.merge(@listTermOnHitByBullet),
                              @listTermJAVA.merge(@listTermJAVAOnHitByBullet),
                              nil,
                              false)
          subtree << Tree::TreeNode.new("Parent: " + parent + " Function: " +
                                        newNode.funct + " Level: " + 
                                        level.to_s + " Node: "+ i.to_s,
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
        newNode = Funct.new(@listFunctNum,
                            @listFunctJAVA,
                            @listFunctArity,
                            true)
        subtree << Tree::TreeNode.new("Parent: " + parent + " Function: " +
                                      newNode.funct + " Level: " + level.to_s +
                                      " Node: " + i.to_s,
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
                              @listTermJAVA.merge(@listTermJAVAOnScannedRobot),
                              nil,
                              false)
          subtree << Tree::TreeNode.new("Parent: " + parent + " Terminal: " +
                                        newNode.funct + " Level: " +
                                        level.to_s + " Node: "+ i.to_s,
                                        newNode)
        end
      end
      if (parent[0..10] == "onHitBullet") then
        for i in 1.. arity
          newNode = Funct.new(@listTermNum.merge(@listTermOnHitBullet),
                              @listTermJAVA.merge(@listTermJAVAOnHitBullet),
                              nil,false)
          subtree << Tree::TreeNode.new("Parent: " + parent + " Terminal: " +
                                        newNode.funct+" Level: " + level.to_s +
                                        " Node: "+ i.to_s,
                                        newNode)
        end
      end
      if (parent[0..12] == "onHitByBullet") then
        for i in 1..arity
          newNode = Funct.new(@listTermNum.merge(@listTermOnHitByBullet),
                              @listTermJAVA.merge(@listTermJAVAOnHitByBullet),
                              nil,
                              false)
          subtree << Tree::TreeNode.new("Parent: " + parent + " Terminal: " +
                                        newNode.funct + " Level: "+level.to_s +
                                        " Node: "+ i.to_s,
                                        newNode)
        end
      end
    end
  end
  
  
  # Metodo que simula la mutacion
  # de un inviduo, existe un 0.1 de
  # probabilidad de escoger una terminal
  # y un 0.9 de probabilidad de escoger
  # una funcion.
  def mutation
    @tree.children{
      |child|
      name = child.name 
      child.children {
        |grandChild|
        parent = name + " " + grandChild.name
        # Decide si el nodo a mutar, sera
        # terminal o funcion
        if rand < 0.1 then
          isTerminal = true
        else
          isTerminal = false
        end
        # Genero la altura, y dependiendo de esta
        # genero un nivel a mutar.
        height = grandChild.node_height
        levelToMutate = rand(height)
        # Si el nodo raiz desde un principio es
        # una hoja entonces simplemente escogo 
        # ese nodo.
        if (!grandChild[0].is_leaf?) then
          mutationAux(0,grandChild,parent,isTerminal,levelToMutate)
        else
          nodo_escogido(0,grandChild,0,parent)
        end
      }
    }
  end
  
  # Metodo auxiliar de la mutacion que nos ayuda
  # a decidir que nodo sera la raiz de la mutacion
  def mutationAux(level,subtree,parent,isTerminal,levelToMutate)
    # Selecciono al hijo que voy a mutar
    childNodes = subtree.out_degree
    newChild = rand(childNodes)
    # Checo los casos para mutar un subarbol
    
    # Si es terminal y hoja, entonces escogo ese nodo.
    if (isTerminal && subtree[newChild].is_leaf?) then
      nodo_escogido(level+1,subtree,newChild,parent)
    else
      # Si es terminal, pero no hoja entonces simplemente
      # sigo bajando por el arbol hasta encontrar una hoja
      if (isTerminal) then
        mutationAux(level+1,subtree[newChild],parent,isTerminal,levelToMutate)
      else
        # Si estoy en el nivel a mutar, escogo ese nodo para
        # ser mutado
        if (levelToMutate == level + 1) then
          nodo_escogido(level+1,subtree,newChild,parent)
        else
          # Si no llegue a una funcion antes de intentar llegar
          # al nivel donde se va a mutar, escogo
          # en nodo padre de la hoja
          if (subtree[newChild].is_leaf?) then
            padre = subtree.parent
            childNodes = padre.out_degree
            newChild = rand(childNodes)
            nodo_escogido(level,padre,newChild,parent)
          else
            # Si no paso a ningun caso anterior sigo bajando
            mutationAux(level+1,subtree[newChild],parent,isTerminal,
                        levelToMutate)
          end
        end
      end
    end
  end
  
  # Nodo escogido,simplemente al escoger un nodo
  # muto sus hijos por completo para generar
  # un subarbol valido.
  def nodo_escogido(level,subtree,newChild,parent)
    @maxDepth = @newMaxDepth
    if ( 0.5 < rand) then
      newNode = Funct.new(@listFunctNum,
                          @listFunctJAVA,
                          @listFunctArity,
                          true)
      subtree.remove!(subtree[newChild])
      subtree.add(Tree::TreeNode.new("Parent: " + parent + " Function: " +
                                     newNode.funct + " Level: " + level.to_s +
                                     " Node: " + newChild.to_s,
                                     newNode),newChild)
      growMethodAux(level+2,subtree[newChild],parent)
    else
      if (parent[0..13] == "onScannedRobot") then
        newNode = Funct.new(@listTermNum.merge(@listTermOnScannedRobot),
                            @listTermJAVA.merge(@listTermJAVAOnScannedRobot),
                            nil,
                            false)
        subtree.remove!(subtree[newChild])
        subtree.add(Tree::TreeNode.new("Parent: " + parent + " Function: " +
                                       newNode.funct + " Level: " + level.to_s +
                                       " Node: " + newChild.to_s,
                                       newNode),newChild)
      end
      if (parent[0..10] == "onHitBullet") then
        newNode = Funct.new(@listTermNum.merge(@listTermOnHitBullet),
                            @listTermJAVA.merge(@listTermJAVAOnHitBullet),
                            nil,false)
        subtree.remove!(subtree[newChild])
        subtree.add(Tree::TreeNode.new("Parent: " + parent + " Function: " +
                                       newNode.funct + " Level: " + level.to_s +
                                       " Node: " + newChild.to_s,
                                       newNode),newChild)
      end
      if (parent[0..12] == "onHitByBullet") then
        newNode = Funct.new(@listTermNum.merge(@listTermOnHitByBullet),
                            @listTermJAVA.merge(@listTermJAVAOnHitByBullet),
                            nil,
                            false)
        subtree.remove!(subtree[newChild])
        subtree.add(Tree::TreeNode.new("Parent: " + parent + " Function: " +
                                       newNode.funct + " Level: " + level.to_s +
                                       " Node: " + newChild.to_s,
                                       newNode),newChild)
        
      end
    end
  end
  
  # Metodo que regresa un Arreglo con los
  # dos individuos hijos.
  def crossover(parent)
    parent1 = self.clone
    parent2 = parent.clone
    maxDepth = parent1.maxDepth if (parent1.maxDepth > parent2.maxDepth)
    maxDepth = parent2.maxDepth if (parent2.maxDepth >= parent1.maxDepth)
    # Genera los puntos de cruza de cada padre
    # para despues crear a sus respectivos hijos
    puntoCruza1 = ruta(parent1)
    puntoCruza2 = ruta(parent2)
    # Crea los 2 hijos para regresar un arreglo
    # con los 2 hijos.
    insertaPuntosCruza(parent1,puntoCruza1[0],puntoCruza2[1])
    insertaPuntosCruza(parent2,puntoCruza2[0],puntoCruza1[1])
    podaArbol(parent1,maxDepth)
    podaArbol(parent2,maxDepth)
    parent1.maxDepth = maxDepth 
    parent2.maxDepth = maxDepth
    parent1.newMaxDepth = maxDepth if (parent1.newMaxDepth < maxDepth)
    parent2.newMaxDepth = maxDepth if (parent2.newMaxDepth < maxDepth)
    return (Array.new << parent1) << parent2
  end

  # Metodo que dado un Individuo
  # escoge los nodos cruza de los 7
  # subarboles, y da su ruta para llegar
  # a ellos
  def ruta(parent)
    rutaRegresada = Array.new
    subArboles = Array.new
    rutaSubArboles = Array.new
    rutaRegresada[0] = rutaSubArboles
    rutaRegresada[1] =  subArboles
    parent.tree.children {
      |child|
      child.children {
        |grandChild|
          # Decide si el nodo que sera el punto de cruza
          # sera terminal o funcion
          if rand < 0.1 then
            isTerminal = true
          else
            isTerminal = false
          end
          # Genero la altura, y dependiendo de esta
          # genero un nivel donde se va a cruzar
          height = grandChild.node_height
          levelToCroosover = rand(height)
          # Representa la ruta que debe de seguir
          # para llegar al punto de cruza
          rutaNueva = Array.new
          # Si el nodo raiz desde un principio es
          # una hoja entonces simplemente escogo 
          # ese nodo.
          if (grandChild[0].is_leaf?) then
            subArboles.push(grandChild.children[0].clone)
            rutaNueva << 0
            rutaSubArboles << rutaNueva
          else
            rutaAux(0,grandChild,isTerminal,subArboles,rutaNueva,
                    levelToCroosover)
            rutaSubArboles << rutaNueva
          end
      }
    }
    return rutaRegresada
  end
  
  # Funcion auxiliar para trazar su
  # ruta, dependiendo si es terminal
  # y en que nivel se escogieron los
  # nodos
  def rutaAux(level,subtree,isTerminal,subArboles,rutaSubArbolesAux,
              levelToCroosover)
    # Selecciona al subarbol para cruzarlo
    childNodes = subtree.out_degree
    newChild = rand(childNodes)
    # Checo los casos para escoger por donde irme.
    
    #Si es terminal y hoja, entonces escogo ese nodo.
    if (isTerminal && subtree.children[newChild].is_leaf?) then   
      subArboles.push(subtree.children[newChild].clone)
      rutaSubArbolesAux << newChild
      return
    else
      # Si es terminal, pero no hoja entonces simplemente
      # sigo bajando por el arbol hasta encontrar una hoja
      if (isTerminal) then
        rutaAux(level+1,subtree.children[newChild],isTerminal,subArboles,
                (rutaSubArbolesAux.push(newChild)),levelToCroosover)
        return
      else
        # Si estoy en el nivel a cruzar, escogo ese nodo como
        # punto de cruza.
        if (levelToCroosover == level + 1) then
          subArboles.push(subtree.children[newChild].clone)
          rutaSubArbolesAux << newChild
          return
        else
          # Si no llegue a una funcion antes de intentar llegar
          # al nivel donde se va a mutar, escogo
          # en nodo padre de la hoja
          if (subtree.children[newChild].is_leaf?) then 
            subArboles.push(subtree.clone)
            return
          else
            if (!isTerminal && (levelToCroosover != level + 1)) then
              # Si no paso a ningun caso anterior sigo bajando
              rutaAux(level+1, subtree.children[newChild],isTerminal,subArboles,
                      rutaSubArbolesAux << newChild,levelToCroosover)
              return
            end
          end
        end
      end
    end
  end  
  
  # Coloca los subarboles escogidos
  # donde le corresponde
  def insertaPuntosCruza(parent,puntoCruza,arboles)
    i = 0
    parent.tree.children {
      |child|
        child.children{
          |grandChild|
            subtree = grandChild
            size = puntoCruza[i].size
            arrayCamino = puntoCruza[i]
            for j in 0...size-1
              subtree = subtree.children[arrayCamino[j]]
            end
            subtree.remove!(subtree.children[arrayCamino[size-1]])
            arboles[i].name = arboles[i].name + " " + rand().to_s + " " + rand().to_s
            subtree.add(arboles[i],arrayCamino[size-1])
            i += 1
        }
    }
  end    
    
    
    
    
    
    
  #  for i in 1..7
  #    subtree = (parent.tree.children[0]).children[i-1] if (i <= 3)
   #   subtree = (parent.tree.children[1]).children[i-4] if (i > 3 && i <= 5)
  #    subtree = (parent.tree.children[2]).children[i-6] if (i > 5) 
   #   namae = subtree.name
  #    size = puntoCruza[i-1].size
  #    for j in 0...size-1
        #puts "SubArbol: "+ i.to_s+ "    Altura: "+(subtree.node_height).to_s
  #      subtree = subtree.children[puntoCruza[i-1][j]]
   #   end
      #if (subtree.is_leaf?) then
      #  puts "No tiene Hijos  " + namae
      #  print "SubArbol: " + i.to_s + " Array: "
      #  print puntoCruza[i-1]
      #  puts
      #  parent.tree.print_tree
      # raise "Algo paso"
      #end
      #degree = subtree.out_degree
  #    subtree.remove!(subtree.children[puntoCruza[i-1][size-1]])
      #if (degree == subtree.out_degree) then
      #  puts "No lo pude quitar " + namae
      #  puts "SubArbol: " + i.to_s + "  Array: " + puntoCruza[i-1].to_s
      #  parent.tree.print_tree
      #  raise "Falle"
      #end
  #    r1 = rand
  #    r2 = rand
  #    arboles[i-1].name = arboles[i-1].name + " " + r1.to_s + " " + r2.to_s
  #    subtree.add(arboles[i-1],puntoCruza[i-1][size-1])
  #  end
  #end
  
  # Si el arbol es demasiado grande, entonces
  # lo recorta
  
  def podaArbol(parent,maxDepth)
    parent.tree.children {
      |child|
      child.children {
        |grandChild|
        parent = child.name + " " + grandChild.name
        podaArbolAux(0,child.name,grandChild,maxDepth,parent)
      }
    }
  end
  
  
  # Funcion auxiliar de la anterior
  def podaArbolAux(level,name,subtree,maxDepth,parent)
    if !(level+1 > maxDepth)then
      if !(subtree.is_leaf?) then
        children = subtree.out_degree
        for i in 1..children
          podaArbolAux(level+1,name,subtree[i-1],maxDepth,parent)
        end
      end 
      return 
    else
      children = subtree.out_degree
      for i in 1..children
        #Genero los hijos random
        if !(subtree[i-1].is_leaf?) then
          subtree.remove!(subtree[i-1])
          if (name == "onScannedRobot") then
            newNode = Funct.new(@listTermNum.merge(@listTermOnScannedRobot),
                                @listTermJAVA.merge(@listTermJAVAOnScannedRobot),
                                nil,
                                false)
            subtree.add(Tree::TreeNode.new("Parent: " + parent +
                                          " Function: " + newNode.funct +
                                          " Level: " + level.to_s + " Node: " +
                                          (i-1).to_s + " Random",newNode),i-1)
          end
          if (name == "onHitBullet") then
            newNode = Funct.new(@listTermNum.merge(@listTermOnHitBullet),
                                @listTermJAVA.merge(@listTermJAVAOnHitBullet),
                                nil,false)
            subtree.add(Tree::TreeNode.new("Parent: " + parent + " Function: " +
                                          newNode.funct + " Level: " + level.to_s +
                                          " Node: " + (i-1).to_s + " Random",
                                          newNode),i-1)
          end
          if (name == "onHitByBullet") then
            newNode = Funct.new(@listTermNum.merge(@listTermOnHitByBullet),
                                @listTermJAVA.merge(@listTermJAVAOnHitByBullet),
                                nil,
                                false)
            subtree.add(Tree::TreeNode.new("Parent: " + parent + " Function: " +
                                          newNode.funct + " Level: " + level.to_s +
                                          " Node: " + (i-1).to_s + " Random",
                                          newNode),i-1)
            
          end
        end
      end
    end
  end
end
