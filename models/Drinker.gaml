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
			other <- nil;
		}

		do wander;

		// Avoid the cafe
		if at(cafe) {
			do goto target: cafe speed: -0.5;
		}

		transition to: dance when: chance(50);
		transition to: drink when: alcohol_desire = 100 or chance(25);
	}

	state drink {
		enter {
			do confine(bar);
		}

		if wealth > 0.5 and chance(10) {
		// Buy themselves a drink
			do drink(0.5);
		} else if chance(5) {
		// Ask an extrovert to buy them a drink
			other <- any(Extrovert inside bar);
		}

		if alcohol_desire = 100 and state_cycle > 100 and chance(4) {
		// Ask someone to buy them a drink
			other <- any((Guest - self) inside bar);
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

		transition to: ask_for_drink when: other != nil;
		transition to: idle when: at(roads) and target = roads;
		transition to: idle when: alcohol_desire < 100 and flip(0.1);
	}

	state ask_for_drink {
		enter {
			target <- other;
		}

		ask other {
			if !at(bar) {
				myself.other <- nil;
			}

		}

		transition to: drink when: other = nil;
	}

	state dance {
		enter {
			do confine(dance_floor);
		}

		// Dance
		rotation <- rotation + 10.0;
		do wander speed: 0.25;
		if intoxication > 2.0 {
			do goto target: Dancer closest_to self speed: 0.75 on: bounds;
		}

		transition to: idle when: state_cycle > 50 and chance(100);
	}

	action drink (float alcohol) {
		intoxication <- intoxication + alcohol;
		do happy(alcohol * 0.75);
		alcohol_desire <- alcohol_desire - int(alcohol * 5);
	}

	aspect debug {
		if enable_debugging and debug {
		}

	}

}