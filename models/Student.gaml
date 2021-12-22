/**
* Name: Student
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/

model Student

import "House.gaml"
import "Human.gaml"
import "Traits.gaml"

import "Neighbourhood.gaml"



species Student skills: [moving] control: fsm parent: Human {
	
	init {
		create Traits returns: p;
		traits <- p[0];
	}
	
	// Parameters
	float speed <- 4.0#km/#h;
	House party;

	float intoxication <- 0.0 min: 0.0 update: intoxication - 0.05;
	
	Traits traits;
	
	map<Student, float> bias <- [];

	float perceive(Student student) {
		float opinion <- traits.perceive(student.traits);
		
		if bias[student] != nil {
			opinion <- opinion * bias[student];
		}
		return opinion;
	}

	action change_bias(Student student, float delta) {
		float prev <- 0.0;
		if bias[student] != nil {
			prev <- bias[student];
		}
		bias[student] <- prev + delta;
	}

	float rotation <- 0.0;
	
	bool detained <- false;
	int alcohol <- 0;
	
	list friends;
	
	float happiness <- 0.0;
	
	action happy(float d) {
		happiness <- happiness + d;
	}
	
	reflex when: friends = nil {
		friends <- [];
		int n <- rnd(1, 10) * likeability * 2.0;
		loop times: n {
			add any(Student) to: friends;
		}
	}
	
	bool at_party {
		return party != nil and self intersects party;
	}
	
	state idle initial: true {
		
		enter {
			House party_invite;
		}
		
		loop i over: informs {
			if party_invite = nil {
				if read(i) = PARTY_INVITE {
					party_invite <- House(i.sender);
					do inform message: i contents: [ATTENDING];
					do log("Got invite to party at X", [House]);
				}
			} else {
				if read(i) = PARTY_STARTING {
					do log("Party at X starting", [party_invite]);
					party <- party_invite;
				} else if read(i) = PARTY_CANCELLED {
					do log("Party at X cancelled", [party_invite]);
					party_invite <- nil;
				}
			}
		}
		
		if !(location intersects roads) {
			do goto target: roads;
		} else {
			do wander bounds: roads;
		}
		
		bool buy_alcohol <- flip(0.5);
		
		transition to: buy_alcohol when: buy_alcohol and party != nil;
		transition to: attend_party when: !buy_alcohol and party != nil;
		
	}
	
	state buy_alcohol {
		
		enter {
			do log("Buying alcohol");
			
			Store store <- any(Store);
			do set_target(store, roads + store.shape);
		}
		
		if at_target() {
			ask store {
				do buy_alcohol(myself);
			}
		}
		
		transition to: attend_party when: alcohol > 0;
		transition to: arrested when: detained;

	}
	
	state arrested {
		
		enter {
			speed <- 0.0;
			do happy d: -0.5;
		}
		
		transition to: idle when: !detained;
		
		exit {
			speed <- 4.0#km/#h;
		}
		
	}
	
	state attend_party {
		
		enter {
			do set_target(party, roads + party.shape + party.plot);
		}
		
		transition to: party when: at_target();
		
	}
	
	state party {
		
		enter {
			ask party {
				alcohol <- alcohol + myself.alcohol;
				myself.alcohol <- 0;
			}
		
			do happy d: 0.35;
		}
		
		rotation <- rotation + 10;
		do wander speed: 0.25 bounds: party.shape + party.plot;
		
		if flip(0.01) {
			ask party {
				if alcohol > 0 {
					myself.intoxication <- myself.intoxication + 1;
					alcohol <- alcohol - 1;
				}
			}
		}
		
	}

	
	
	reflex when: intoxication > 0 {
		do wander speed: min(intoxication, 1.0);
	}
	
	aspect base {
		
		draw square(1.0) rotate: rotation color: #purple;
		
	}
	
}

