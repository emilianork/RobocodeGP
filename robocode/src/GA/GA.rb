require './src/GA/Individuo.rb'
require './src/GA/Decode.rb'
require './lib/json-1.7.3/json.rb'

# Clase principal que simula el algoritmo genetico
# Parametros:
#      poblacion: Representa el numero de individuos que habra en cada generacion.
#      proCruza: Representa la probabilidad de cruza que tienen los individuos.
#      proMutacion: Representa la probabilidad de mutacion que tienen los individuos.
#      maxGeneraciones: El criterio de parada del algoritmo es el numero de generaciones
#                       maximas que habra.
#      individuosTorneo: El numero de individuos que participara en la seleccion por torneo.
#                        La seleccion por torneo que usa el algoritmo es estocastica.
#      poblacionNueva: Es la poblacion mas joven; un arreglo de los individuos.
#      poblacionVieja: El una generacion predecesora de la actual; un arreglo de los arboles de
#                      los individuos.
#      profundidadArboles: Arreglo de dos dimensiones donde guardo arreglos que contienen los valores
#                        de profundidad de los arboles de poblacionVieja.
#      elMejor: La mejor solucion encontrada hasta el momento; solo es el arbol que lo representa.
#      elMejorDepths: En esta variable guardo un arreglo con las variables de profundidad del 
#                     inviduo que es el mejor qu ese a encontrado.
#      generacionElMejor: Nos dice cuando se genero el mejor de la poblacion.
#      mejorFitness: Contiene un flotante que nos indica cual fue el resultado de su evaluacion.
#      elitismo: Este algoritmo solamente guarda un al mejor de cada generacion para pasarlo a la
#                siguiente; al igual que elMejor esta variable solo contiene el arbol.
#      elitismoFitness: Flotante del valor fitness del individuo que se pasara a la siguente
#                       generacion.
#      elitismoDepths: Arreglo que contiene las variables de profundidad de arbol del individuo
#                      que se pasara a la siguiente poblacion.
#      evaluacionNueva: Arreglo que contiene los valores fitness de la poblacion mas joven.
#      evaluacionVieja: Arreglo que contiene los valores fitness de la poblacion anterior a la
#                       actual.
#      generacion: La generacion actual en la que se esta procesando el algoritmo.
#      maxDepth: El valor de la profundidad maxima de todos los arboles que se generen.
#      minDepth: El valor de la profundidad minima de todos los arboles que se generen.
#      newMaxDepth: Si un individuo muta, entonces como maxima profundad que puede tener
#                   ahora es cambiada por newMaxDepth que es mayor a la actual.
#      competidores: La lista de los nombres de los competidores.
#      data: Arreglo de arreglos que contienen los valores de fitness de los pobladores
#            de cada generacion para despues graficarlos.

class GA
  attr_reader :poblacion, :proCruza, :proMutacion, :maxGeneraciones, :individuosTorneo,
              :poblacionNueva, :poblacionVieja, :profundidadArboles, :elMejor, :elMejorDepths,
              :generacionElMejor, :mejorFitness, :elitismo, :elitismoFitness, :elitismoDepths,
              :evaluacionNueva, :evaluacionVieja, :generacion, :maxDepth, :minDepth,
              :newMaxDepth, :competidores
              
  attr_accessor :data
           
           
  # Metodo que inicializa el algoritmos sus
  # argumentos se explican en al inicio
  # de este codigo.
  def initialize(poblacion,proCruza,proMutacion,maxGeneraciones,individuosTorneo,
                maxDepth,newMaxDepth,competidores)
      # Asignacion de variables importantes para la realizacion del algoritmo.
      @poblacion = poblacion
      @proCruza = proCruza
      @proMutacion = proMutacion
      @maxGeneraciones = maxGeneraciones
      @individuosTorneo = individuosTorneo
      @maxDepth = maxDepth
      @minDepth = 2
      @newMaxDepth = newMaxDepth
      @numberElitismo = 1
      @data = Array.new
      @competidores = competidores
      # Inicializo el conteo de las poblaciones.
      @generacion = 0
      @generacion += 1
      # Genero la primera poblacion.
      generaPoblacion
      # Obtengo el inviduo y sus valores del mejor individuo de la
      # generacion
      getElitismo
      # Imprimo strings en pantalla para saber como va la ejecucion del
      # algoritmo.
      puts " -----   El mejor individuo de la generacion: "+ @elitismoFitness.to_s
      # Agrego los valores a la variable global data para las estadisticas
      agregaData
      # Saco la mejor solucion encontrada hasta el momento
      obtenElMejor
      # Intercambio los valores de la vieja generacion por la nueva
      # y me deshago de los valores de la poblacion vieja.
      intercambia
      
  end
  
  
  # Metodo para generar la primera poblacion usando
  # el metodo de half-ramped descrito por Koza,
  # usando los metodos de grow y full para generar
  # a los pobladores iniciales.
  def generaPoblacion
    @poblacionNueva = Array.new
    numberOfGroups = 2
    sizeOfGroups = @poblacion/numberOfGroups
    usingFullMethod = sizeOfGroups / 2
    usingGrowMethod = usingFullMethod
    for i in 1..numberOfGroups
      for j in 1..sizeOfGroups
        if j <= usingFullMethod then
          if (i == 1) then
            individuo = Individuo.new(@minDepth,newMaxDepth)
            individuo.fullMethod
            @poblacionNueva << individuo
          else
            individuo = Individuo.new(@maxDepth,newMaxDepth)
            individuo.fullMethod
            @poblacionNueva << individuo
          end
        else
          if (i == 2) then
            individuo = Individuo.new(minDepth,newMaxDepth)
            individuo.growMethod
            @poblacionNueva << individuo
          else
            individuo = Individuo.new(maxDepth,newMaxDepth)
            individuo.fullMethod
            @poblacionNueva << individuo
          end
        end
      end
    end
    # Preparo los folders y sus archivos para 
    # las batallas
    prepareFolders
    # Evaluo la poblacion inicial
    evaluaPoblacion
    # Estadisticas que indican como va el algoritmo.
    print "Fitness de la generacion: "
    print @evaluacionNueva
    print "   ----    Generacion: "
    print @generacion
  end
  
  # Prepara los folders que contiene el codigo de los
  # individuos para compilarse y tambien genero archivos
  # *.battle para generar una evaluacion con todos los 
  # competidores.
  def prepareFolders
    system("rm -R robots/Individuo*")
    system("rm -R robots/Mejor")
    system("rm -R battles/*")
    system("rm -R results/*")
    for i in 0...@poblacion
      system("mkdir robots/Individuo"+i.to_s)
      system("touch robots/Individuo"+i.to_s+"/Individuo"+i.to_s+".java")
    end
      system("mkdir robots/Mejor")
      system("touch robots/Mejor/Mejor.java")
    for i in 0...@poblacion
      for j in 0...@competidores.size
        stringBattle = "robocode.battle.numRounds=10\n"+
          "robocode.battle.gunCoolingRate=0.1\n"+
          "robocode.battleField.width=800\n"+
          "robocode.battle.rules.inactivityTime=450\n"+
          "robocode.battle.selectedRobots=Individuo"+i.to_s+".Individuo"+i.to_s+"*,"+ @competidores[j]+"\n"+
          "robocode.battle.hideEnemyNames=false\n"+
          "robocode.battleField.height=600\n"
        system("touch battles/"+i.to_s+(@competidores[j].delete(" "))+".battle")
        file = File.open("battles/"+i.to_s+(@competidores[j].delete(" "))+".battle","w+")
        file.write(stringBattle)
        file.close
      end
      for j in 0...@competidores.size
        stringBattle = "robocode.battle.numRounds=10\n"+
           "robocode.battle.gunCoolingRate=0.1\n"+
           "robocode.battleField.width=800\n"+
           "robocode.battle.rules.inactivityTime=450\n"+
           "robocode.battle.selectedRobots=Mejor.Mejor*,"+ @competidores[j]+"\n"+
           "robocode.battle.hideEnemyNames=false\n"+
           "robocode.battleField.height=600\n"
        system("touch battles/Mejor"+(@competidores[j].delete(" "))+".battle")
        file = File.open("battles/Mejor"+(@competidores[j].delete(" "))+".battle","w+")
        file.write(stringBattle)
        file.close
      end
    end
  end
  
  # Para evaluar la poblacion actual
  # primero debo de guardar el codigo fuente
  # del cada individuo para despues compilarlo.
  def evaluaPoblacion
    for i in 1..@poblacion
      save(i-1,@poblacionNueva[i-1])
      compile(i-1)
    end
    # Evalua todos los inviduos con cada competidor.
    evaluaTotal
  end
  
  # Guarda al individuo en la carpeta poblacion
  # primero convirtiendo el arbol en un archivo
  # java para finalizar compilandolo
  def save(name,individuo)
    name = "Individuo" + name.to_s
    decode = Decode.new(individuo,name.to_s)
    decode.decode
    javaCode = decode.javaExpresion
    file = File.open("robots/"+name+"/"+name+".java","w+")
    file.write(javaCode)
    file.close
  end
  
  # Compila el al individuo
  # lo que resive esta funcion en un numero
  # que representa al indiviuo.
  def compile(individuo)
    compileString = "javac -classpath libs/robocode.jar robots/Individuo"+individuo.to_s+"/Individuo"+individuo.to_s+".java"
    system(compileString)
  end
  
  # Esta funcion manda a llamar a la ejecucion
  # de la batalla para despues sacar las estadisticas
  def evaluaTotal
    @evaluacionNueva = Array.new
    for i in 0...@poblacion
      for j in 0...@competidores.size
        # Ejecuto todas las batallas.
        ejecutaBattle(i.to_s,@competidores[j].delete(" "))
      end
    end
    
    # Determino la evaluacion de cada individuo, para
    # irla guardando en la varibale @evaluacionNueva
    for i in 0...@poblacion
      evalua = 0.0
      for j in 0...@competidores.size
            string = File.open("results/"+i.to_s+(@competidores[j].delete(" "))+".txt","r") { |f| f.read}
            index = string.index("Individuo"+i.to_s+".Individuo"+i.to_s+"*")
            index1 = string.index("%")
            if (!index1.nil?) then
              if (index < index1) then
                index = string.index("%")
              else
                index = string.index("%",index1+1)
              end
              sub1 = string[index-2...index]
              sub2 = string[index-1...index]
              if (sub1.to_i < sub2.to_i) then
                evalua = evalua + sub2.to_f
              else
                evalua = evalua + sub1.to_f
              end
            end
      end
      @evaluacionNueva[i] = evalua.to_f/@competidores.size
    end
    system("rm -R results/*")
  end
  
  # Ejecuta el comando para realizar la batalla
  # entre ambos individuos
  def ejecutaBattle(individuo1,individuo2)
    stringBattle = "java -DPARALLEL=true -classpath libs/robocode.jar robocode.Robocode -battle battles/"+
                  individuo1+individuo2+".battle -nodisplay -results results/"+individuo1+individuo2+".txt > /dev/null"
    system(stringBattle)
  end
  
  # Agrega los datos de la evaluacionNueva
  # a las estadisticas.
  def agregaData
    populationData = @evaluacionNueva.clone
    @data.push(populationData)
  end

  # Obtiene en un arreglo junto
  # con su fitness los individuos
  # mejores de la poblacion para
  # pasarlos a la siguiente generacion
  def getElitismo
    indexWin = 0
    win = @evaluacionNueva[0]
    for i in 1...@poblacion
      if (win < @evaluacionNueva[i]) then
        indexWin = i
        win = @evaluacionNueva[i]
      end  
    end
    # Dado que clone no sirve correctamente
    # encripto los individuos con la libreria
    # json, para despues desencriptarlos.
    depths = Array.new
    depths << (@poblacionNueva[indexWin].maxDepth)
    depths << (@poblacionNueva[indexWin].newMaxDepth)
    tree = (@poblacionNueva[indexWin].tree).to_json
    @elitismo = tree
    @elitismoFitness = @evaluacionNueva[indexWin]
    @elitismoDepths = depths
  end
  
  # Cambia la nueva poblacion
  # a la vieja poblacion junto
  # con su fitness
  def intercambia
    @poblacionVieja = Array.new
    @profundidadArboles = Array.new
    for i in 0...@poblacionNueva.size
      # Dado que clone no sirve correctamente
      # encripto los individuos con la libreria
      # json, para despues desencriptarlos.
      json = (@poblacionNueva[i].tree).to_json
      @poblacionVieja.push(json)
      depths = Array.new
      depths << (@poblacionNueva[i].maxDepth)
      depths << (@poblacionNueva[i].newMaxDepth)
      @profundidadArboles << depths
    end
    @evaluacionVieja = @evaluacionNueva.clone
  end

  # Hace una seleccion por torneo
  # deterministico, el numero de
  # individuos que participan en
  # el torneo es una variable de
  # clase
  def tournament()
    torneo = Array.new
    torneoIndex = Array.new
    for i in 1..@individuosTorneo
      individuo = rand(@poblacion)
      torneo.push(@evaluacionVieja[individuo])
      torneoIndex.push(individuo)
    end
    selected = torneo[0]
    indexWine = torneoIndex[0]
    for i in 2..@individuosTorneo
      if (selected < torneo[i-1]) then
        select = torneo[i-1]
        indexWine = torneoIndex[i-1]
      end
    end
    
    #  Una vez seleccionado un ganador
    #  lo desencripto con la libreria json.
    ganador = Individuo.new(@profundidadArboles[indexWine][0],@profundidadArboles[indexWine][1])
    ganador.tree = JSON.parse(@poblacionVieja[indexWine],:max_nesting => false)
    return ganador
  end
  
  # Agrega los mejores individuos de 
  # la generacion anterior en la nueva
  # poblacion
  def setElitismo
    # Lo desencripto con la libreria json.
    # para agregarlo a la poblacion.
    elit = Individuo.new(@elitismoDepths[0],@elitismoDepths[1])
    elit.tree = JSON.parse(@elitismo,:max_nesting => false)
    @poblacionNueva[0] = elit
    @evaluacionNueva[0] = @elitismoFitness
  end
  
  # Si se a generado una solucion
  # mejor que una previa entonces
  # esta se guarda
  def obtenElMejor
    bestIndex = 0
    bestFitness = @evaluacionNueva[0]
    for i in 1...@poblacion
      if (bestFitness < @evaluacionNueva[i-1]) then
        bestIndex = i
        bestFitness = @evaluacionNueva[i-1]
      end
    end
    if (@generacion == 1) then
      depths = Array.new
      depths << (@poblacionNueva[bestIndex].maxDepth)
      depths << (@poblacionNueva[bestIndex].newMaxDepth)
      tree = (@poblacionNueva[bestIndex].tree).to_json
      @elMejor = tree
      @elMejorDepths = depths
      @mejorFitness = bestFitness
      @generacionElMejor = @generacion
      return
    end
    if (@mejorFitness < bestFitness) then
      depths = Array.new
      depths << (@poblacionNueva[bestIndex].maxDepth)
      depths << (@poblacionNueva[bestIndex].newMaxDepth)
      tree = (@poblacionNueva[bestIndex].tree).to_json
      @elMejor = tree
      @elMejorDepths = depths
      @mejorFitness = bestFitness
      @generacionElMejor = @generacion
    end
  end
  
  # Este es el algoritmo genetico
  # propiamente dicho, que corre
  # todas las generaciones que 
  # se le pasen al metodo constructor
  def run
    for i in 1...@maxGeneraciones
      @poblacionNueva = Array.new
      @evaluacionNueva = Array.new
      size = @poblacion/2
      for j in 1..size
        crossover = true
        padre1 = nil
        padre2 = nil
        while (crossover) do
          # Obtengo los padres nuevos.
          padre1 = tournament()
          padre2 = tournament()   
          # Si estos se cruzan, entonces genero
          # a sus hijos.
          if (@proCruza > rand) then
            crossover = false
            hijos = padre1.crossover(padre2)
            hijo1 = hijos[0]
            hijo2 = hijos[1]
          end
        end
        
        # Si la mutacion es true, entonces los muto.
        if (@proMutacion > rand) then
          hijo1.mutation
        end
        if (@proMutacion > rand) then
          hijo2.mutation
        end
        # Agrego los hijos a la poblacion nueva.
        @poblacionNueva.push(hijo1)
        @poblacionNueva.push(hijo2)
      end
      # Aumento la generacion de estos
      @generacion += 1
      # Agrego al mejor de la poblacion pasada
      # a esta poblacion.
      setElitismo
      # Se evaluan
      evaluaPoblacion
      # Imprimo estadisticias en la terminal.
      print "Fitness de la generacion: "
      print @evaluacionNueva
      print "   ----    Generacion: "
      print @generacion
      # Obtengo al mejor de la generacion.
      getElitismo
      puts " -----   El mejor individuo de la generacion: "+ @elitismoFitness.to_s
      # Si se genero una solucion mejor entonces la guardo, si no
      # no hago nada.
      obtenElMejor
      # Agrego los datos a las estadisiticas
      agregaData
      # Intercambio las poblaciones para hacer otra iteracion.
      intercambia
    end
    # Genero el codigo de la mejor solucion
    # para guadar el .java y tambien para
    # compilarlo.
    tree = JSON.parse(@elMejor,:max_nesting => false)
    individuo = Individuo.new(@elMejorDepths[0],@elMejorDepths[1])
    individuo.tree = tree
    decode = Decode.new(individuo,"Mejor")
    decode.decode
    javaCode = decode.javaExpresion
    file = File.open("robots/Mejor/Mejor.java","w+")
    file.write(javaCode)
    file.close
    compileString = "javac -classpath libs/robocode.jar robots/Mejor/Mejor.java"
    system(compileString)
    puts "El mejor Robot se obtubo en la generacion: " + @generacionElMejor.to_s
    puts "El codigo del robot esta en la carpeta robots/Mejor/Mejor.java"
    puts
    puts "Para correr las batallas con cada competidor, debe de ejecutar los siguientes\n
          comandos por separado para ver cada batalla"
    for i in 0...@competidores.size
      puts "java -classpath libs/robocode.jar robocode.Robocode -battle battles/Mejor"+(@competidores[i].delete(" "))+
            ".battle"
    end
  end
end

