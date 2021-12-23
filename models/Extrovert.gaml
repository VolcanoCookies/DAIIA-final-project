/**
* Name: Dancer
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/
model Extrovert

import "Guest.gaml"
species Extrovert parent: Guest {

	init {
		color <- #red;
	}

	bool buy_alcohol (Drinker for) {
		return generosity > 0.9 or (perceive(for) > 0.75 and generosity > 0.6);
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
			if flip(0.02) {
			// Buy a drink for themselves
				do drink(0.25);
			} else if flip(0.06) {
			// Offer someone else a drink
				other <- any((Guest - self) at_distance 7.5);
			}

		}

		transition to: offer_drink when: other != nil;
		transition to: idle when: flip(0.01);
	}

	state offer_drink {
		enter {
			target <- nil;
			// Ask the person if they want a drink
			do start_conversation to: list(other) performative: "inform" protocol: "no-protocol" contents: [OFFER_DRINK];
		}

		loop a over: agrees {
			if a.sender = other and read(a) = OFFER_DRINK {
				target <- other;
			}

		}

		loop r over: refuses {
			if r.sender = other and read(r) = OFFER_DRINK {
				other <- nil;
			}

		}

		if at_target() {
		// Give the person a drink 
			ask other {
				do drink(0.5);
				do happy(1.0);
				other <- nil;
			}

			do happy(1.0);
			other <- nil;
		}

		transition to: drink when: state_cycle > 25 or other = nil;
	}

	state dance {
		enter {
			do release();
			dance_partner <- nil;
		}
		// Dance
		rotation <- rotation + 10.0;
		do wander speed: 0.25;

		// Accept any dance requests
		loop r over: requests {
			if read(r) = DANCE_REQUEST {
				do agree message: r contents: [DANCE_REQUEST];
			}

		}

		transition to: asking_to_dance when: flip(0.02);
		transition to: asking_to_dance when: dance_partner != nil;
	}

	state asking_to_dance {
		enter {
			Guest partner <- any((Guest - self) at_distance 7.5);
			if partner != nil {
				do start_conversation to: list(dance_partner) performative: "request" protocol: "no-protocol" contents: [DANCE_REQUEST];
			}

		}

		loop a over: agrees {
			if a.sender = partner {
				dance_partner <- partner;
				do happy(0.1);
			}

		}

		loop r over: refuses {
			if r.sender = partner {
				do happy(-0.1);
			}

		}

		transition to: dance when: partner = nil;
		transition to: dance_together when: dance_partner != nil or state_cycle > 15;
	}

	state dance_together {
		enter {
			target <- dance_partner;
		}

		if state_cycle mod 10 = 0 {
			if dance_partner is Dancer {
				do happy(0.5);
			}

		}

		transition to: dance when: dance_partner = nil or flip(0.01) {
			ask dance_partner as Dancer {
				dance_partner <- nil;
			}

		}

	}

	aspect debug {
		if enable_debugging and debug {
		}

	}

}