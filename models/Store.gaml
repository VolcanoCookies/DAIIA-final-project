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

import "Neighbourhood.gaml"

global {
	
	float SIZE const: true <- 10.0;
	int legal_age <- 18 const: true;
	
	init {
		create Store;
	}
	
}

species Store skills: [fipa] parent: Base {
	
	init {
			
		location <- {80.0, 80.0};
		shape <- rectangle({10.0, 10.0});
		
	}
	
	list<Student> held <- [];
	
	action buy_alcohol(Student student) {
		
		if student.age >= legal_age or flip(0.1) {
			ask student {
				do add_belief(alcohol);
			}
		} else {
			do start_conversation to: list(Station) performative: "inform" protocol: "no-protocol" contents: ["underage buying alcohol", student.id];		
			add student to: held;
			
			ask student {
				//do add_obligation(arrested); 
			}
			
		}
		
	}
	
	aspect debug {
		if enable_debugging and debug {
			
			draw "Guests: " + length(Human inside shape) color: #black;
						
		}
	}
	
	aspect floor {
		
		draw shape color: #red;
		
	}
	
}