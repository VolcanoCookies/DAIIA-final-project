/**
* Name: Traits
* Based on the internal empty template. 
* Author: frane
* Tags: 
*/


model Traits

species Traits {
	int age min: 15 max: 25 init: rnd(15, 25);
	float looks min: 0.0 max: 1.0 init: rnd(0.0, 1.0);
	float personality min: 0.0 max: 1.0 init: rnd(0.0, 1.0);
	float charisma min: 0.0 max: 1.0 init: rnd(0.0, 1.0);
	float reputation min: -1.0 max: 1.0 init: 0.0;
	
	float perceive(Traits traits) {
		float opinion <- traits.looks + traits.personality;
		opinion <- opinion + reputation;
		opinion <- opinion - (age - traits.age);
		return opinion;
	}
}