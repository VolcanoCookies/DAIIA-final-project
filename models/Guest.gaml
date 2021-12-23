/**
* Name: Guest
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/
model Guest

import "Human.gaml"
import "Phrases.gaml"
import "Dancer.gaml"
import "Drinker.gaml"
import "Extrovert.gaml"
import "Introvert.gaml"
import "Festival.gaml"
species Guest skills: [moving] control: fsm parent: Human {

// Parameters
	float speed <- 4.0 #km / #h;
	float intoxication <- 0.0 min: 0.0 update: intoxication - 0.01;
	float happiness <- 0.0;
	float rotation <- 0.0;

	// Traits of this guest
	int age min: 15 max: 25 init: rnd(15, 25);
	float looks min: 0.0 max: 1.0 init: rnd(0.0, 1.0);
	float personality min: 0.0 max: 1.0 init: rnd(0.0, 1.0);
	float charisma min: 0.0 max: 1.0 init: rnd(0.0, 1.0);
	float wealth min: 0.0 max: 1.0 init: rnd(0.0, 1.0);
	float generosity min: 0.0 max: 1.0 init: rnd(0.0, 1.0);
	bool teetotaler <- flip(0.5);
	map<Guest, float> opinions <- [];
	float perceive (Guest guest) {
		float opinion <- guest.looks + guest.personality;
		opinion <- opinion - (age - guest.age);
		if opinions[guest] != nil {
			opinion <- opinion * opinions[guest];
		}

		return opinion;
	}

	action opinion (Guest guest, float delta) {
		float prev <- 0.0;
		if opinions[guest] != nil {
			prev <- opinions[guest];
		}

		opinions[guest] <- prev + delta;
	}

	action happy (float d) {
		happiness <- happiness + d;
	}

	// State variables
	Guest other;
	bool buy_drink (Drinker for) virtual: true;

	// Drink alcohol
	action drink (float alcohol) {
		intoxication <- intoxication + alcohol;
		if teetotaler {
			do happy(-10.0);
		}

	}

	// Stumble when drunk
	reflex when: intoxication > 0 {
		do wander speed: min(intoxication, 1.0);
	}

	aspect debug {
		if enable_debugging and debug {
			if other != nil {
				draw self link other color: #blue;
			}

		}

	}

	aspect base {
		draw square(1.0) rotate: rotation color: color;
	}

}

