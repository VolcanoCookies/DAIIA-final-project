/**
* Name: Neighbourhood
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/


model Neighbourhood

import "House.gaml"

global {
	
	
	init {
		
		create House number: 8;
		
	}
	
}

experiment Neighbourhood {
	
	output {
		
		display Neighbourhood type: opengl background: #white {
			
			// Draw houses
			species House aspect: floor transparency: 0.5;
			species House aspect: plot transparency: 0.3;
		
		}
		
	}
	
}