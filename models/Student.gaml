/**
* Name: Student
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/

model Student

import "House.gaml"
import "Human.gaml"

species Student skills: [moving] control: fsm parent: Human {
	
	// Parameters
	float speed <- 4.0#km/#h;
	House party;
	int age <- rnd(15, 25);
	float likeability <- rnd(0.0, 1.0);
	
	float rotation <- 0.0;
	float intoxication <- 0.0;
	
	bool at_party {
		return party != nil and self intersects party;
	}
	
	state idle initial: true {
		
		loop i over: informs {
			if read(i) = "party starting" {
				party <- House(i.sender);
			}
		}
		
		bool buy_alcohol <- flip(0.5);
		
		transition to: buy_alcohol when: buy_alcohol and party != nil;
		transition to: attend_party when: !buy_alcohol and party != nil;
		
	}
	
	state buy_alcohol {
		
	}
	
	state attend_party {
		
		
		transition to: party when: at_party();
		
	}
	
	state party {
		
	}

	
	
	reflex when: intoxication > 0 {
		do wander speed: min(intoxication, 1.0);
	}
	
	aspect base {
		
		draw square(1.0) rotate: rotation color: #purple;
		
	}
	
}

