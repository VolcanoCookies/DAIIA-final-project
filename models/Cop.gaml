/**
* Name: Student
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/


model Cop

import "House.gaml"
import "Thief.gaml"
import "Human.gaml"

species Cop skills: [moving] control: fsm parent: Human {
	
	Student arrest;

	state idle initial: true {
		
		enter {
			arrest <- nil;
			target <- nil;
			do clear_mail();
		}
		
		do wander;
		
		loop i over: informs {
			switch(read(i)) {
				match DISTANCE_TO {
					agent target_d <- read_agent(i, 1);
					do inform message: i contents: [DISTANCE_TO, self distance_to target_d];
				}
				match DETAIN {
					arrest <- Student(read_agent(i, 1));
				}
			}
		}
		
		transition to: detain when: arrest != nil;
		
	}
	
	state detain {
		
		enter {
			target <- arrest;
		}
		
		transition to: escort when: at_target();
		
	}
	
	state escort {
		
		enter {
			target <- any(Station).location;
		}
		
		arrest.location <- location;
		
		transition to: idle when: at_target() {
			ask target as Station {
				add 200 + cycle to: arrested at: myself.arrest;
			}
		}
		
	}
	
	aspect base {
		
		draw square(1.0) color: #darkblue;
		
	}

}

