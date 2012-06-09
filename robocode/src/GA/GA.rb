require './src/GA/Individuo.rb'
require './src/GA/Decode.rb'
require './lib/json-1.7.3/json.rb'

class GA
  attr_accessor :poblacion, :proCruza, :proMutacion, :maxGeneraciones, :individuosTorneo,
              :poblacionNueva, :poblacionVieja, :elMejor, :generacionElMejor,
              :mejorFitness, :elitismo, :elitismoFitness, :elitismoDepths ,:evaluacionNueva, :evaluacionVieja,
              :datosAlgoritmo, :generacion, :maxDepth, :newMaxDepth, :competidores, :numberElitismo,
              :profuncidadArboles, :profundidaElitismo, :elMejorDepths, :data
           
           
     
  def initialize(poblacion,proCruza,proMutacion,maxGeneraciones,individuosTorneo,
                maxDepth,newMaxDepth,competidores)
      @poblacion = poblacion
      @proCruza = proCruza
      @proMutacion = proMutacion
      @maxGeneraciones = maxGeneraciones
      @individuosTorneo = individuosTorneo
      @maxDepth = maxDepth
      @newMaxDepth = newMaxDepth
      @numberElitismo = 1
      @data = Array.new
      @competidores = competidores
      @generacion = 0
      @generacion += 1
      generaPoblacion
      getElitismo
      agregaData
      obtenElMejor
      intercambia
      
  end
  
  def generaPoblacion
    @poblacionNueva = Array.new
    numberOfGroups = 2
    minDepth = 2
    maxDepth = @maxDepth
    sizeOfGroups = @poblacion/numberOfGroups
    usingFullMethod = sizeOfGroups / 2
    usingGrowMethod = usingFullMethod
    for i in 1..numberOfGroups
      for j in 1..sizeOfGroups
        if j <= usingFullMethod then
          if (i == 1) then
            individuo = Individuo.new(minDepth,newMaxDepth)
            individuo.fullMethod
            @poblacionNueva << individuo
          else
            individuo = Individuo.new(maxDepth,newMaxDepth)
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
    prepareFolders
    evaluaPoblacion
    print "Fitness de la generacion: "
    print @evaluacionNueva
    print "Generacion: "
    print @generacion
  end
  
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
    end
  end
  
  def evaluaPoblacion
    for i in 1..@poblacion
      save(i-1,@poblacionNueva[i-1])
      compile(i-1)
    end
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
  
  def compile(individuo)
    compileString = "javac -classpath libs/robocode.jar robots/Individuo"+individuo.to_s+"/Individuo"+individuo.to_s+".java"
    system(compileString)
  end
  
  def evaluaTotal
    @evaluacionNueva = Array.new
    for i in 0...@poblacion
      for j in 0...@competidores.size
        ejecutaBattle(i.to_s,@competidores[j].delete(" "))
      end
    end
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
  
  def ejecutaBattle(individuo1,individuo2)
    stringBattle = "java -DPARALLEL=true -classpath libs/robocode.jar robocode.Robocode -battle battles/"+
                  individuo1+individuo2+".battle -nodisplay -results results/"+individuo1+individuo2+".txt > /dev/null"
    system(stringBattle)
  end
  
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
    ganador = Individuo.new(@profundidadArboles[indexWine][0],@profundidadArboles[indexWine][1])
    ganador.tree = JSON.parse(@poblacionVieja[indexWine],:max_nesting => false)
    return ganador
  end
  
  # Agrega los mejores individuos de 
  # la generacion anterior en la nueva
  # poblacion
  def setElitismo
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
          padre1 = tournament()
          padre2 = tournament()   
          if (@proCruza > rand) then
            crossover = false
            hijos = padre1.crossover(padre2)
            hijo1 = hijos[0]
            hijo2 = hijos[1]
          end
        end
        
        if (@proMutacion > rand) then
          hijo1.mutation
        end
        if (@proMutacion > rand) then
          hijo2.mutation
        end
        @poblacionNueva.push(hijo1)
        @poblacionNueva.push(hijo2)
      end
      @generacion += 1
      setElitismo
      evaluaPoblacion
      print "Fitness de la generacion: "
      print @evaluacionNueva
      print "   ----    Generacion: "
      print @generacion
      getElitismo
      puts " -----   El mejor individuo de la genracion: "+ @elitismoFitness.to_s
      obtenElMejor
      agregaData
      intercambia
    end
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
  end
end

