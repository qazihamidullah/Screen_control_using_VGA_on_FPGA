###Learning Objectives:    
1. Independently design a data-path and control-path system in Verilog.    
2. Gain experience in porting a software algorithm to hardware.  
3. Gain experience of using third-party IP in the design. 
4. Get familiar with using mostly used VGA interface.  
###Overview:
In this assignment, you will be designing your own hardware to draw lines on the VGA screen.  At 
first glance, you might think that drawing lines is really boring or you might think that it’s not very 
useful for you to learn about. Turns out though, it is one of the most fundamental operations in 
graphics technology.  And because it’s so fundamental, line-drawing (along with line drawing and 
other basic geometric shapes) is often implemented with dedicated hardware. Anytime you look 
at  a  screen with  any  sort  of  rendered  graphics, be  it  your desktop  PC,  smart phone,  smart  TV, 
Xbox, or even futuristic virtual reality technologies like the Oculus Rift or Microsoft HoloLens, you 
will see hardware implemented shape-drawing in action.  
The top-level diagram of your lab is shown below.  The VGA Adapter Core is a component that is 
given to you! This is common practice in industrial design – taking predesigned components that 
are either purchased or written by another group and incorporating them into your own design.   
![image](https://github.com/user-attachments/assets/20fb9f68-db2a-445a-a420-9d1d8d9e939d)

 
**Task 1:  Understand the VGA Adapter Core **   
The VGA Adapter core was created at the University of Toronto for a course similar to ours.  The  
following describes enough for you to use the core; more details can be found on University of 
Toronto’s web page: https://www.eecg.utoronto.ca/~jayar/ece241_07F/vga/         
Some of the following figures have been taken from that website (with permission!).    
In order to save on the limited memory on DE2 board, the VGA Adapter core has been setup to 
display a grid of 160x120 pixels, with the interface shown in Figure 2: 
![image](https://github.com/user-attachments/assets/d66eaac7-a679-4f1c-ac0e-01276bf4ef79)

Inputs: 
![image](https://github.com/user-attachments/assets/fc96da0c-2df5-4d95-9d59-53f448aa62b7)

Outputs: 
Note: You shouldn’t have to worry about the outputs except that they need to be properly 
connected to your top-level ports. 
![image](https://github.com/user-attachments/assets/5e787d81-9ada-4942-806b-c1b7bf4d6650)
 
 
Note that you will connect the outputs of the VGA Adapter core directly to appropriate output 
pins of the FPGA (please see the datasheet for your particular board).  
You  can  picture  the  VGA  screen  as  a  grid  of  pixels  shown  in  Figure  3.  The  X/Y  position  (0,0)  is 
located on the top-left corner and (159,119) pixel located at the bottom-right corner. The role of 
the  VGA  Adapter  core  is  to  continuously  draw  the  same  thing  on  the screen at the monitor’s 
refresh rate, e.g. 60 Hz. To do this, it has an internal memory that stores the colour of each pixel. 
Your circuit will write pixel colours to the VGA Adapter core. 
Figure 3: VGA Adapter core’s display grid 
![image](https://github.com/user-attachments/assets/49dc1b08-39bf-4d7d-b8c2-019a669f55c5)

To set the colour of a pixel, you first drive the VGA Adapter Core’s X, Y and COLOUR inputs with 
the pixels’ x coordinate, y coordinate, and desired color value, respectively. You then raise the 
PLOT input to high.  You must keep these values driven until  the next rising clock edge.  At the 
next rising clock edge, the pixel colour is accepted by the VGA Adapter core’s memory. Then, 
starting on the next screen redraw, the pixel will take on the new colour. In the following timing 
diagram  (from  the  UofT  Website),  two  pixels  are  changed:  one  at  (15,  62)  and  the  other  at 
(109,12).  As you can see, the first pixel drawn is green (rgb = 010) and is placed at (15, 62). The 
second is a yellow pixel at (109, 12).  It is important to note that, at most, one pixel can be changed 
on each cycle.  If you want to change the colour of m pixels, you need m clock cycles. 
![image](https://github.com/user-attachments/assets/556db339-6ac9-46d9-9e1f-299708e1eb41)
Download the  VGA  core  from  UofT  website.  The  Verilog files describing the VGA  Adapter  core 
can be included into Altera Quartus II project.  You shouldn’t be modifying the VGA Adapter Core 
code at all!!!   
In order to understand the VGA Adapter core, create a top level vga_demo.v file. This file does 
nothing but connect the VGA Adapter core I/O to switches on the board so you can experiment.  
It will let you understand how the inputs of the core work.      
This task is not worth any marks, but you should do it to ensure that everything else is working 
(e.g. your VGA Cable is good) before starting the main task below.    
Make  sure  you  include the  Adaptor  Core files  in your  project:  vga_adapter.v,  vga_controller.v, 
vga_address_translator.v and vga_pll.v.  And remember to set up your pin assignments for your 
board.   
**Task 2:  Fill the Screen **
You  will  create  a  new  component  that  interfaces  with  the  VGA  Adaptor  Core.  It  will  contain  a 
simple FSM to fill the screen with colours. This is done by writing to one pixel at a time in the VGA 
Adapter core.  Each row will be set to a different colour (repeating every 8 rows). Since you can 
only set one pixel at a time, you will need a FSM that does something like this: 
Figure 4: Timing Diagram 
Create an FSM that implements the above algorithm. Your design should have an asynchronous 
reset which will be driven by KEY (3).  You don’t need to use KEY (0) or any of the switches in this 
task.  Note that your circuit will be clocked by CLOCK_50.    
Test your design on the DE board.  You need your DE board with a USB cable, a VGA cable, and a 
VGA-capable  display.    Most  new  LCD  displays  have  multiple  inputs,  including  DVI  (digital)  and 
VGA (analog). Note: the VGA connection on your laptop is an OUTPUT, so do not connect your 
laptop’s VGA port to your DE board.    
Hint: Modelsim will be very useful for debugging your component’s outputs. 
 
**Task 3: Bresenham Line Algorithm ** 
The  Bresenham  Line  algorithm  is  a  hardware  (or  software!)  friendly  algorithm  to  draw  lines 
between arbitrary points on the screen.  The basic algorithm is as follows (taken from Wikipedia):  
  ![image](https://github.com/user-attachments/assets/b98959f7-80ca-453c-959e-ebf028143b03)

The algorithm is efficient: it contains no multiplication or division (multiplication by 2 can be 
implemented by a shift-register that shifts right). Because of its simplicity and efficiency, the 
Bresenham Line Algorithm can be found in many software graphics libraries, and in graphics 
chips.  
 
In this task, you will implement a circuit that behaves as follows:  
  
1. The  switch  KEY(3)  is  an asynchronous  reset.   When  the  machine  is  reset,  it  will 
start  clearing the  screen  to black.    Hint:  Task2  is basically  clearing the  screen  if 
you set all pixels to black.  Clearing the screen will take at least 160*120 cycles.    
  
2. Once  the  screen  is  cleared,  your  circuit  will  idle.  At  this  point,  the  user  can  set 
switches  17  downto  3,  which  indicates  a  point  on  the  screen,  and  switches  2 
downto 0, which indicates a colour.  Specifically, SW(17 downto 10) will be used 
to encode the X  coordinate of the point and SW(9 downto 3) will encode the Y 
coordinate of the pixel.  Finally, SW(2 downto 0) will indicate one of 8 possible 
colours used to draw the line. IMPORTANT: Restrict user entered coordinates to 
be within (0,0) to (159, 119). If you don’t you will see some unexpected behavior 
(strange patterns being drawn instead of a line).  For example, if the user set the 
switches to indicate a value of 124 for X coordinate, just clip it to 119.  
  
3. When the user presses KEY(0), the circuit will draw a line. Draw from the centre 
of  the  screen  (location  80,60)  to the  position  specified  by the user.    Of  course, 
this will take multiple cycles; the number of cycles depends on the length of the 
line.  
  
4. Once the line is done, the circuit will go back to step 3, allowing the user to choose 
another point and color.  Do not clear the screen between iterations.  At any time, 
the  user  can  press  KEY(3),  the  asynchronous  reset,  to  go  back  to  the  start  and 
clear  the  screen.    The  reset  signal  on  the  VGA  Core  does  not  clear  the  screen. 
That’s why you need to do it manually in step 1. But this also means that you 
don’t have to do anything special to retain previously drawn lines on the screen.   
  
Note that you are using CLOCK_50, the 50MHz clock, to clock your circuit. You must 
clearly distinguish the datapath from the FSM in your Verilog code (i.e. don’t write one 
giant always block to do everything).  The reason that this is a requirement is that we 
want you to practice manual partitioning of the datapath and FSM for now.    
  
Suggestions and Hints 
Here are some hints and things to think about:    
1. Think  about  how  you  will  partition  your  FSM  and  Datapath  before  you  start  writing  any 
Verilog.    
2. You  may  consider  a  simplified  drawing  algorithm  first  while  you  work  out  your  FSM.    For 
example, when the user presses the “draw” button (KEY[0]), you may consider having your       
design draw some hardcoded pattern onto the screen.  This will let you focus on the FSM and 
screen clearing. Once those parts seem to work, you can replace your hardcoded           pattern 
with the line drawing algorithm. 
3. Be mindful of your variable/signal vector sizes.  Are they sized large enough? For example,   
in the equation “e2 := 2*error”,  “e2” must be 1-bit larger than “error” to not           overflow. 
Not keeping track of signs (read up on the “signed” keyword in verilog) and sign bits can also 
cause overflow. Overflow can be a pain to debug unless you know to look for it. 
 
**Challenge Circuit: (10 mark) **
Challenge tasks are tasks that you should only perform if you have extra time, are keen, and 
want to show off a little bit.  This challenge task is only worth 10 marks.  If you don’t demo the 
challenge task, the maximum score you can get on this assignment is 90/100 (which is still an 
A+). 
This challenge task is actually fairly easy:  
A. In  the  original  circuit,  you  always  connect  the  centre  of  the  screen  (80,60)  to  the 
point specified by the user.  Modify your circuit such that, instead of starting from 
the centre, it starts from the point specified by the user in the previous iteration.  So 
for the first iteration, if the user specifies point (x0, y0), a line is drawn from the middle 
of  the  screen  to  (x0,  y0).    Then,  in  the  second  iteration,  if  the  user  specifies  point 
(x1,y1), a line is drawn from (x0,y0) to (x1,y1).  In iteration i, a line is drawn from point  
(x i-1,y i-1) to (x i,y i).   
  
B. (optional)  Rather  than  taking  the  point  from  the  switches,  choose  each  point  and 
colour  pseudorandomly  (using  a  Linear  Feedback  Shift  Register).    Draw  the  lines 
quickly  without  waiting  for  KEY(0)  between  lines.    Note  that  you  will  have  to  add 
some delay, or the screen will fill up too quickly for you to see.  
