/**
* Name: House
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/


model Store

import "Student.gaml"
import "Station.gaml"
import "Base.gaml"
import "Phrases.gaml"

import "Neighbourhood.gaml"

global {
	
	float SIZE const: true <- 10.0;
	int LEGAL_AGE <- 18 const: true;
	
	init {
		create Store;
	}
	
}

species Store skills: [fipa] parent: Base {
	
	init {
			
		location <- {80.0, 80.0};
		shape <- rectangle({10.0, 10.0});
		
	}
		
	action buy_alcohol(Student student) {
		
		if student.traits.age >= LEGAL_AGE or flip(0.5 * student.traits.charisma) {
			ask student {
				alcohol <- rnd(1, 5);
			}
		} else {
			do start_conversation to: list(Station) performative: "inform" protocol: "no-protocol" contents: [UNDERAGE_BUYING, student.id];		
			
			do log("Detained student X", [student]);
			
			ask student {
				detained <- true;
			}
			
			return 0;
		}
		
	}
	
	aspect debug {
		if enable_debugging and debug {
			
			draw "Guests: " + length(Human inside shape) color: #black;
						
		}
	}
	
	aspect floor {
		
		draw shape color: #blue;
		
	}
	
}