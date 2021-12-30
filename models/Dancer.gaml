/**
* Name: Dancer
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/
model Dancer

import "Guest.gaml"

/* Insert your model definition here */
species Dancer parent: Guest {

	init {
		color <- #yellow;
	}

	list danced_with <- [];
	state idle initial: true {
		enter {
			do release();
			rotation <- 0.0;
			target <- nil;
		}

		do wander;
		transition to: dance when: chance(25);
		transition to: drink when: chance(50);
	}

	int complain_cooldown <- 0 min: 0 update: complain_cooldown - 1;
	state dance {
		enter {
			do confine(dance_floor);
			other <- nil;
			target <- nil;
		}

		// Dance
		rotation <- rotation + 10.0;
		do wander speed: 0.25;

		// Avoid drinkers
		list too_close <- Drinker at_distance 5.0;
		if !empty(too_close) {
			point center <- mean(too_close collect each.location);
			do goto target: center speed: -0.5 on: bounds;
		}

		// Complain about others being too intoxicated
		if complain_cooldown = 0 {
			list perceived <- (Guest - self) at_distance 7.5;
			Guest top <- perceived with_max_of each.intoxication;
			if top.intoxication > 2.0 {
			// TODO Call security
				complain_cooldown <- 25;
			}

		}

		// Accept dance requests from extroverts
		loop r over: requests {
			switch read(r) {
				match DANCE_REQUEST {
					Extrovert e <- r.sender as Extrovert;
					// Only accept if their perception of the extrovert is high enough
					if perceive(e) > 0.75 {
						do agree message: r contents: [DANCE_REQUEST];
					} else {
						do refuse message: r contents: [DANCE_REQUEST];
					}

				}

			}

		}

		// Move towards the center of the dance floor
		do goto target: dance_floor on: dance_floor speed: 0.5;
		// Repel from dancers that are too close
		list dancers <- peers at_distance 3.0;
		if !empty(dancers) {
			point center <- mean(dancers collect each.location);
			do goto target: center speed: -0.75 on: dance_floor;
		}

		transition to: dance_together when: other != nil;
		transition to: ask_to_dance_floor when: chance(50);
	}

	state ask_to_dance_floor {
		enter {
			other <- any(Introvert where each.at(dance_floor));
			if other != nil {
				do start_conversation to: list(other) performative: "request" protocol: "no-protocol" contents: [DANCE_FLOOR_INVITE];
			}

		}

		loop a over: agrees {
			if a.sender = other and read(a) = DANCE_FLOOR_INVITE {
				other <- nil;
				do happy(0.25);
			}

		}

		loop r over: refuses {
			if r.sender = other and read(r) = DANCE_FLOOR_INVITE {
				other <- nil;
				do happy(-0.25);
			}

		}

		transition to: dance when: other = nil or state_cycle > 15;
	}

	state dance_together {
		enter {
			add other to: danced_with;
		}

		if frequency(10) {
		// Happy when dancing
			do happy(0.1);
		}

		// Stop dancing together
		transition to: dance when: other = nil or chance(100) {
			ask other {
				other <- nil;
			}

			other <- nil;
		}

	}

	state drink {
		enter {
			if teetotaler {
				target <- bar;
			} else {
				target <- cafe;
			}

			do confine(target);
		}

		if flip(0.05 * wealth) {
		// Buy a drink for self
			if teetotaler {
			// Drink non-alcoholic
				do happy(1.0);
			} else {
				do drink(1.0);
			}

		}

		transition to: idle when: chance(100);
	}

	aspect debug {
		if enable_debugging and debug {
		}

	}

}