/**
* Name: House
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/


model Store

import "Student.gaml"
import "Thief.gaml"
import "Base.gaml"

import "Neighbourhood.gaml"

global {
	
	float SIZE const: true <- 10.0;
	
	init {
		create Store;
	}
	
}

species Station skills: [fipa] parent: Base {
	
	init {
			
		location <- {80.0, 80.0};
		shape <- rectangle({10.0, 10.0});
		
	}
	
	aspect debug {
		if enable_debugging and debug {
			
			draw "Prisoners: " + length((Student + Thief) inside shape) color: #black;
						
		}
	}
	
	aspect floor {
		
		draw shape color: #blue;
		
	}
	
}