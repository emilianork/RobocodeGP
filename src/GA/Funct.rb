 #!/usr/bin/env ruby
class Funct
  attr_accessor :funct, :isFunct, :arity, :javaExpresion
  # * *Args*    :
  #
  # * *Returns* :
  #   - +Funct+ la abstraccion de funciones y terminales.
  # * *Raises* :
  #
  def initialize(listFunct,hashFunctJAVA,hashArity,isFunct)
    @isFunct = isFunct
    @funct = listFunct[rand(1..listFunct.size).to_i]
    @arity = hashArity[@funct] if isFunct
    @javaExpresion = hashFunctJAVA[@funct]
  end
end