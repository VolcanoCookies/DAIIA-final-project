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
	House crash;

	state idle initial: true {
		
		enter {
			arrest <- nil;
			crash <- nil;
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
					do log("Going to arrest X", [arrest]);
				}
				match CRASH_PARTY {
					crash <- House(read_agent(i, 1));
					do log("Going to crash party at X", [crash]);
				}
			}
		}
		
		transition to: detain when: arrest != nil;
		transition to: crash when: crash != nil;
		
	}
	
	state detain {
		
		enter {
			target <- arrest;
		}
		
		transition to: escort when: at_target();
		
	}
	
	state crash {
		
		enter {
			target <- crash;
		}
		
		transition to: idle when: at_target() {
			ask crash {
				if state = "hold_party" {
					state_cycle <- 99999999;
					loop g over: guests {
						ask g {
							do happy(-5.0);
						}
					}
				}
			}
		}
		
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

