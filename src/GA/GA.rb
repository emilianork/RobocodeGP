require './src/GA/Individuo.rb'

class GA
  attr_reader :poblacion, :proCruza, :proMutacion, :maxGeneraciones, :individuosTorneo,
              :poblacionNueva, :poblacionVieja, :elMejor, :generacionElMejor,
              :mejorFitness, :elitismo, :evaluacionNueva, :evaluacionVieja,
              :datosAlgoritmo, :generacion, :minDepth, :maxDepth
           
           
     
  def initialize(poblacion,proCruza,proMutacion,maxGeneraciones,individuosTorneo,
                minDepth,maxDepth)
      @poblacion = poblacion
      @proCruza = proCruza
      @proMutacion = proMutacion
      @maxGeneraciones = maxGeneraciones
      @individuosTorneo = individuosTorneo
      @minDepth = minDepth
      @maxDepth = maxDepth
      @data = Array.new(maxGeneraciones){Array.new(poblacion)}
      generaPoblacion
      #agregaData
      #@generacion += 1
      #getElitismo
      #intercambia
  end
  
  def generaPoblacion
    @poblacionNueva = Array.new
    numberOfGroups = @maxDepth - @minDepth
    actualDepth = @minDepth
    fullMethod = false
    poblador = 0
    for i in 1..numberOfGroups
      for j in 1..(@poblacion/numberOfGroups)
        nuevoIndividuo = Individuo.new(actualDepth)
        if fullMethod then
          nuevoIndividuo.fullMethod
          @poblacionNueva.push(nuevoIndividuo)
          fullMethod = false
        else
          nuevoIndividuo.growMethod
          @poblacionNueva.push(nuevoIndividuo)
          fullMethod = true
        end
        poblador+=1
      end
      actualDepth+=1
    end
    completo_la_poblacion = poblador == @poblacion
    if (!completo_la_poblacion) then
      while (!completo_la_poblacion) do
        nuevoIndividuo = Individuo.new(@maxDepth)
        if fullMethod then
          nuevoIndividuo.fullMethod
          @poblacionNueva.push(nuevoIndividuo)
          fullMethod = false
        else
          nuevoIndividuo.growMethod
          @poblacionNueva.push(nuevoIndividuo)
          fullMethod = true
        end
        poblador+=1
        completo_la_poblacion = poblador == @poblacion
      end
    end
    #evaluaPoblacion
  end
  
end
