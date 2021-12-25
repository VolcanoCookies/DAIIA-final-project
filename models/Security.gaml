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
		color <- #lime;
	}

	state idle initial: true {
		enter {
			do release();
			rotation <- 0.0;
			target <- nil;
			other <- nil;
		}

		do wander;
		transition to: patrol;
	}

	list patrol_places <- [roads, bar, dance_floor, cafe];
	state go_patrol {
		enter {
			target <- any(patrol_places);
		}

		transition to: patrol_bar when: at_target() and target = bar;
		transition to: patrol_dance_floor when: at_target() and target = dance_floor;
		transition to: patrol_cafe when: at_target() and target = cafe;
		exit {
			do confine(target);
			target <- nil;
		}

	}

	state throw_out {
		enter {
			target <- other;
			bool chase <- false;
		}

		if at(other) {
			if other.agree_throw_out() {
			// Tell the guest to leave
				ask other {
					target <- roads;
					do happy(-0.5);
				}

				target <- nil;
			} else {
				chase <- true;
			}

		}

		if not (other.at(bounds)) {
			target <- nil;
		}

		transition to: chase when: chase;
		transition to: idle when: target = nil;
	}

	state chase {
		enter {
			target <- other;
			do release();
		}

		if at(other) {
		// Beat em or something
			target <- nil;
		}

		transition to: idle when: target = nil;
	}

	state patrol_bar {
		if state_cycle mod 5 = 0 {
			list drinkers <- (Drinker at_distance 7.5) inside bar;
			drinkers <- drinkers sort_by -each.intoxication;
			if !empty(drinkers) and drinkers[0].intoxication >= 2.0 {
			// Throw the drinker out of the bar
				other.target <- roads;
			}

		}

		do wander;
		transition to: idle when: flip(0.01);
	}

	state patrol_dance_floor {
		if state_cycle mod 5 = 0 {
		}

	}

	state patrol_cafe {
	}

	geometry patrol_area;
	state patrol {
		enter {
			patrol_area <- any([bar, dance_floor, cafe, world_plane]);
		}

	}

	bool buy_drink (Drinker for) {
		return false;
	}

	bool agree_throw_out {
		return false;
	}

	aspect debug {
		if enable_debugging and debug {
		}

	}

}