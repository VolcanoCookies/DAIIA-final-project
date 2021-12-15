/**
* Name: Neighbourhood
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/


model Neighbourhood

import "House.gaml"
import "Store.gaml"
import "Student.gaml"

global {
	
	bool enable_debugging <- false;
	
	init {
		
		create Student number: 5;
		
	}
	
}

experiment Neighbourhood {
	
	parameter "Enable Debugging" var: enable_debugging;
	
	output {
		
		display Neighbourhood type: opengl background: #white {
				
			// Draw houses
			species House aspect: debug;
			species House aspect: floor transparency: 0.5;
			species House aspect: plot transparency: 0.3;
			
			species Store aspect: debug;
			species Store aspect: floor;
			
			species Student aspect: base;
		
		}
		
	}
	
}