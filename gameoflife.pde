Life life;
PImage img;
boolean running = false;

void setup() {
  size(500, 500);
  //Load the image.
  img = loadImage("eye.jpg");
  //Create a new Game of Life, with each cell being 5 pixels in dimension.
  //And a threshold of 105.
  life = new Life(5, 105);
  frameRate(10);
}

void draw() {
  //If the game of life is running, then update it and display it each iteration of draw().
  if (running) {
    life.update();
    life.display();    
  }
}

//Press the mouse to start/stop the game of life.
void mousePressed() {
  running = !running;
}

class Life {
  private int cellSize;
  private int currentState[][];
  private int tempState[][];
  private color pixl;
  private int average;
  private int threshold;

  public Life(int size, int thresh) {
    this.cellSize = size;
    this.threshold = thresh;
    this.currentState = new int[width/this.cellSize][height/this.cellSize];
    this.tempState = new int[width/this.cellSize][height/this.cellSize];
    this.initialize();
  }
  
  public void initialize() { //<>//
    //Iterate over the whole image, using the size of the cell as the step.
    for (int x = 0; x < img.width / this.cellSize; x++) {
     for (int y = 0; y < img.height / this.cellSize; y++) {
       pixl = img.get(x * this.cellSize, y * this.cellSize);
       //Finding how "bright" each pixel is. The lower the value, the darker the pixel.
       //For instance, a dark blue of rgb(0, 0, 153) is (0 + 0 + 153) / 3 = 51. 
       //A light yellow of rgb(255, 255, 102) is (255 + 255 + 102) / 3 = 204. 
       average = (int(red(pixl)) + int(green(pixl)) + int(blue(pixl))) / 3;
       
       /* Now that we have the average of the pixel at this location, we have to check if
       it falls under the threshold specified. If the pixel is dark enough, then the corresponding
       cell in the game-of-life board is set to living. */
       if (average < this.threshold) {
         this.currentState[x][y] = 1;
       } else {
         //Pixel is too bright, discard it.
         this.currentState[x][y] = 0;
       }
     }
    }
    //After initialization, display the loaded image. 
    this.display();
  }
  
  public void update() {
    //Copy all the values of currentState in to tempState.
    for (int x = 0; x < width / this.cellSize; x++) {
      for (int y = 0; y < height / this.cellSize; y++) {
        this.tempState[x][y] = this.currentState[x][y];
      }
    }
    
    //Iterate through all the cells of the 2D array.
    for (int x = 0; x < width / this.cellSize; x++) {
      for (int y = 0; y < height / this.cellSize; y++) {
        //If the cell is living.
        if (this.tempState[x][y] == 1) {
          /* Check neihbors. If under 2, kill the cell due to underpopulation.
          If more than 3, then kill the cell due to overpopulation. Rules 1 and 3. */
          if (this.countNeighbors(x, y) < 2 || this.countNeighbors(x, y) > 3) {
            this.currentState[x][y] = 0;
          }
        } else {
          //A dead cell with 3 live neighbors becomes alive through reproduction. Rule 4.
          if (this.countNeighbors(x, y) == 3) {
            this.currentState[x][y] = 1;
          }
        } // Rule 2. "Any live cell with two or three live neighbours lives on to the next generation.".
      }
    }
  }
  
  //Displays the board.
  public void display() {
    //noStroke determines wether the squares will have an outline.
    noStroke();
    
    //Iterate through the whole currentState array.
    for (int x = 0; x < width / this.cellSize; x++) {
      for (int y = 0; y < height / this.cellSize; y++) {
        //If a cell is alive.
        if (this.currentState[x][y] == 1) {
          //Draw a black square.
          fill(0);
          rect(x * this.cellSize, y * this.cellSize, this.cellSize, this.cellSize);
        } else {
          //If it's not alive, draw a white square.
          fill(255, 255, 255);
          rect(x * this.cellSize, y * this.cellSize, this.cellSize, this.cellSize);
        }
      }
    }
  }
  
  public int countNeighbors(int row, int col) {
    int count = 0;
    
    for(int i = row - 1; i <= row + 1; i++) {
      //Checks overflow.
      if (i >= 0 && i < this.tempState.length) {
        for(int j = col - 1; j <= col + 1; j++) {
          if (j >= 0 && j < this.tempState[i].length) {
            if (i != row || j != col) {
              if (this.tempState[i][j] == 1) { 
                  count++;
              }
            }
          }
        }
      }
    }

    return count;
  }
}