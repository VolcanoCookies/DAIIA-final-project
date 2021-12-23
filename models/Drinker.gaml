/**
* Name: Dancer
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/
model Drinker

import "Guest.gaml"
species Drinker parent: Guest {

	init {
		color <- #lightblue;
		// Drinkers can never be teetotalers
		teetotaler <- false;
	}

	int alcohol_desire <- 0 min: 0 max: 100 update: alcohol_desire + 1;
	state idle initial: true {
		enter {
			do release();
			rotation <- 0.0;
			target <- nil;
		}

		do wander;
		transition to: drink when: alcohol_desire = 100;
	}

	state drink {
		enter {
			target <- bar;
		}

		if at(bar) {
			do confine(bar);
		}

		if wealth > 0.5 and flip(0.1) {
		// Buy themselves a drink
			do drink(0.25);
		}

		if alcohol_desire = 100 and state_cycle > 100 and flip(0.25) {
		// Ask someone to buy them a drink
			Guest other <- any((Guest - self) inside bar);
			if other.buy_drink(self) {
			// Someone bought them a drink
				do drink(0.5);
				do opinion(other, 5.0);
			} else {
			// They did not receive a drink
				do opinion(other, -2.5);
			}

			// Break stuff or start a fight idk
		}

		transition to: idle when: at(roads) and target = roads;
		transition to: idle when: alcohol_desire < 100 and flip(0.1);
	}

	action drink (float alcohol) {
		intoxication <- intoxication + alcohol;
		alcohol_desire <- alcohol_desire - int(alcohol * 5);
	}

	aspect debug {
		if enable_debugging and debug {
		}

	}

}