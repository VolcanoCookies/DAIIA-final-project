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
		}

		do wander;
		transition to: patrol;
	}

	list patrol_places <- [roads, bar, dance_floor, cafe];
	state go_patrol {
		enter {
			target <- any(patrol_places);
		}

		transition to: patrol_roads when: at_target() and target = roads;
		transition to: patrol_bar when: at_target() and target = bar;
		transition to: patrol_dance_floor when: at_target() and target = dance_floor;
		transition to: patrol_cafe when: at_target() and target = cafe;
		exit {
			do confine(target);
			target <- nil;
		}

	}

	state patrol_roads {
		do wander;
	}

	state patrol_bar {
		enter {
			target <- bar;
		}

		if at(bar) and target = bar {
			target <- nil;
		}

		if state_cycle mod 5 = 0 {
			list drinkers <- (Drinker at_distance 7.5) inside bar;
			drinkers <- drinkers sort_by -each.intoxication;
			if !empty(drinkers) and drinkers[0].intoxication >= 2.0 {
			// Throw the drinker out of the bar
				other.target <- roads;
			}

		}

		do wander;
		transition to: throw_out when: other != nil;
	}

	state patrol_dance_floor {
	}

	state patrol_cafe {
	}

	geometry patrol_area;
	state patrol {
		enter {
			patrol_area <- any([bar, dance_floor, cafe, world_plane]);
		}

	}

	aspect debug {
		if enable_debugging and debug {
		}

	}

}