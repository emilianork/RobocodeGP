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
      #generaPoblacion
      #agregaData
      #@generacion += 1
      #getElitismo
      #intercambia
  end
  
  #def generaPoblacion
  #  @poblacionNueva = Array.new(@poblacion)
  #  @evaluacionNueva = Array.new(@poblacion)
  #  for i in 0...@poblacion
  #    
  #  end
    
  #end
  
end
