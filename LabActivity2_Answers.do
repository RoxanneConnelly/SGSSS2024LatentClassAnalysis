STOP
********************************************************************************
**
**# SGSSS SUMMER SCHOOL 2024: LATENT CLASS ANALYSIS
** 	DR ROXANNE CONNELLY, UNIVERSITY OF EDINBURGH
**	ACTIVITY 2 ANSWERS
**
********************************************************************************

/*
	You never really learn data analysis until you have to do it yourself.
	
	In this activity you will apply the code from activity 1 to a new 
	example. Work at your own pace and practice the commands.
	
	Remember you can always view the useful Stata help materials using
	the 'help' command.
	
	In this example you are interested in risky behaviours in adolescence.	*/
	

********************************************************************************




********************************************************************************
**
**#	SET UP
**
********************************************************************************

	version 17
	
	
********************************************************************************
**
**#	GETTING STARTED
**
********************************************************************************

/*	Open the 'atrisk.dta' dataset (edit the location below to match the 
	location on your computer or open the dataset manually from the main Stata
	window)																	*/								
		
	use "M:/Data/atrisk.dta", clear
	
	numlabel, add
	
	
	
*	Examine the dataset (e.g. using codebook)

	codebook, compact


* 	How many observations are in this dataset?	

	count

*	What is a average age of the sample?

	summarize age
	
*	What proportion of respondents had ever consumed alcohol?

	tab alcohol

*	What proportion of respondents had ever engaged in vandalism?

	tab vandalism

*	What proportion of respondents had ever stolen something worth more than $25?

	tab theft
	
* 	What proportion of respondents had more than 10 unexcused absences from school?

	tab truant
	
*	What proportion of respondents had ever used a weapon in a fight?

	tab weapon
	
	
	
	tab1 alcohol truant vandalism theft weapon	
	

	


/*	Fit a tetrachoric correlation using the variables listed below:

	alcohol truant vandalism theft weapon
	
	Describe the overall pattern of correlation between these variables?	
	
*/

	tetrachoric alcohol truant vandalism theft weapon 


/*	You are researching risky behaviours in adolescence using these five
	manifest variables.
	
	Spend a moment thinking about these variables. 
	
	Knowing what you know about adolescence, what latent class groups do you 
	think you might find?													*/
	
	
	
	
	
	

********************************************************************************
**
**#	FIT A LATENT CLASS MODEL
**
********************************************************************************

/*	Fit a series of latent class models (1 to 4 classes) using the variables
	listed below as your manifest variables:
	
	alcohol truant vandalism theft weapon	
	
	Think in advance: if you were to run into a convergence problem, how might
	you try to overcome this?
	
	Remember sometimes models just don't converge and you have to make a 
	decision based on the models you have estimated successfully.			*/


*	1 Class Model

	gsem (alcohol truant vandalism theft weapon  <- ), logit lclass(C 1) 
		
	estimates store class1 
	
	estat lcgof
	

	

*	2 Class Model
	
	gsem (alcohol truant vandalism theft weapon  <- ), logit lclass(C 2)
		
	estimates store class2 
	
	estat lcgof



*	3 Class Model

	gsem (alcohol truant vandalism theft weapon  <- ), logit lclass(C 3) 
		
	estimates store class3
	
	estat lcgof
	


	
*	4 Class Model

	gsem (alcohol truant vandalism theft weapon  <- ), logit lclass(C 4) 


	gsem (alcohol truant vandalism theft weapon  <- ), logit lclass(C 4) ///
				startvalues(randomid, draws(25) seed(1583)) ///
				em(iter(15)) nodvheader nonrtolerance
							
		
	estimates store class4 
	
	estat lcgof
	

	
	

	
	
/*	Compare the fit of these models. 

	Which is your preferred model? How did you come to this decision?		*/

	estimates stats class1 class2 class3 
	
	
	estimates restore class2
	
	lcaentropy
	
	estimates restore class3
	
	lcaentropy
	
	
/*	Using your preferred model, examine the marginal predicted means of
	each manifest item.														*/
	
	estimates restore class3
	
	estat lcmean, nose
	
	
	
/* 	Based on what you observe, what would you name each latent group?		*/
	
*	Latent Group 1 - Good Kids
*	Latent Group 2 - Average Teens
* 	Latent Group 3 - High Risk / Concerning Behaviour

	
	
	
	
	
/*	Make a graph to illustrate the patterns of marginal predicted means 
	for your preferred model.												*/

	margins, 	predict(outcome(alcohol)  		class(1)) ///
				predict(outcome(truant)   		class(1)) ///
				predict(outcome(vandalism) 		class(1)) ///
				predict(outcome(theft) 			class(1)) ///
				predict(outcome(weapon) 		class(1)) ///

	marginsplot, 	recast(bar) title("Class 1") xtitle("") ///
					xlabel(1 "Alcohol" ///
					   2 "Truant" ///
					   3 "Vandalism" ///
					   4 "Theft" ///
					   5 "Weapon", angle(45)) ///
				ytitle("Predicted probability") ylabel(0(0.1)1) ///
				title("Latent Class 1 (Good Kids)") ///
				scheme(s1color) name(class1, replace) ///
				plotopts(bcolor(green)) ci1opt(color(black))


	margins, 	predict(outcome(alcohol)  		class(2)) ///
				predict(outcome(truant)   		class(2)) ///
				predict(outcome(vandalism) 		class(2)) ///
				predict(outcome(theft) 			class(2)) ///
				predict(outcome(weapon) 		class(2)) ///

	marginsplot, 	recast(bar) title("Class 2") xtitle("") ///
					xlabel(1 "Alcohol" ///
					   2 "Truant" ///
					   3 "Vandalism" ///
					   4 "Theft" ///
					   5 "Weapon", angle(45)) ///
				ytitle("Predicted probability") ylabel(0(0.1)1) ///
				title("Latent Class 2 (Average Teens)") ///
				scheme(s1color) name(class2, replace) ///
				plotopts(bcolor(orange)) ci1opt(color(black))
				
				
	margins, 	predict(outcome(alcohol)  		class(3)) ///
				predict(outcome(truant)   		class(3)) ///
				predict(outcome(vandalism) 		class(3)) ///
				predict(outcome(theft) 			class(3)) ///
				predict(outcome(weapon) 		class(3)) ///

	marginsplot, 	recast(bar) title("Class 3") xtitle("") ///
					xlabel(1 "Alcohol" ///
					   2 "Truant" ///
					   3 "Vandalism" ///
					   4 "Theft" ///
					   5 "Weapon", angle(45)) ///
				ytitle("Predicted probability") ylabel(0(0.1)1) ///
				title("Latent Class 3 (High Risk)") ///
				scheme(s1color) name(class3, replace) ///
				plotopts(bcolor(red)) ci1opt(color(black))
							
							
	graph combine class1 class2 class3, rows(2) cols(2)	scheme(s1color) ///
	title("Latent Class Analysis of Risk Behaviours") 
	

	
	
********************************************************************************
**
**#	ALLOCATE INDIVIDUALS TO LATENT GROUPS
**
********************************************************************************	

/* 	Using your preferred model, allocate the sample members to their most
	probable latent class.
	
	How many sample members fall in each of your latent class groups?		*/

	capture drop class3post*
	
	predict class3post*, classposteriorpr
	
	summarize class3post1
	
	summarize class3post2
	
	summarize class3post3
	
	sort id
	
	list id class3post1 class3post2 class3post3 in 1/30
	
	
	
	
	capture drop class3max
	
	egen class3max = rmax(class3post*)
	
	summarize class3max
	
	list id class3post1 class3post2 class3post3 class3max in 1/30
	
	capture drop expclass3
	
	gen expclass3 = .
	replace expclass3 = 1 if class3post1 == class3max
	replace expclass3 = 2 if class3post2 == class3max
	replace expclass3 = 3 if class3post3 == class3max

	label variable expclass3 "3 Class model - modal LC"
	
	label define expclass3_lab 1 "Class 1 Good Kids" ///
								2 "Class 2 Average Teens" ///
								3 "Class 3 High Risk"
	
	label values expclass3 expclass3_lab

	tab expclass3

	sort id
	
	list id class3post1 class3post2 class3post3 class3max expclass3 in 1/30
	
	tab expclass3


	
********************************************************************************
**
**#	ANALYSE CLASS MEMBERSHIP
**
********************************************************************************	
	
/*	Run a multinomial logistic regression with your class membership variable	
	as the outcome (dependent) variable and 'age' and 'male' as your 
	explanatory variables.													*/
	
	mlogit expclass3 age ib0.male, allbaselevels
	
*	What does this model tell you about the composition of your latent classes?

	tab expclass3 male, row
	
	
	
	
/*	If you had appropriate variables in your dataset you could use your
	latent class variable as an explanatory variable in further analysis.
	
	For example you might examine the association between risky adolescent 
	behaviours and completing secondary school, getting a criminal conviction, 
	becoming the victim of a crime, or adult unemployment.					*/
	
	
	
	
	
**	Well done, you can now undertake a latent class analysis!		 	
	
********************************************************************************
**# END OF FILE	