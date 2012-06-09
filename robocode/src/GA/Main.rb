require './src/GA/GA.rb'
#require './src/GA/Individuo.rb'
#require './src/GA/Decode.rb'

poblacion = 16
proCruza = 0.85
proMutacion = 0.05
maxGeneraciones = 25
individuosTorneo = 5
maxDepth = 4
newMaxDepth = 6
competidores = Array.new

competidores1 = Array.new
#((((
(competidores1 << "tvv.nano.Polaris 1.1")# << "oog.melee.Capulet 1.2") << "mk.Alpha 0.2.1") <<"kid.Gladiator .7.2") <<"chase.s2.Genesis 1.1")

a = GA.new(poblacion,proCruza,proMutacion,maxGeneraciones,individuosTorneo,maxDepth,newMaxDepth,competidores1)


#(((
(competidores << "sample.Fire") #<< "sample.Corners") << "sample.Interactive") << "sample.RamFire") << "sample.SpinBot"

#a = GA.new(poblacion,proCruza,proMutacion,maxGeneraciones,individuosTorneo,maxDepth,newMaxDepth,competidores)
a.run

data = a.data
string = ""
for i in 1..maxGeneraciones
  for j in 1..poblacion
    string += data[i-1][j-1].to_s + " "
  end
  string += "\n"
end
file = File.open("Robocode.dat","w+")
file.write(string)
file.close
#1000.times {
#  a = Individuo.new(2,4)
#  b = Individuo.new(6,4)
#  a.growMethod
#  b.fullMethod
#  array = a.crossover(b)
#  array[0].crossover(array[1])
#  b1 = Decode.new(array[0],"name2")
#  b2 = Decode.new(array[1],"name1")
#}


