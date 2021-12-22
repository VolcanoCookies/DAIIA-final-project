/**
* Name: Human
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/


model Human

import "Base.gaml"

import "Neighbourhood.gaml"

species Human skills: [moving, fipa] parent: Base virtual: true {
	
	float reach <- 2.0;

	unknown target <- nil;
	geometry bounds <- world_plane;
	point target_in_geometry <- nil;
	
	bool can_reach(unknown u) {
		if u = nil or (agent(u) != nil and dead(agent(u))) {
			return false;
		} else if u is point {
			return (location distance_to point(u)) < reach;
		} else if (u as agent) != nil {
			return (location distance_to agent(u).shape) < reach;
		} else if u is geometry {
			return (location intersects geometry(u));
		} else {
			return false;
		}
	}
	
	action set_target(unknown new_target, geometry new_bounds <- world_plane) {
		target <- new_target;
		bounds <- new_bounds;
	}
	
	bool at_target {
		return target != nil and can_reach(target);
	}
	
	geometry bounds { 
		if target is geometry and at_target() {
			return geometry(target) inter host.world.shape;
		} else {
			return bounds;
		}
	}
	
	reflex move_to_target when: target != nil and !at_target() {
		if target is geometry {
			if target_in_geometry = nil or !(target_in_geometry intersects geometry(target)){
				target_in_geometry <- any_location_in(geometry(target));
			}
			do goto target: target_in_geometry on: bounds;
		} else {
			do goto target: target on: bounds;	
		}
	}
	
	reflex separate {
		list too_close <- (peers - target) at_distance 1.75;
		if !empty(too_close) {
			point center <- mean(too_close collect each.location) as point;
			float angle <- location towards center;
			do move heading: angle speed: -0.5 bounds: bounds();
		}
	}
	
}