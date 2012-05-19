require './src/GA/Individuo.rb'

class Decode
  attr_accessor :individuo, :javaExpresion
  def initialize(individuo)
    @individuo = individuo
    @javaExpresion = "package SimpleRobot;\n" +
                      "import robocode.*;\n" +
                      "import java.awt.Color;\n" +
                      "// API help : http://robocode.sourceforge.net/docs/robocode/robocode/Robot.html\n" +
                      "/**\n" +
                      "* MyFirstRobot - a robot by (your name here)\n" +
                      "*/\n" +
                      "public class MyFirstRobot extends Robot\n" +
                      "{\n" +
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
    		              "\t\tturnRight(#3);\n"+
    		              "\t\tahead(#2);\n"+
    	                "\t}\n"+ 
    	                "\t/**\n"+
    	                "\t* onHitBullet: What to do when your bullet hit another robot\n"+
    	                "\t*/\n"+
    	                "\tpublic void onHitBullet(HitWallEvent e) {\n"+
    		              "\t\t// Replace the next line with any behavior you would like\n"+
    		              "\t\tturnRight(#5);\n"+
    		              "\t\tahead(#4);\n"+
    	                "\t}\n"+
    	                "\t/**\n"+
    	                "\t* onHitByBullet: What to do when you're hit by a bullet\n"+
    	                "\t*/\n"+
    	                "\tpublic void onHitByBullet(HitByBulletEvent e) {\n"+
    		              "\t\t// Replace the next line with any behavior you would like\n"+
    		              "\t\tturnRight(#7);\n"+
    		              "\t\tahead(#6);\n"+
    	                "\t}\n"+
                      "}\n"
  end
end

a = Decode.new(1)
print a.javaExpresion