import java.io.BufferedWriter;
import java.io.File; // Import the File class
import java.io.FileWriter;
import java.util.Scanner; // Import the Scanner class to read text files


public class GoldenModelMain {

    static double pi =3.14159265359;
    static double[] arcTan = {0.7854, 0.4636, 0.245, 0.1244, 0.0624, 0.0312, 0.0156, 0.0078, 0.0039, 0.002, 0.001 , 0.0005 , 0.0002 };

    public static void main(String[] args)  {
    try {
      File testFile = new File("test_input.txt");
      FileWriter writer = new FileWriter("test_result_golden_model.txt", false);
      BufferedWriter bufferedWriter = new BufferedWriter(writer);
      Scanner testScanner = new Scanner(testFile);
      String x , y , theta , result;
      for (int i = 0; i < 100; i++) {
          String mode = testScanner.nextLine();
          x = testScanner.nextLine();
          y = testScanner.nextLine();
          theta = testScanner.nextLine();
          if(mode.equals("0")){
            result =  rotate(x, y, theta);
          }else
            result =  phaseDetector(x, y);
          bufferedWriter.write(result);
          bufferedWriter.newLine();
      }
      testScanner.close();
      bufferedWriter.close();
    } catch (Exception e) {
      System.out.println("An error occurred.");
      e.printStackTrace();
    }
  }

  static String rotate(String x , String y , String theta){
        double xc = strToDouble(x);
        double yc = strToDouble(y);
        double z = strToDouble(theta);
        z = -adjustTheta(z);
        double cos = Math.cos(z);
        double sin = Math.sin(z);
        double resX = xc*cos + yc*sin;
        double resY = -xc*sin + yc*cos;
        String acs = doubleToStr(resX);
        String bcs = doubleToStr(resY);

        return acs + " " +  bcs + " x= "+resX+ " y= "+resY;
  }

  static String phaseDetector(String x , String y){
        double xc = strToDouble(x);
        double yc = strToDouble(y);
        double z = Math.atan2(yc , xc);
        String zs = doubleToStr(z);
        double size = Math.sqrt(Math.pow(xc,2) + Math.pow(yc, 2));
        String sizes = doubleToStr(size);
        return zs + " " + sizes + " theta= "+z + " size= "+ size;
  }

  static double strToDouble(String x){
        boolean neg = x.charAt(0) == '1';
        x = x.substring(1);
        int intVal = Integer.parseInt(x,2);
        double res = intVal;
        if(neg)
          res *= -1;
        for (int i = 0; i < 8; i++) {
            res /= 2;
        }
        return res;
  }

  static String doubleToStr(double f){
        for (int i = 0; i < 8; i++) {
            f *= 2;
        }
        int intVal = (int)Math.abs(f);
        String string = Integer.toBinaryString(intVal);
        while(string.length() < 15){
            string = "0" + string;
        }
        string = string.substring(string.length()-15);
        if(f < 0)
          string = "1" + string;
        else
          string = "0" + string;
        return string;
  }


  static double adjustTheta(double theta){
    double sign = theta > 0 ? 1 : -1;
    while(Math.abs(theta) > 2*pi){
      theta -= sign * 2 * pi;
      sign = theta > 0 ? 1 : -1;
    }
    return theta;
  }
}
