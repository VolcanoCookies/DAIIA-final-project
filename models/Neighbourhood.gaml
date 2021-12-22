/**
* Name: Neighbourhood
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/


model Neighbourhood

import "House.gaml"
import "Store.gaml"
import "Student.gaml"

global {
	
	bool enable_debugging <- false;
	bool draw_roads;
	bool show_states;
	
	geometry world_plane;
	geometry roads;
	
	float global_happiness <- 0.0 update: list(Student) sum_of each.happiness;
	
	init {
		
		create Student number: 100;
		create House number: 8;
		create Cop number: 10 {
			location <- {20.0, 80.0};
		}
		
		world_plane <- square(100);
		roads <- world_plane;
		loop h over: House {
			roads <- roads - h.plot;
			roads <- roads - h.shape;
		}
		
	}
	
}

experiment Neighbourhood {
	
	parameter "Enable Debugging" var: enable_debugging init: true;
	parameter "Enable All Logs" var: enable_all_logs init: true;
	parameter "Draw Roads" var: draw_roads init: false;
	parameter "Show States" var: show_states init: true;
	
	output {
		
		monitor "Global Happiness" value: global_happiness;
		
		display Neighbourhood type: opengl background: #white {
			
			// Draw houses
			species House aspect: debug;
			species House aspect: floor transparency: 0.5;
			species House aspect: plot transparency: 0.3;
			
			species Store aspect: debug;
			species Store aspect: floor;
			
			species Station aspect: debug;
			species Station aspect: floor;
			
			species Student aspect: base;
			
			species Cop aspect: base;
			
			graphics "Debug" {
				if draw_roads {
					draw roads color: rgb(100, 0, 0, 55);
				}
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
		
	}
	
}