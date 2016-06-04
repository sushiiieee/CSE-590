# CSE-590

This project is to design a circuit that will input 4 numbers on the FPGA board, sort and display the sorted numbers by decimal. In order to proceed with the project, I performed three modules in order to implement the main objectives of the project: Input the numbers onto the board, sort the numbers, display the simulated output.
In order to input the numbers on to the board, the basic initializations were made for inputs and outputs, partA was used to determine the index of the position where to store the values that are to be sorted. The numbers are being stored in the index provided by partA provided when the button partC is high. Now, when this button is high the numbers are stored and are ready for being sorted.
To perform the sorting, bubble sort was used however the numbers are sorted provided the partD is high. This means when the button is high the numbers get sorted. To perform bubble sort, for loop came into play. These sorted numbers are stored in order to display the sorted numbers at partE.
All of these modules are however being called in the main module. Thus, these modules are invoked and we obtain the results.
