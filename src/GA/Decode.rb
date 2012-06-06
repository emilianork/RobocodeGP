require './src/GA/Individuo.rb'

class Decode
  attr_accessor :individuo, :javaExpresion
  # * *Args*    :
  #   -+Individuo+ Individuo que se va a codificar
  # * *Returns* :
  #  
  # * *Raises* :
  #
  def initialize(individuo,name)
    @individuo = individuo
    @javaExpresion = "package SimpleRobot;\n" +
      "import robocode.*;\n" +
      "import java.awt.Color;\n" +
      "import java.util.Random;\n" +
      "// API help : http://robocode.sourceforge.net/docs/robocode/robocode/Robot.html\n" +
      "/**\n" +
      "* MyFirstRobot - a robot by (your name here)\n" +
      "*/\n" +
      "public class #2 extends Robot\n" +
      "{\n" +
      "\tprivate double random = (new Random()).nextDouble();\n"+
      "\t/**\n" +
      "\t* run: MyFirstRobot's default behavior\n" +
      "\t*/\n"+
      "\tpublic void run() {\n"+
      "\t\t// Initialization of the robot should be put here\n"+
      "\t\t// After trying out your robot, try uncommenting the import at the top,\n"+
      "\t\t// and the next line:\n"+
      "\t\tsetColors(Color.yellow,Color.blue,Color.yellow); // body,gun,radar\n"+
      "\t\t// Robot main loop\n"+
      "\t\twhile(true) {\n"+
      "\t\t\tturnGunRight(360);\n"+
      "\t\t}\n"+
      "\t}\n"+
      "\t/**\n"+
      "\t* onScannedRobot: What to do when you see another robot\n"+
      "\t*/\n"+
      "\tpublic void onScannedRobot(ScannedRobotEvent e) {\n"+
      "\t\t// Replace the next line with any behavior you would like\n"+
      "\t\tfire(#1);\n"+
      "\t\tturnRight(#1);\n"+
      "\t\tahead(#1);\n"+
      "\t}\n"+ 
      "\t/**\n"+
      "\t* onHitBullet: What to do when your bullet hit another robot\n"+
      "\t*/\n"+
      "\tpublic void onBulletHit(BulletHitEvent e) {\n"+
      "\t\t// Replace the next line with any behavior you would like\n"+
      "\t\tturnRight(#1);\n"+
      "\t\tahead(#1);\n"+
      "\t}\n"+
      "\t/**\n"+
      "\t* onHitByBullet: What to do when you're hit by a bullet\n"+
      "\t*/\n"+
      "\tpublic void onHitByBullet(HitByBulletEvent e) {\n"+
      "\t\t// Replace the next line with any behavior you would like\n"+
      "\t\tturnRight(#1);\n"+
      "\t\tahead(#1);\n"+
      "\t}\n"+
      "\tpublic double ifPositive(double bool,double e1,double e2) {\n" +
      "\t\tif(bool >= 0) {\n"+
      "\t\t\treturn e1;\n"+
      "\t\t} else {\n"+
      "\t\t\treturn e2;\n" +
      "\t\t}\n"+
      "\t}\n"+
      "\tpublic double ifGreater(double b1,double b2,double e1,double e2) {\n" +
      "\t\tif(b1 > b2) {\n"+
      "\t\t\treturn e1;\n"+
      "\t\t} else {\n"+
      "\t\t\treturn e2;\n" +
      "\t\t}\n"+
      "\tpublic double div(double b1,double b2) {\n" +
      "\t\tif(b2 == 0) {\n"+
      "\t\t\treturn 0;\n"+
      "\t\t} else {\n"+
      "\t\t\treturn b1/b2;\n" +
      "\t\t}\n"+
      "\t}\n"+
      "}\n"
    @javaExpresion["#2"] = name
  end
  
  # Funcion principal para decodificar el
  # arbol del individuo en un Programa de Java.
  def decode
    decodeAux(individuo.tree)
  end
  
  # Funcion auxiliar de la funcion "decode"
  # para llevar el rastro del subarbol en el
  # cual estoy trabajando.
  def decodeAux(subtree)
    name = subtree.name
    if subtree.is_root? || (name == "onScannedRobot") || 
        (name == "onHitBullet" || (name == "onHitByBullet") ||
         (name == "onHead1") || (name == "onHead2") || (name == "onHead3") ||
         (name ==  "TurnRigth1") || (name == "TurnRigth2") ||
         (name == "TurnRigth3") || (name == "Fire")) then
      subtree.children{
        |child|
        decode(child)
      }
    else
      funct = subtree.content
      @javaExpresion["#1"] = funct.javaExpresion.clone
      subtree.children{
        |child|
        decode(child)
      }
    end
  end
end
