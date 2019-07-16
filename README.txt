# Station-Design-Toolbox

This repository contains code to plan a coastal monitoring station, coastal drone data collection, and create synthetic time series of the sea surface, imagery, and pixel instrument data.

The StationDesignGUI folder contains an application for planning data collection from cameras mounted on a fixed platform or small unoccupied aircraft system. A GUI simplifies the process of designing the data collection by providing estimates of the camera array field-of view and image resolution based on the hypothetical projection matrix from user-defined camera configurations. The user can save results as geographically tagged images and KML files for import into an earth browser. 

The SyntheticOpticalWaveField folder contains code that can generate a synthetic time series of sea surface elevation and build synthetic images with the simulated reflected radiance based on a wave frequency-direction input spectrum. The synthetic procedure can be applied to design
future fixed camera coastal video monitoring stations or to develop
sampling schemes for small Unmanned Aerial Systems (sUAS).