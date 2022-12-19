# Grand-Prix-Car-Racing-Game
Grand Prix Car Racing Game made in assembly language intel 8086
In COAL term project, you will be creating the Qulifying round of the “Grand Prix Circuit” game, which is developed by Distinctive Software in 1988. The objective of the game is car racing and players can choose from multiple cars and circuits.

See play through of the game in this video tutorial:

https://www.youtube.com/watch?v=fysoXmhtWy0

Important Note: You will be working in group of 2 for developing this project. However, along with team evaluation each member will be evaluated individually as well.

Phase I – User Interface

You will only implement qualifying round of the game for any track of your choice. In the first phase of the project, you will be implementing the user interface of the game as given in figure below. You can also add new features in the user interface as well to enhance the user experience.

Phase II - Movement

In the second phase of the project, you are required to design graphics once the car is moving on the track. You may consider a simple track for this phase (i.e., square or rectangle), and you have to constantly update the background, and steering using the string instructions. A timer is required to constantly update the background, and you may use the Ex. 9.7 from the textbook for this purpose. You are required to write a subroutine that constantly changes the background, and copy its code in place of printnum subroutine in Ex. 9.7. Furthermore, please clearly list any assumptions that you may make to implement this phase. However, to implement this phase, you CANNOT use BIOS services.

Phase III – Control movement of vehicle using arrow keys

In the third phase of the project, you are required to control the movement of the vehicle using the arrow keys as described below:

(1)	The car should move in a straight line if the top arrow key is pressed.

(2)	The car should be able to turn right/left if right/left arrow key is pressed.

(3)	If the down key is pressed, then the car should stop.

You may consider a simple track for this phase (i.e., square or rectangle), and you have to constantly update the background, and steering using the code that was developed in Phase-II. 
As shown in the figure below, on top left corner, there should be a map that shows the current location of the vehicle on the track. 
If the vehicle goes out of track, then it would stop. However, you have to bring it back on the track for restarting the race.

Furthermore, please clearly list any assumptions that you may make to implement this phase.
![image](https://user-images.githubusercontent.com/89494835/208426511-87917f06-b5b5-4c44-bfe9-9c08fddc34e2.png)
Phase IV

In the final phase of the project, you are required to implement a timer that records the time taken to complete the lap in Phase III. The timer should be displayed on the top right corner of the screen.

Furthermore, after the qualifying round is finished, you have to display the Qualifying Result Sheet as follows:

Please clearly list down any assumptions that you may make to implement this phase.

![image](https://user-images.githubusercontent.com/89494835/208426896-1c3bf344-866a-4af7-a1bc-14a5785a3f93.png)


