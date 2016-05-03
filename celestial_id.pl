/*******************************************************************************
 A celestial object identifier. You see something in the night sky and aren't
 sure what it is. You take some measurements and readings. But what could they
 mean? Tell this system your observations to find out what the object could be!
*******************************************************************************/

/*******************************************************************************
 READ ME: 
 Be sure to execute the function 'cleanup' when done.
 To run the program, start a prolog session. Run ?- consult(CelestialID) . Then
 just execute the run function -? run .
 Execute -? summary . to see what the object could be.
*******************************************************************************/

/*******************************************************************************
 MAIN
*******************************************************************************/
run :- write('Welcome astronomer! Please answer the following questions.'), nl,
       write('Be sure to end each answer with a period.'), nl,
       write('When all the questions have been asked, type: "summary."'),
       write('to get an estimation of what the object you see might be.'), nl,
       write('Please type: "cleanup." before you run the program again.'), nl,
       nl, celestial_object(X), fail, nl.

/* There could be multiple possibilities for what you see. We list all of them
   and how certain we are that it is that thing. If the object is unknown there
   is no certainty factor. */

summary :- write('The thing you see is:'), nl, 
           (object_is(X, CF) ; object_is(X)), write(X), 
           nonvar(CF), write(', with certainty: '), write(CF), nl, fail.

cleanup :- retractall(object_is(_)), 
		   retractall(object_is(_, _)), 
		   retractall(known(_, _)), 
		   retractall(known(_, _, _)) .

/*******************************************************************************
 FUNCTIONS
*******************************************************************************/
:- dynamic known/3.
:- dynamic object_is/2.
:- dynamic object_is/1.

/* Get the smallest thing in a list. So far all the CFs are calculated using only
   two or one conditional CFs so this function isn't necessary, but is used
   anyways to make everything more extendable */
get_min([H|T], Min) :- get_min(T, H, Min) .
get_min([], Min, Min) .
get_min([H|T], Min0, Min) :- Min1 is min(H, Min0), get_min(T, Min1, Min) .		

/*******************************************************************************
 Possible space objects
*******************************************************************************/

/* STARS
   The parallax measurement is the degree (in arcseconds) between where the
   star was observed on the summer solstice versus where it was observed on
   the winter solstice (or on any two days where the Earth is at it's most 
   opposite on its orbit around the sun) .  
   Luminosity is the amount of energy expelled out of a star. Solar luminosity 
   is how much more luminous a star is than the sun. 
   The max emission wave length of a star is the length of the wave of radiation 
   that the star emits most intensely (in nanometers).
   All attributes are measurable from Earth. */
   
/* There are alot of stars out there and other objects that look like stars but
   are not. Measurements taken for stars that are very far away (like the star 
   Deneb) are less accurate. So we add certainty factors for stars. */

/* Solar luminosity of Sirius is 25. Max emission wavelength is 291.75
   nanometers. Parallax measurement of 0.3787 arcseconds.
   This rule has a CF of 0.8. */
celestial_object(sirius) :- type(star, A), 
							distance(earth, star, very_near, B), 
							spectral_type(a), 
							size(star, large), 
							get_min([A, B], CondCF), 
							CF is 0.95*CondCF, 
							asserta(object_is(sirius, CF)) .
														
/* Solar luminosity is 6400. Max emission wavelength is 131.81 nanometers. 
   Parallax measurement of 0.01333 arcseconds. This rule has a CF of 0.95. */
celestial_object(bellatrix) :- type(star, A), 
							   distance(earth, star, very_near, B), 
							   spectral_type(b), 
							   size(star, large), 
							   get_min([A, B], CondCF), 
							   CF is 0.95*CondCF, 
							   asserta(object_is(bellatrix, CF)) .
														 
/* Solar luminosity is 200000. Max emission wavelength is 340 nanometers. 
   Parallax measurement of 0.001246 arcseconds. This rule has a CF of 0.9. */													 
celestial_object(deneb) :- type(star, A), 
						   distance(earth, star, crazy_far, B), 
						   spectral_type(a), 
						   size(star, super_giant), 
						   get_min([A, B], CondCF), 
						   CF is 0.9*CondCF, 
						   asserta(object_is(deneb, CF)) .
													 
celestial_object(an_unknown_star) :- type(star, W), 
									 not(object_is(X, Y)), 
									 not(object_is(Z)), 
    								 asserta(object_is(an_unknown_star, W)) .

/* PLANETS
   We assume the expert system is on Earth, so no need to try and identify it. 
   Sizes of planets can be measured using trigonometry and parallax. We assume
   you've measured the diameter of the planet in kms. Like stars, something
   observed might not be a planet, so we add certainty factors. */
   
/* Diamter of mercury is 4879kms. The CF of this rule is 0.9. */  
celestial_object(mercury) :- type(planet, A), 
							 size(planet, very_small), 
							 orbital_period(short), 
							 CF is 0.9*A, 
							 asserta(object_is(mercury, CF)) .

/* Diameter of venus is 12104kms. The CF of this rule is 0.9. */
celestial_object(venus) :- type(planet, A), 
						   size(planet, small), 
						   orbital_period(short), 
						   CF is 0.9*A, 
						   asserta(object_is(venus, CF)) .
													 
/* Diameter of mars is 6779kms. The CF of this rule is 0.9. */													 
celestial_object(mars) :- type(planet, A), 
						  size(planet, small), 
						  orbital_period(medium), 
						  CF is 0.9*A, 
						  asserta(object_is(mars, CF)) .					
													 
/* Diameter of jupiter is 139882kms. The CF of this rule is 0.9. */	
celestial_object(jupiter) :- type(planet, A), 
							 size(planet, very_large), 
							 orbital_period(long), 
							 CF is 0.9*A, 
							 asserta(object_is(jupiter, CF)) .

/* Diameter of saturn is 116464kms. The CF of this rule is 0.9. */	
celestial_object(saturn) :- type(planet, A), 
							size(planet, very_large), 
							orbital_period(long), 
							CF is 0.9*A, 
							asserta(object_is(saturn, CF)) .

/* Diameter of uranus is 50724kms. The CF of this rule is 0.9. */	
celestial_object(uranus) :- type(planet, A), 
							size(planet, large), 
							orbital_period(very_long), 
							CF is 0.9*A, 
							asserta(object_is(uranus, CF)) .		  

/* Diameter of neptune is 49244kms. The CF of this rule is 0.9. */												
celestial_object(neptune) :- type(planet, A), 
							 size(planet, large), 
							 orbital_period(super_long), 
							 CF is 0.9*A, 
							 asserta(object_is(neptune, CF)) .
							 
/* Diameter of pluto is 2372kms. The CF of this rule is 0.9. */		
celestial_object(pluto) :- type(planet, A), 
					       size(planet, very_small), 
						   orbital_period(super_long), 
						   CF is 0.9*A, 
						   asserta(object_is(pluto, CF)) .	
										 
celestial_object(an_unknown_planet) :- type(planet, W), 
									   not(object_is(Y)), 
									   not(object_is(X, Y)), 
									   asserta(object_is(an_unknown_planet, W)) .
																			 
/* MOONS 
  Some planets have over 60 moons so we just have a default case, a_moon.
   Moons have complicated movements and orbit planets. */
celestial_object(a_moon) :- type(moon, A), 
							asserta(object_is(a_moon, A)) .
														
/* ASTEROIDS 	
   Asteroids are hard to distinguish so we just have one default case, 
   an_asteroid. They can orbit the sun or planets, have complicated movements, 
   and are super small. We can consider them to be very small planets so we use
   the size(planet, X) predicate. */
      					
celestial_object(an_asteroid) :- type(an_asteroid, A), 
								 asserta(object_is(an_asteroid, A)) .

celestial_object(an_unknown_object) :- not(object_is(Y)), 
									   not(object_is(Y, CF)), 
									   asserta(object_is(an_unknown_object)) . 
																			 
						  
/*******************************************************************************
 CATEGORIES
*******************************************************************************/

/* If the object's brightness is high and it's movement is stationary, then it
   is most likely a star. If its movement is complicated and it orbits a planet
   then it is most likely a moon. If it orbits the sun and has complicated
   movement then it is most likely a planet. If it has a complicated movement
   and orbits anything, then it could an asteroid. 

   The predicates 'movement', 'brightness', and 'orbits' have no CF. I thought
   it made sense to add CFs to the 'type' rule as an object that is stationary
   and has high brightness, for example, could still be something else. */

type(star, 0.9) :- movement(stationary), 
				  brightness(high) .
						       
type(planet, 0.9) :- movement(complicated), 
					orbits(sun) .
										
type(moon, 0.9) :- movement(complicated), 
				  orbits(planet) .										
										
/* Asteroids are not super common so have a lower CF */												 
type(an_asteroid, 0.4) :- movement(complicated), 
						 size(planet, super_small), 
				  		 (orbits(sun) ; orbits(planet)) .

/* Determine the size of the star. We put the solar radii into categories 
  (biggest to smallest): super giant, giant, large, small, and dwarf. */
size(star, super_giant) :- solar_radius(X), X>100, X=<1000.
size(star, giant) :- solar_radius(X), X>10, X=<100.
size(star, large) :- solar_radius(X), X>1, X=<10.
size(star, small) :- solar_radius(X), X>0.1, X=<1.
size(star, dwarf) :- solar_radius(X), X>0.01, X=<0.

size(planet, super_small) :- diameter(D), D>1, D=<2000.
size(planet, very_small) :- diameter(D), D>2000, D=<5000.
size(planet, small) :- diameter(D), D>5000, D=<15000.
size(planet, large) :- diameter(D), D>15000, D=<60000.
size(planet, very_large) :- diameter(D), D>60000, D=<150000.

/* Determine the spectral type. */
spectral_type(o) :- surface_temp(X), X>28000, X=<50000.
spectral_type(b) :- surface_temp(X), X>10000, X=<28000.
spectral_type(a) :- surface_temp(X), X>7500, X=<10000.
spectral_type(f) :- surface_temp(X), X>6000, X=<7500.
spectral_type(g) :- surface_temp(X), X>5000, X=<6000.
spectral_type(k) :- surface_temp(X), X>3500, X=<5000.
spectral_type(m) :- surface_temp(X), X>2500, X=<3500.

/* In this category the distance predicate is used for relative distances
   to stars. The distance predicate can also be used as 
   distance (specific_object, specific_object, dist), where dist is the 
   distance between the two objects. These categories are very relative.
   There are stars that are more than 15 million parsecs away. So 201 
   parsecs doesn't seem crazy far. So we say these categories are
   based off stars that are 800 parsecs away or less. 
   Distance measurements are not always accurate, especially when the star
   is very far. So we add certainty factors to the distance predicate. */
      
distance(earth, star, very_near, 0.99) :- parallax(P), 
                                          dist_formula(P, D), 
                                          D>1, D=<100.

distance(earth, star, near, 0.98) :- parallax(P), 
                                     dist_formula(P, D), 
                                     D>100, D=200.

distance(earth, star, far, 0.97) :- parallax(P), 
                                    dist_formula(P, D), 
                                    D>200, D=<300.

distance(earth, star, very_far, 0.96) :- parallax(P), 
                                         dist_formula(P, D), 
                                         D>400, D=<500.

distance(earth, star, crazy_far, 0.95) :- parallax(P), 
                                          dist_formula(P, D), 
                                          D>500.


/*******************************************************************************
 FORMULAS
*******************************************************************************/
solar_radius(R) :- solar_luminosity(L), 
                   surface_temp(T), 
                   R is sqrt((L/(((T/5830))**4))) .

/* surface temp is determined by Wien's law */
surface_temp(T) :- max_emission_wavelength(W), 
                   T is ((0.0029/(W*(10.0**(-9.0))))) .

/* The distance to a star from Earth is simply 1 divided by the parallax. How
   nice is that? Though this formula isn't totally accurate for stars that are 
  very far. Distances are in parsecs. */
dist_formula(P, D) :- D is 1/P . 

/*******************************************************************************
 Below are predicates that have to ask the user.
 No certainty factors were added for any predicates that ask the user. If they
 take a measurement or reading we believe it to be true. I suppose you could
 add a certainty factor that takes human error into account (it's possible to
 take an incorrect reading), but I didn't bother with that.
*******************************************************************************/
orbital_period(X) :- askA(orbital_period, X) .
movement(X) :- askA(movement, X) .
brightness(X) :- askA(brightness, X) .
orbits(X) :- askA(orbits, X) . 
orbits_planet(X) :- askA(orbits_planet, X) .

/* Solar luminosity is a unit of measurement in of itself */
solar_luminosity(L) :- askB(solar_luminosity, L) .

/* But the following need to have their units of measurements specified */
parallax(P) :- askC(parallax, P, 'arcseconds') .
max_emission_wavelength(W) :- askC(max_emission_wavelength, W, 'nanometers') .
diameter(D) :- askC(diameter, D, 'kilometers') .

/*******************************************************************************
 QUESTIONS
*******************************************************************************/
/* Yes or no questions  */
askA(A, V) :- known(yes, A, X), X\=V, !, fail.
askA(A, V) :- known(yes, A, V), !.
askA(A, V) :- known(no, A, V), !, fail.
askA(A, V) :- write('Does the space object have the following attribute: '), 
			  write(A:V), write('? '), read(Y), 
			  asserta(known(Y, A, V)), Y == yes.

/* Questions to obtain some value from the user */
askB(A, V) :- known(yes, A, V), !.
askB(A, V) :- write('What is the '), 
			  write(A), write('? '), 
			  read(V), asserta(known(yes, A, V)) .
askC(A, V, Units) :- known(yes, A, V), !.
askC(A, V, Units) :- write('What is the '), 
			         write(A), write(', in '), write(Units), write(' ? '), 
			         read(V), asserta(known(yes, A, V)) .
