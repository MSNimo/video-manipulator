import processing.video.*;
import processing.net.*;
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;
import java.awt.event.InputEvent;
//package uncommonhacks_testcode;
import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

Movie myMovie;
int x = 1;
int start;
int timer = 0;

//int[] test_nums = {0, 21760, 25070, 25860, 32500, 37190, 44120, 62110};
//String[] test_nums = {"00.00.00,0000", "00.00.21,0760", "00.00.25,0070", "00.00.32,0500",
                              //  "00.00.37,0190", "00.00.44,0120", "00.01.02,0110"}; //input
//double[] input_nums;
//int input_num_size;

public String [][] values;
public float ADD_FAC = 1; //interval for speed change
static int num_stamps;
public double[] output;
public double[] real_output;

void setup() {
  size(640, 360); //set to video resolution
  frameRate(30); 
 
String pathe = "C:\\Users\\mikeb\\Documents\\Github\\video-manipulator\\VideoEdit\\data\\"; 
String name = "";
File folder = new File(pathe);
File[] listOfFiles = folder.listFiles();

    for (int i = 0; i < listOfFiles.length; i++) {
      if (listOfFiles[i].isFile()) {
        name = listOfFiles[i].getName();
      } 
    }
  
  myMovie = new Movie(this, pathe + name); //file name from data folder
  myMovie.loop(); //loop video
  
  //code here
  hacks_testcode a = new hacks_testcode(ADD_FAC);
  try {
        output = a.mikeFunction(); 
    }
    catch (FileNotFoundException e) {
        throw new RuntimeException(e);
    }
   real_output = new double[num_stamps];
  for (int b = 0; b<num_stamps; b++){
  real_output[b] = output[b];
}
  //timeConverter a = new timeConverter(test_nums, SPEED_FACTOR);
  //input_nums = a.convert_stamps(a.reformat_times(test_nums));
  
  start = millis(); //timer starts after intializing
}

void draw() {
  
  if (myMovie.available()) {
    myMovie.read();
  }
  image(myMovie, 0, 0);
  timer = millis()-start;
  text(timer, 20, 20);
  text(Integer.toString((int)real_output[1]), 30, 30);
  //code here

  
  if ( (x < (real_output.length))&&((double)timer/real_output[x] > 1)) {
      x += 1;
      float z = x * ADD_FAC;
      myMovie.speed(z);
    }
}

public class hacks_testcode{
    
      /*public static void main(String[] args) throws FileNotFoundException 
      {
        float ADD_FACTOR = (float)0.5;
        hacks_testcode z = new hacks_testcode(ADD_FACTOR);
        double [] output= z.mikeFunction();
        //System.out.println("Num_stamps =" +num_stamps);
        
        //for (int i = 0; i < output.length; i++) System.out.println(output[i]);
        
      }   */     
      public double[] mikeFunction() throws FileNotFoundException
      {
          String path  = "C:\\Users\\mikeb\\Documents\\GitHub\\video-manipulator\\temp_caption"; //CHANGE THIS
          File f = new File(path + "\\captions.txt"); 
      
        Scanner sc = new Scanner(f);
      
          int tot = 0;
          int interval = 0;
          
          while (sc.hasNextLine()) {
                    String i = sc.nextLine();
                    //System.out.println(i);
                    interval++;
                    //System.out.println(interval);
                    if (interval == 4){
                     interval = 0;
                     tot++;
                    }
                }
          tot ++;
          
          int num = 2*tot;
          //System.out.println(tot);
          values = new String [num][];
          sc.close();
          
          Scanner sc2 = new Scanner(f);
          int counter = 0;
          int pos = 0;
          
          while (sc2.hasNextLine()) {
           
           String i = sc2.nextLine();
           if (counter == 0){
            counter++;
            continue;
           }
           if (counter == 1){
            counter++;
            i = i.replaceAll("--> ","");
            values [pos]  = i.split(" ");
            pos++;
            continue;
           }
           
           if (counter == 2){
            counter++;
            i = i.replaceAll("<.*?>","");
            values [pos]  = i.split(" ");
            pos++;
            continue;
           }
           
           if (counter == 3){
            counter = 0;
            continue;
           }
          }
          
          sc2.close();
          File f2 = new File(path + "\\keyword.txt");
          Scanner sc3 = new Scanner(f2);
          String keyw = sc3.nextLine();
          double [] sol = find_posns(keyw);
          double [] fin = convert_stamps(sol);
          return fin;
          
        }
      /*public static void main(String[] args) 
      {        
          String[] test_nums = {"00.00.00,0000", "00.00.30,0000", "00.00.33,0000",
                                  "00.00.34,0000", "00.01.18,0000", "00.01.19,0000", "00.01.40,0000"}; //input
          double adding_factor = 0.5;    //input
          //testing 
          for (int b = 0; b<test_nums.length; b++) //testing
              {System.out.println("Number " + b + ": " + test_nums[b]);}          
          timeConverter a = new timeConverter(test_nums, adding_factor);    
          double[] output_stamps = a.convert_stamps(a.reformat_times(test_nums));        
          //testing
          for (int c = 0; c<output_stamps.length; c++) //testing
          {System.out.println("Number " + c + ": " + output_stamps[c]);}
      } */
      public hacks_testcode(float add_factor)
      {
          ADD_FAC = add_factor;
          values = new String[2000][];
          num_stamps = values.length;
      }
      public double[] find_posns(String keyw)
      {//takes a 2d array of strings containing values about location of a word in a video
        //and returns an array of strings with just the timestamps.
        //The input values will be of the form:
        /*
        [start of timeinterval] [end of time interval]
        [word 1] [word 2] ... [word n] //n can be zero though
        */
        int ROWS = values.length; //returns the height of the array
        double interval_len = -1111.1; //set to this weird number initally in case there are errors
        //String[] word_list;
        double val;
        double[] output = new double[num_stamps]; //will have
        int outputsize = 0;
        for(int q = 0; q<ROWS - 2; q+=2)
        {
            double []times = reformat_times(values[q]);
            interval_len = times[1] - times[0];
            val = wordposn(values[q+1], keyw);
            if (!(val<0)) 
            {
              output[outputsize] = times[0] + val*interval_len;
              outputsize++;
            }
        }
        num_stamps = outputsize; //updates the number of stamps in the list
        return output;
      }
      public double wordposn(String[] words, String keyword)
      {//returns the position of a keyword in an array of words, otherwise returns -1
        int location = -1;
        int ind = 0;
        while(ind < words.length)
        {
           if (words[ind].equalsIgnoreCase(keyword)) //case insensitive comparison
           {
             location = ind;
             break; 
           }
          ind++;
        }
        double relPos = (double) location / (words.length);
        
        return relPos;
       }
      
      public double[] reformat_times(String[] stamps) 
      {//takes numbers in the 00:00:00,0000 and converts them into milliseconds
          double[] out = new double[stamps.length];
          for (int m =0; m<stamps.length; m++)
          {

              String curr = stamps[m]; //curr should have 13 characters
              int safety = curr.length();
              //System.out.println(curr);
              out[m] += 36000000 * Double.parseDouble(curr.substring(0,2));//convert hours  to millis
              //System.out.println(m + " " + out[m]);
              out[m] += 60000 * Double.parseDouble(curr.substring(3,5));//convert minutes to millis
              //System.out.println(m + " " + out[m]);
              out[m] += 1000 * Double.parseDouble(curr.substring(6,8));//convert seconds to millis
              //System.out.println(m + " " + out[m]);
              out[m] += Double.parseDouble(curr.substring(9,safety));//add the millis to millis            
              //System.out.println(m + " " + out[m]);
          }
          return out;            
      }
      public double[] convert_stamps(double[] old_stamps)
      {//takes millisecond timestamps of when a word occurs in the video, and respaces the time stamps
      //such that they allow for the video to be speeded up between them.
          int array_cap = values.length;
          double[] new_stamps = new double[array_cap];        
          new_stamps[0] = old_stamps[0];
          double speed_int = 1;            
          double t_nxt_std = old_stamps[1] - old_stamps[0];
          double t_nxt_adp = t_nxt_std/speed_int;        
          for (int i=1; i< (array_cap); i++)
          {
              new_stamps[i] = (double)Math.round(100*(t_nxt_adp + new_stamps[i-1]))/100;
              speed_int = 1 + (double)ADD_FAC * i;
              if (! (i == (array_cap - 1)))
                      {t_nxt_std = old_stamps[i+1] - old_stamps[i];}
              t_nxt_adp = t_nxt_std/speed_int;            
          }                
          return new_stamps;
      }
  }
  
//JUNK BELOW!!!  
/*
public class timeConverter {
    public float ADD_FAC; //interval for speed change
    public String[] time_stamps_old;
    int num_stamps;
    
    /*public static void main(String[] args) 
    {        
        String[] test_nums = {"00.00.00,0000", "00.00.30,0000", "00.00.33,0000",
                                "00.00.34,0000", "00.01.18,0000", "00.01.19,0000", "00.01.40,0000"}; //input
        double adding_factor = 0.5;    //input
        //testing 
        for (int b = 0; b<test_nums.length; b++) //testing
            {System.out.println("Number " + b + ": " + test_nums[b]);}          
        timeConverter a = new timeConverter(test_nums, adding_factor);    
        double[] output_stamps = a.convert_stamps(a.reformat_times(test_nums));        
        //testing
        for (int c = 0; c<output_stamps.length; c++) //testing
        {System.out.println("Number " + c + ": " + output_stamps[c]);}
    } */
   /* public timeConverter(String[] stamps, int numStamps, float add_factor)
    {
        time_stamps_old = stamps;
        ADD_FAC = add_factor;
        num_stamps = numStamps;
    }
    public double[] find_posns(String[][] data, String keyw)
    {//takes a 2d array of strings containing data about location of a word in a video
      //and returns an array of strings with just the timestamps.
      //The input data will be of the form:
      /*
      [start of timeinterval] [end of time interval]
      [word 1] [word 2] ... [word n] //n can be zero though
      */
      /*int ROWS = data.length; //returns the height of the array
      double interval_len = -1111.1; //set to this weird number initally in case there are errors
      //String[] word_list;
      double val;
      double[] output = new double[num_stamps]; //will have
      int outputsize = 0;
      for(int q = 0; q<ROWS; q+=2)
      {
          double [] times = reformat_times(data[q]);
          interval_len = times[1] - times[0];
          val = wordposn(data[q+1], keyw);
          if (!(val<0)) 
          {
            output[outputsize] = times[0] + val*interval_len;
            outputsize++;
          }
      }
      num_stamps = outputsize; //updates the number of stamps in the list
      return output;
    }
    public double wordposn(String[] words, String keyword)
    {//returns the position of a keyword in an array of words, otherwise returns -1
      int location = -1;
      int ind = 0;
      while(ind < words.length)
      {
         if (words[ind].equalsIgnoreCase(keyword)) //case insensitive comparison
         {
           location = ind;
           break; 
         }
        ind++;
      }
      double relPos = (double) location / (words.length);
      
      return relPos;
     }
    
    public double[] reformat_times(String[] stamps) 
    {//takes numbers in the 00:00:00,0000 and converts them into milliseconds
        double[] out = new double[time_stamps_old.length];
        for (int m =0; m<time_stamps_old.length; m++)
        {
            String curr = stamps[m]; //curr should have 13 characters
            out[m] += 36000000 * Double.parseDouble(curr.substring(0,2));//convert hours  to millis
            out[m] += 60000 * Double.parseDouble(curr.substring(3,5));//convert minutes to millis
            out[m] += 1000 * Double.parseDouble(curr.substring(6,8));//convert seconds to millis
            out[m] += Double.parseDouble(curr.substring(9,12));//add the millis to millis            
        }
        return out;            
    }
    public double[] convert_stamps(double[] old_stamps)
    {//takes millisecond timestamps of when a word occurs in the video, and respaces the time stamps
    //such that they allow for the video to be speeded up between them.
        int array_cap = time_stamps_old.length;
        double[] new_stamps = new double[array_cap];        
        new_stamps[0] = old_stamps[0];
        double speed_int = 1;            
        double t_nxt_std = old_stamps[1] - old_stamps[0];
        double t_nxt_adp = t_nxt_std/speed_int;        
        for (int i=1; i< (array_cap); i++)
        {
            new_stamps[i] = (double)Math.round(100*(t_nxt_adp + new_stamps[i-1]))/100;
            speed_int = 1 + (double)ADD_FAC * i;
            if (! (i == (array_cap - 1)))
                    {t_nxt_std = old_stamps[i+1] - old_stamps[i];}
            t_nxt_adp = t_nxt_std/speed_int;            
        }                
        return new_stamps;
    }
}


/*   WORKING DRAW STATEMENT

void draw() {
  
  if (myMovie.available()) {
    myMovie.read();
  }
  image(myMovie, 0, 0);
  timer = millis()-start;
  text(timer, 20, 20);
  
  if (timer/x > 5000) {
      x += 1;
      myMovie.speed(x);
    }
}

*/

/*

void speedChange() {
  for (int i = 0; i < (myMovie.duration() * 100000); i++)
  {
    if ((i % 500000) == 0) 
    {
      x = x+.5;
      myMovie.speed(x); 
    }
    //try{ Thread.sleep(1); }
    //catch(InterruptedException e){System.out.println("got interrupted!");}
  }
}

void increaseSpeed() {
while (timer < (myMovie.duration() * 1000))
  {
    if (timer % 5000 == 0) {
      x += 5;
      myMovie.speed(x);
    }
  }
}

void robotCompleteScan() { // last robotFunc() called.
  robot.mouseMove(10, 10); // X Y location of button.
    robot.mousePress(InputEvent.BUTTON1_MASK); delay(100); // Wait for OS.
  robot.mouseRelease(InputEvent.BUTTON1_MASK); delay(100); 
}


void mousePressed() {
  x = x + 0.5;
  myMovie.speed(x);
}

 


/*
public class timeConverter{
  
    public double ADD_FAC; //interval for speed change
    public double[] time_stamps_old;
    public static void main(String[] args) 
    {        
        double[] test_nums = {0, 21.76, 25.07, 25.86, 32.50, 37.19, 44.12, 62.11}; //input
        double adding_factor = 0.5;    //input
        /*for (int b = 0; b<test_nums.length; b++) //testing
        {System.out.println("Number " + b + ": " + test_nums[b]);}        
        timeConverter a = new timeConverter(test_nums, adding_factor);        
        double[] output_stamps = a.convert_stamps(test_nums);        
        /*for (int c = 0; c<output_stamps.length; c++) //testing
        {System.out.println("Number " + c + ": " + output_stamps[c]);}    
    } 
    public timeConverter(double[] stamps, double add_factor)
    {
        time_stamps_old = stamps;
        ADD_FAC = add_factor;
    }
    public double[] convert_stamps(double[] old_stamps)
    {    
        int array_cap = time_stamps_old.length;
        double[] new_stamps = new double[array_cap];        
        new_stamps[0] = old_stamps[0];
        double speed_int = 1;            
        double t_nxt_std = old_stamps[1] - old_stamps[0];
        double t_nxt_adp = t_nxt_std/speed_int;        
        for (int i=1; i< (array_cap); i++)
        {
            new_stamps[i] = (double)Math.round(1000*(t_nxt_adp + new_stamps[i-1]))/1000;
            speed_int = 1 + ADD_FAC * i;
            if (! (i == (array_cap - 1)))
                    {t_nxt_std = old_stamps[i+1] - old_stamps[i];}
            t_nxt_adp = t_nxt_std/speed_int;            
        }                
        return new_stamps;
    }
}
*/