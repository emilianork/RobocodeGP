#!/usr/bin/env ruby
 
# Clase que representa una funcion o una
# funcion terminal, nos dice cual es la
# aridad de la funcion, si es una funcion
# o no, y por ultimo su expresion formal
# en java.
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
    if isFunct then
      @arity = hashArity[@funct] 
    else
      @arity = 0
    end
    @javaExpresion = hashFunctJAVA[@funct]
  end
end
