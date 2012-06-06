require './src/GA/Individuo.rb'

a = Individuo.new(2,10)
a.growMethod
b = Individuo.new(2,10)
b.growMethod
a.crossover(b)