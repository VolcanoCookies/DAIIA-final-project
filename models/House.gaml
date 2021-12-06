/**
* Name: House
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/


model House

import "Student.gaml"
import "Base.gaml"

global {
	
	float SIZE const: true <- 10.0;
	
}

species House skills: [fipa] parent: Base control: fsm {
	
	init {
		
		int index <- House index_of self;
		int row <- index mod 2;
			
		location <- {SIZE * 1.2 * (index - row + 1), 35.0 + 30.0 * row};
		
		shape <- rectangle({SIZE * 1.5, SIZE});
		plot <- shape transformed_by {0.0, 1.5};
		
	}
	
	geometry plot;
	list<Student> trouble_makers <- [];
	
	list<Student> attendees;
	
	state idle initial: true {
		
		transition to: start_party when: flip(0.01);
		
	}
	
	state start_party {
		
		enter {
			float leniancy <- rnd(0.0, 1.0);
			list<Student> invite_list <- (list(Student) - trouble_makers) where (each.likeability > leniancy);
		
			attendees <- [];
		
			do start_conversation to: invite_list performative: "inform" protocol: "no-protocol"  contents: ["party starting, "];
		}
		
		loop i over: informs {
			
			Student s <- Student(i.sender);
			if invite_list contains s {
				add s to: attendees;
			}
			
		}
		
		transition to: hold_party
		
	}
	
	
	
	aspect floor {
		
		draw shape color: #red;
		
	}
	
	aspect plot {
	
		draw plot color: #green;
		
	}
	
}