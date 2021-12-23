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
	bool party_ending <- false;

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
			do release();
			rotation <- 0.0;
			target <- nil;
			party <- nil;
			party_ending <- false;
			House party_invite;
		}
		
		loop i over: informs {
			if party_invite = nil {
				if read(i) = PARTY_INVITE {
					party_invite <- House(i.sender);
					do inform message: i contents: [ATTENDING];
					do happy(0.25);
					
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
		transition to: idle when: party_ending;
		transition to: arrested when: detained;

	}
	
	state arrested {
		
		enter {
			speed <- 0.0;
			do happy d: -5.0;
		}
		
		transition to: idle when: !detained;
		
		exit {
			speed <- 4.0#km/#h;
		}
		
	}
	
	state attend_party {
		
		enter {
			target <- party;
			do confine(roads + party.plot);
		}
		
		transition to: idle when: party_ending;
		transition to: party when: at_target() {
			ask party {
				add myself to: guests;
			}
		}
		
	}
	
	Student talking_to;
	
	state party {
		
		enter {
			do confine(party.plot);
			
			ask party {
				alcohol <- alcohol + myself.alcohol;
				myself.alcohol <- 0;
			}
		
			talking_to <- nil;
		
			do happy(1.0);
		}
		
		rotation <- rotation + 10;
		do wander speed: 0.25 bounds: party.shape + party.plot;
		
		do happy(0.01);
		
		if flip(0.01) {
			ask party {
				if alcohol > 0 {
					myself.intoxication <- myself.intoxication + 1;
					alcohol <- alcohol - 1;
				}
			}
		}
		
		if flip(0.02) {
			Student g <- any((party.guests - self) at_distance 7.5);
			
			if g != nil and g.state = "party" and g.talking_to = nil {
				g.talking_to <- self;
				talking_to <- g;
			}
		}
		
		transition to: talking when: talking_to != nil;

		transition to: idle when: party_ending or party.state != "hold_party";
		
	}
	
	state talking {
		
		enter {
			target <- talking_to;
		
			do log("Talking to X", [talking_to]);
		
			float opinion <- 0.0;
			float mod <- perceive(talking_to);
		}
		
		if state_cycle mod 2 = 0 {
			if rnd(0.0, 1.0) * mod > 0.5 {
				opinion <- opinion + 0.1;
			} else {
				opinion <- opinion - 0.1;
			}
		}
		
		exit {
			do change_bias(talking_to, opinion);
			
			if opinion > 0 {
				do happy(0.25);
			} else {
				do happy(-0.25);
			}
			
			target <- nil;
			talking_to <- nil;
		}
		
		transition to: party when: talking_to = nil or state_cycle > 20;
		
	}

	reflex when: intoxication > 0 {
		do wander speed: min(intoxication, 1.0);
	}
	
	aspect debug {
		if enable_debugging and debug {
			if talking_to != nil {
				draw self link talking_to color: #red;
			}
			if party != nil {
				draw self link party color: #blue;
			}
		}
	}
	
	aspect base {
		
		draw square(1.0) rotate: rotation color: #purple;
		
	}
	
}

