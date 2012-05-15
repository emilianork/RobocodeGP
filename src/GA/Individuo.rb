require 'tree'

class Individuo
  attr_accessor :maxDepth
  
  def initialize(maxDepth)
    @maxDepth = maxDepth
    @listFunctNum = { 1 => "Abs", 2 => "Neg",3 => "Sin",4 => "Cos",5 => "ArcSin",6 => "ArcCos",
                      7 => "IfPositive",8 => "IfGreater",9 => "Add",10 => "Sub",11 => "Mult",
                      12 => "Div"}
    @listFunctArity = {"Abs" => 1, "Neg" => 1, "Sin" => 1,
                  "Cos" => 1, "ArcSin" => 1, "ArcCos" => 1,
                  "IfPositive" => 3,
                  "IfGreater" => 4,
                  "Add" => 2, "Sub" => 2, "Mult" => 2,
                  "Div" => 2}
    @listFunctJAVA = {"Abs" => "Math.abs(#1)", "Neg" => "-1*Math.asb(#1)", "Sin" => "Math.sin(#1)",
                  "Cos" => "Math.cos(#1)", "ArcSin" => "Math.asin(#1)", "ArcCos" => "Math.acos(#1)",
                  "IfPositive" => "if 0 < #1 {\n #2;\n } else { \n#3;\n}",
                  "IfGreater" => "if #1 < #2 {\n #3;\n } else { \n#4;\n}",
                  "Add" => "#1 + #2", "Sub" => "#1 - #2", "Mult" => "#1 * #2",
                  "Div" => "#1 / #2"}
      
    @listTermJAVA = {"Energy" => "getEnergy()","Velocity" => "getVelocity()","X" => "getX()",
                  "Y" => "getY()", "BattleFieldHeight" => "getBattleFieldHeight()",
                  "BattleFieldWidth" => "getBattleFieldWidth()", "Zero" => "0",
                  "PI" => "Math.PI", "Random" => "this.random"}
    @listTermNum = {1 =>"Energy", 2 => "Velocity",3=>"X", 4 =>"Y", 5 =>"BattleFieldHeight",
                      6 =>"BattleFieldWidth",7 => "Zero", 8 => "PI", 9 => "Random"}
  end
end