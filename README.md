# Detecting Seismicity - EEE Final Year Project 2022

Welcome to my repository for my FYP, written in MATLAB. For my FYP, I have developed a program that is able to give an estimation of where a seismic activity such as an explosion has come from, using a single station's data. This program, uses IRIS data which is unfortunately not live, however if we assume the program to be running at the station itself, perhaps it would be possible to act as a real time source. The program, once it detects an 'extraordinary' seismic activity, anything outside usual activity during the day,  will trigger an email/text message alert.

This project was quite interesting to work on, and I learnt a lot about how seismic data can be manipulated into early warning systems. An interesting application from my application could be as an early warning system for IED bombings, in this version it is emailing a plot to those interested the estimated position of the event on a map, however it could be further extended to directly SMS emergency services.


## Requirements
- A computer with sufficient processing power to run the MATLAB code, more in the requirements section of the final report.
- The development was done on MATLAB 2021, so at least this version is recommended.
- Internet connection to access the IRIS data.

## Running scenarios
- In the folder "scenarios", there are a few scenarios to demonstrate the code working on different seismic events.
- Some are terrorist bombings (IEDs), and some are accidental explosions.


## Running on a custom scenario
- Should you wish to run your own scenario, it is recommended you follow the instructions in the corresponding final report for this project (see "Running problem section")





## Instructions on how to run.
- It is simple enough to run the custom scenarios, simply run the MATLAB editor, they should work immediately. 



## Repository structure
The code is organised as such:
- Custom scenarios - the file in there can be changed to what the user desires according to the user guide.
- Set scenarios - just run them as they are already parameterised.
