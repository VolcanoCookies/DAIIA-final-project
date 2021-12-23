/**
* Name: House
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/


model House

import "Student.gaml"
import "Base.gaml"
import "Traits.gaml"
import "Phrases.gaml"

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
	
}

species House skills: [fipa] parent: Base control: fsm {
	
	init {
		
		int index <- House index_of self;
		int row <- index div 4;
			
		//location <- {SIZE * 1.2 * (index - row + 1), 35.0 + 30.0 * row};
		location <- locations at index;
		
		shape <- rectangle({SIZE * 1.5, SIZE});
		plot <- shape transformed_by {0.0, 1.5};
		
		neighbours <- [];
		
		if index > 0 and index != 4 {
			add House[index - 1] to: neighbours;
		}
		
		if index < 7 and index != 3 {
			add House[index + 1] to: neighbours;
		}
		
		if row = 0 {
			add House[index + 4] to: neighbours;
		} else {
			add House[index - 4] to: neighbours;
		}
	
		capacity <- rnd(10, 50);
	
		create Traits returns: p;
		preferences <- p[0];
		
	}
	
	int capacity;
	int alcohol <- 0;
	
	Traits preferences;
	
	list<House> neighbours;
	
	geometry plot;
	list<Student> trouble_makers <- [];
	
	list<Student> attendees;
	list<Student> guests;
	
	int party_cooldown <- rnd(25, 250) min: 0 update: party_cooldown - 1;
	
	state idle initial: true {
		
		enter {
			color <- rgb(0, 255, 0);
			
			attendees <- [];
			guests <- [];
		}
		
		loop n over: neighbours {
			if n.state = "hold_party" and flip(0.001) {
				do start_conversation to: list(Station) performative: "inform" protocol: "no-protocol" contents: [LOUD_PARTY, n.id];
			}
		}
		
		transition to: start_party when: party_cooldown = 0 and flip(0.01);
		
	}
	
	state start_party {
		
		enter {
			color <- rgb(50, 255, 0);
			
			float leniancy <- rnd(0.0, 1.0);
			list<Student> invite_list <- (list(Student) - trouble_makers) where (preferences.perceive(each.traits) > leniancy);
			
			if length(invite_list) > capacity {
				invite_list <- copy_between(invite_list, 0, capacity - 1);
			}
			
			alcohol <- rnd(0, 10);
			
			if !empty(invite_list) {
				do log("Inviting X students to a party", [length(invite_list)]);
				do start_conversation to: invite_list performative: "inform" protocol: "no-protocol" contents: [PARTY_INVITE];
			}
		}
		
		loop i over: informs {
			Student s <- Student(i.sender);
			if invite_list contains s and read(i) = ATTENDING {
				add s to: attendees;
			}
		}
		
		transition to: idle when: empty(invite_list) or state_cycle > 20 {
			if !empty(attendees) {
				do start_conversation to: attendees performative: "inform" protocol: "no-protocol" contents: [PARTY_CANCELLED];
			}
			party_cooldown <- 200;
		}
		
		// Only start a party if at least 30% of invited students said they will attend
		transition to: hold_party when: state_cycle > 15 and length(attendees) > length(invite_list) * 0.3 {
			do start_conversation to: attendees performative: "inform" protocol: "no-protocol" contents: [PARTY_STARTING];
		}
		
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
		
		loop g over: guests {
			ask g {
				if party = myself {
					party_ending <- true;
				}
			}
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
			draw string("Alcohol: " + alcohol) color: #black at: location - {0, 1};
			draw string("Capacity: " + capacity) color: #black at: location - {0, 2};
			draw string("Attendees: " + length(Student inside plot)) color: #black at: location - {0, 3};
				
		}
	}
	
	aspect floor {
		
		draw shape color: #green;
		
	}
	
	aspect plot {
	
		draw (plot - shape) color: #darkgreen;
		
	}
	
}