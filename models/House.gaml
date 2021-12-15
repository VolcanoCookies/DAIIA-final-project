/**
* Name: House
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/


model House

import "Student.gaml"
import "Base.gaml"

import "Neighbourhood.gaml"

global {
	
	list<point> locations <- [
		{10, 20},
		{30, 20},
		{70, 20},
		{90, 20},
		{10, 50},
		{30, 50},
		{70, 50},
		{90, 50}
	] const: true;
	float SIZE const: true <- 8.0;
	
	init {
		create House number: 8;
	}
	
}

species House skills: [fipa] parent: Base control: fsm {
	
	init {
		
		int index <- House index_of self;
		int row <- index mod 2;
			
		//location <- {SIZE * 1.2 * (index - row + 1), 35.0 + 30.0 * row};
		location <- locations at index;
		
		shape <- rectangle({SIZE * 1.5, SIZE});
		plot <- shape transformed_by {0.0, 1.5};
		
		neighbours <- [];
		
		if index > 1 {
			add House[index - 2] to: neighbours;
		}
		
		if index < 6 {
			add House[index + 2] to: neighbours;
		}
		
		if row = 0 {
			add House[index + 1] to: neighbours;
		} else {
			add House[index - 1] to: neighbours;
		}
		
	}
	
	int alcohol <- 0;
	
	list<House> neighbours;
	
	geometry plot;
	list<Student> trouble_makers <- [];
	
	list<Student> attendees;
	
	int party_cooldown <- rnd(25, 250) min: 0 update: party_cooldown - 1;
	
	state idle initial: true {
		
		enter {
			color <- rgb(0, 255, 0);
		}
		
		transition to: start_party when: party_cooldown = 0 and flip(0.01);
		
	}
	
	state start_party {
		
		enter {
			color <- rgb(50, 255, 0);
			
			float leniancy <- rnd(0.0, 1.0);
			list<Student> invite_list <- (list(Student) - trouble_makers) where (each.likeability > leniancy);
		
			attendees <- [];
			
			alcohol <- rnd(0, 10);
			
			if !empty(invite_list) {
				do start_conversation to: invite_list performative: "inform" protocol: "no-protocol"  contents: ["party starting"];
			}
		}
		
		loop i over: informs {
			
			Student s <- Student(i.sender);
			if invite_list contains s {
				add s to: attendees;
			}
			
		}
		
		transition to: idle when: empty(invite_list) {
			party_cooldown <- 200;
		}
		
		transition to: hold_party when: state_cycle > 15;
		
	}
	
	state hold_party {
		
		enter {
			color <- rgb(150, 255, 0);
		}
		
		transition to: end_party when: state_cycle > 500;
		
	}
	
	state end_party {
		
		enter {
			color <- rgb(100, 100, 100);
		}
		
		transition to: idle when: state_cycle > 15 {
			party_cooldown <- 500;
		}
		
	}
	
	aspect debug {
		if enable_debugging and debug {
			
			loop n over: neighbours {
				draw self link n color: #red;
			}
			
			draw string("Cooldown: " + party_cooldown) color: #black;
						
		}
	}
	
	aspect floor {
		
		draw shape color: #red;
		
	}
	
	aspect plot {
	
		draw plot color: #green;
		
	}
	
}