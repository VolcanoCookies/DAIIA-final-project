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
import "Phrases.gaml"
import "Cop.gaml"

import "Neighbourhood.gaml"

global {
	
	float SIZE const: true <- 10.0;
	
	init {
		create Station;
	}
	
}

species Station skills: [fipa] parent: Base control: fsm {
	
	init {
		location <- {20.0, 80.0};
		shape <- rectangle({10.0, 10.0});
	}
	
	list to_detain <- [];
	list to_crash <- [];
	map<agent, int> arrested <- [];
	
	reflex when: !empty(arrested) {
		loop prisoner over: arrested.keys {
			int release <- arrested[prisoner];
			if release < cycle {
				do log("Releasing prisoner X", [prisoner]);
				remove key: prisoner from: arrested;
				if prisoner is Student {
					ask prisoner as Student {
						detained <- false;
					}
				} else if prisoner is Thief {
					
				}
			} else if self distance_to prisoner > 2.0 {
				prisoner.location <- location;
			}
		}
	}
	
	state idle initial: true {
		
		loop i over: informs {
			switch read(i) {
				match UNDERAGE_BUYING {
					Student target <- Student(read_agent(i, 1));
					add target to: to_detain;
				}
				match LOUD_PARTY {
					House target <- House(read_agent(i, 1));
					add target to: to_crash;
				}
			}
		}

		transition to: detain when: !empty(to_detain);
		transition to: crash when: !empty(to_crash);

	}
	
	state detain {
		
		enter {
			Student target <- to_detain[0];
			remove index: 0 from: to_detain;
		
			do log("Requesting to detain X", [target]);
		
			do start_conversation to: list(Cop) performative: "inform" protocol: "no-protocol" contents: [DISTANCE_TO, target.id];
			
			Cop closest;
		}
		
		if state_cycle = 5 {
			
			int closest_distance;
			
			loop i over: informs {
				if read(i) = DISTANCE_TO {
					int distance <- int(read(i, 1));
					if closest = nil {
						if distance >= 0 {
							closest <- i.sender;
							closest_distance <- distance;
						}
					} else if distance < closest_distance {
						closest <- i.sender;
						closest_distance <- distance;
					}
				}
			}
			
			if closest != nil {
				do log("Requesting X to detain X", [closest, target]);
				do start_conversation to: list(closest) performative: "inform" protocol: "no-protocol" contents: [DETAIN, target.id];
			}
			
		}
		
		transition to: idle when: state_cycle > 5;
		
	}
	
	state crash {
		
		enter {
			House target <- to_crash[0];
			remove index: 0 from: to_crash;
		
			do log("Requesting to crash party at X", [target]);
		
			do start_conversation to: list(Cop) performative: "inform" protocol: "no-protocol" contents: [DISTANCE_TO, target.id];
			
			Cop closest;
		}
		
		if state_cycle = 5 {
			
			int closest_distance;
			
			loop i over: informs {
				if read(i) = DISTANCE_TO {
					int distance <- int(read(i, 1));
					if closest = nil {
						if distance >= 0 {
							closest <- i.sender;
							closest_distance <- distance;
						}
					} else if distance < closest_distance {
						closest <- i.sender;
						closest_distance <- distance;
					}
				}
			}
			
			if closest != nil {
				do log("Requesting X to crash party at X", [closest, target]);
				do start_conversation to: list(closest) performative: "inform" protocol: "no-protocol" contents: [CRASH_PARTY, target.id];
			}
			
		}
		
		transition to: idle when: state_cycle > 5;
		
	}
	
	aspect debug {
		if enable_debugging and debug {
			draw "Prisoners: " + length(arrested) color: #black;
		}
	}
	
	aspect floor {
		
		draw shape color: #red;
		
	}
	
}