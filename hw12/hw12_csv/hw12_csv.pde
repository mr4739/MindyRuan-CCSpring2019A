/*
hw12_csv/hw12_csv.pde
Author: Mindy Ruan
Assignment: Use Processing to work with a data file locally for the first one, 
and p5.js to work with an API for the second one.

Lottery balls showing the frequency of lottery numbers.
More frequent numbers are larger and brighter.

CSV file from: https://catalog.data.gov/dataset/lottery-mega-millions-winning-numbers-beginning-2002
*/

// Import for HashMap
import java.util.Map;

Table csvData;
// HashMap numberFreq
// key: String; value: Integer
// Key is the lotto ball number as a string
// Value is how many times that lotto ball has shown up
HashMap<String, Integer> numberFreq = new HashMap<String, Integer>();

// ArrayList of LottoBall objects
ArrayList<LottoBall> balls = new ArrayList<LottoBall>();

void setup() {
  size(1920, 1080);
  csvData = loadTable("LottoMegaMillionsWinningNumbers.csv", "header");
  textAlign(CENTER, CENTER);
  colorMode(HSB, 360, 100, 100, 100);
  noStroke();
  
  for (int i = 0; i < csvData.getRowCount(); i++) {
    TableRow currRow = csvData.getRow(i);
    
    // Get the strings of all winning numbers
    // Parse the strings to get the separate numbers
    String[] winNums = split(currRow.getString("Winning Numbers"), " ");
    for (int j = 0; j < winNums.length; j++) {
      // If number is not a key in numberFreq, add it to HashMap with value 1
      if (numberFreq.get(winNums[j]) == null) {
        numberFreq.put(winNums[j], 1);
      } else {
        // Key already in HashMap, increment the existing value by 1
        numberFreq.put(winNums[j], numberFreq.get(winNums[j]) + 1);
      }
    }
  }
  
  // Iterate through numberFreq using key
  for (String key : numberFreq.keySet()) {
    // Create a new LottoBall with random starting position
    // Use value to map a radius
    // Pass key (ball number) for text displaying
    balls.add(new LottoBall(random(0, width), random(0, height), map(numberFreq.get(key).intValue(), 1, 200, 40, 300), key));
  }
}

void draw() {
  background(0);
  // Update and draw all LottoBalls
  for (int i = 0; i < balls.size(); i++) {
    balls.get(i).update();
    balls.get(i).display();
  }
}
