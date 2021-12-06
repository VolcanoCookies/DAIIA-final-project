/**
* Name: Student
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/


model Student

import "House.gaml"
import "Human.gaml"

species Student skills: [moving] control: simple_bdi parent: Human {
	
	init {
		do add_desire(want_party);
	}
	
	float speed <- 1.0#km/#h;
	House party;
	float likeability <- rnd(0.0, 1.0);
	
	predicate want_party <- new_predicate("want party");
	predicate want_alcohol <- new_predicate("want alcohol");
	predicate buy_alcohol <- new_predicate("buy alcohol");
	predicate is_dancing <- new_predicate("is dancing");
	
	
	
}

