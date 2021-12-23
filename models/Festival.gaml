/**
* Name: Neighbourhood
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/
model Festival

import "Guest.gaml"
import "Dancer.gaml"
import "Drinker.gaml"
import "Extrovert.gaml"

global {
	bool enable_debugging <- false;
	bool draw_roads;
	bool show_states;
	geometry world_plane;
	geometry bar;
	geometry dance_floor;
	geometry cafe;
	geometry roads;

	init {
		create Guest number: 100;
		world_plane <- square(100);
		bar <- rectangle(25, 50);
		dance_floor <- circle(25);
		cafe <- rectangle(25, 25);
		roads <- world_plane - bar - dance_floor - cafe;
	}

	list<Guest> happiest <- [];

	reflex when: cycle mod 5 = 0 {
		happiest <- copy_between(list(Guest) sort_by -each.happiness, 0, 10);
	}

}

experiment Neighbourhood {
	parameter "Enable Debugging" var: enable_debugging init: true;
	parameter "Enable All Logs" var: enable_all_logs init: true;
	parameter "Draw Roads" var: draw_roads init: false;
	parameter "Show States" var: show_states init: true;
	output {
		monitor "Global Happiness" value: list(Guest) sum_of each.happiness;
		display Festival type: opengl background: #white {

		// Draw guests
			species Dancer aspect: debug;
			species Drinker aspect: debug;
			species Extrovert aspect: debug;
			species Guest aspect: debug;
			species Guest aspect: base;
			graphics "Areas" {
			// Draw areas
				draw bar color: #pink;
				draw dance_floor color: #lightblue;
				draw cafe color: #lime;
			}

			graphics "Debug" {
				if show_states {
					loop a over: agents {
						string state <- a get 'state';
						if state != nil {
							draw state at: a.location color: #black;
						}

					}

				}

			}

		}

		/*display Graphs {
			chart "Happiness" type: histogram {
				datalist happiest value: happiest collect each.happiness;
			}
		}*/
	}

}