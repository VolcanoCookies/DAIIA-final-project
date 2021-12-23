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

	state idle initial: true {
		enter {
			do release();
			rotation <- 0.0;
			target <- nil;
		}

		do wander;
	}

	state dance {
		enter {
			bounds <- dance_floor;
		}

		// Dance
		rotation <- rotation + 10.0;
		do wander speed: 0.25;

		// Accept any dance requests
		loop r over: requests {
			switch read(r) {
				match DANCE_REQUEST {
					do agree message: r contents: [DANCE_REQUEST];
				}

			}

		}

		transition to: dance_together when: other != nil;
		transition to: asking_to_dance when: flip(0.02);
	}

	state asking_to_dance {
		enter {
			target <- nil;
			other <- any((Guest - self) at_distance 7.5);
			if other != nil {
				do start_conversation to: list(other) performative: "request" protocol: "no-protocol" contents: [DANCE_REQUEST];
			}

		}

		loop a over: agrees {
			if a.sender = other {
			// Happy if person agrees to dance request
				do happy(0.25);
				target <- other;
			}

		}

		loop r over: refuses {
			if r.sender = other {
			// Sad if guest denies dance request
				do happy(-0.25);
				other <- nil;
			}

		}

		transition to: dance when: state_cycle > 15 or other = nil;
		transition to: dance_together when: other != nil and target = other;
	}

	state dance_together {
		if state_cycle mod 10 = 0 {
			if other is Dancer {
			// Extra happy when their dance partner is another dancer
				do happy(0.5);
			}

		}

		// Stop dancing together
		transition to: dance when: other = nil or flip(0.01) {
			ask other {
				other <- nil;
			}

			other <- nil;
		}

	}

	state drink {
		enter {
			target <- bar;
			do confine(bar);
		}

		if flip(0.05 * wealth) {
		// Buy a drink for self
			intoxication <- intoxication + 1.0;
		}

		transition to: idle when: flip(0.01);
	}

	aspect debug {
		if enable_debugging and debug {
		}

	}

}