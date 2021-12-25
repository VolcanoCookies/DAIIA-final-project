/**
* Name: Dancer
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/
model Introvert

import "Guest.gaml"
species Introvert parent: Guest {

	init {
		color <- #lightblue;
	}

	state idle initial: true {
		enter {
			do release();
			rotation <- 0.0;
			target <- nil;
		}

		do wander;
	}

	state drink {
		enter {
			target <- bar;
			do confine(bar);
		}

		if at(bar) {
			list drinkers <- Drinker at_distance 5.0;
			if !empty(drinkers) {
			// Unhappy when close to drinkers in bar
				do happy(-0.25);
				point center <- mean(drinkers collect each.location) as point;
				float angle <- location towards center;
				do move heading: angle speed: -0.5 bounds: bounds();
			}

		}

	}

	bool agree_throw_out {
		return true;
	}

	aspect debug {
		if enable_debugging and debug {
		}

	}

}