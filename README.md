
# Smartfin - filter_derived_heave

## Introduction

As climate change becomes a growing crisis in our society, oceanography is a powerful tool to study its effects and their predicted impacts. Currently, satellites and off-shore buoys are used to study many parameters of the ocean including; sea surface temperature, salinity, ocean currents, and wave statistics. This data allows scientists to study ocean currents and nutrient flow which helps determine how ecosystems are coping with changes. However, these two methods are unable to collect this crucial data close to the shore in what’s known as the surf zone as the seafloor is too shallow and conditions are too rough to accommodate either system.

Searching for a solution to this problem, the Surfrider Foundation has partnered with the Scripps Institution of Oceanography to develop a solution called Smartfin that would allow surfers to passively collect this crucial data while they are in the water. The Smartfin hardware has been developed with many sensors designed to measure temperature, location, and wave characteristics, with more currently in development to study pH, dissolved oxygen, and chlorophyll. Preliminary testing of the Smartfin has shown its potential, as shown below temperature data from the board was compared to standard data collected from a near offshore buoy run by Scripps. As many beaches do not have this capability, providing this tool to surfers in select locations will give ordinary citizens the power to make powerful scientific observations, all while catching waves.

Seen below, in images provided by [surfrider.org](https://www.surfrider.org) is an early model of the Smartfin attached to a surfboard. This clear fin shows the battery, GPS, temperature sensor, and IMU (inertial measurement unit). The fin is still going through an iterative design process as more hardware is added to increase its capabilities. As seen on the photo to its right.

<p float="left">
  <img src="/assets/SF_seeThrough_fullres-1074x747.jpg" width="45%">
  <img src="/assets/SF_handFin_fullres.jpg" width="45%">
</p>

## Wave Height Analysis

This repo uses a Kalman filter to estimate the orientation of the fin.  It then applies the orientation to the measured acceleration, transforming it from the sensor body frame to the world frame.  With the acceleration in the world frame, we can use double integration on the Z component to calculate first the velocity, then the position.

This approach causes amplification of the bias in the accelerometer readings.  Therefore, small errros in acceleration can become large errors in position.

## Future Work

In order to resolve the aforementioned issue with double integration, it would be ideal to extend our Kalman filter with the ability to estimate position as well as orientation.  To do so would allow us to account for the bias and potentially correct it.
