 #!/usr/bin/env ruby
class Funct
  attr_accessor :funct, :isFunct
  # * *Args*    :
  #
  # * *Returns* :
  #   - +Funct+ la abstraccion de funciones y terminales.
  # * *Raises* :
  #
  def initialize(listFunct,listFunctJAVA,listArity,isFunct)
    @funct = nil
    @arity = 
    @isFunct = isFunct

  end
  
  # * *Args*    :
  #
  # * *Returns* :
  #   - +String+ Regresa la expresion de la funcion en java
  # * *Raises* :
  #
  def getJavaExpresion
    if isFunct then
      @listFunctJava[@func]
    else
      @listTermJava[@func]
    end
  end
  # * *Args*    :
  #
  # * *Returns* :
  #   - +Number+ Regresa la aridad que tiene la funcion o la terminal
  # * *Raises* :
  #
  def getArity
    if isFunct then
      @listFunctArity[@func]
    else 
      0
    end
  end
  # * *Args*    :
  #   - +Nil+ El objeto genera de forma random una funcion
  # * *Returns* :
  #   - +Nil+
  # * *Raises* :
  #
  def generateFunct
    @func = @listFunctNum[rand(1..12).to_i]
    @isFunct = true
  end
  # * *Args*    :
  #   - +Nil+ El objeto genera de forma random una terminal
  # * *Returns* :
  #   - +Nil+
  # * *Raises* :
  #
  def generateTerm
    @func = @listTermNum[rand(1..9).to_i]
    @isFunct = false
  end
end