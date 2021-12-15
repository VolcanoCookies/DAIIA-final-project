/**
* Name: Student
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/

/*
model Student

import "House.gaml"
import "Human.gaml"

species Student skills: [moving] control: simple_bdi parent: Human {
	
	init {
		do add_desire(party_invite);
	}
	
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
	
	predicate party_invite <- new_predicate("party invite");
	predicate party_attend <- new_predicate("party attend");
	predicate party_end <- new_predicate("party end");
	
	predicate alcohol <- new_predicate("alcohol");
	
	predicate do_stuff <- new_predicate("do stuff");
	
	predicate dance <- new_predicate("dance");
	predicate drink <- new_predicate("drink");
	predicate flirt <- new_predicate("flirt");
	
	reflex read_messages when: !empty(informs) and has_desire(party_invite) {
		loop i over: informs {
			if read(i) = "party starting" {
				party <- House(i.sender);
				do add_belief(party_invite);
			}
		}
	}
	
	// Attend party
	law belief: party_invite new_obligation: party_attend threshold: 0.7;
	// Go to a party
	norm obligation: party_attend finished_when: has_belief(party_attend) threshold: 0.7 {
		do goto target: party;
	}
	
	// When at party
	rule new_belief: party_attend when: at_party();
	
	// Decide what to do
	reflex when: has_desire(do_stuff) and flip(0.1) {
		do add_obligation(any([dance, drink, flirt]));
		do remove_desire(do_stuff);	
	}
	
	// Dance at a party
	norm obligation: dance finished_when: flip(0.01) {
		rotation <- rotation + 1.0;
	}
	
	// Drink at a party
	norm obligation: drink {
		if party.alcohol = 0 {
			do change_liking(party, -0.1);
		} else {
			intoxication <- intoxication + 0.1;
		}
		do remove_obligation(drink);
	}
	
	// Flirt at a party
	norm obligation: flirt {
		do remove_obligation(flirt);
	}
	
	reflex when: intoxication > 0 {
		do wander speed: min(intoxication, 1.0);
	}
	
	aspect base {
		
		draw square(1.0) rotate: rotation color: #purple;
		
	}
	
}*/