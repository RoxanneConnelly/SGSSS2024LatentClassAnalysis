STOP
********************************************************************************
**
**# SGSSS SUMMER SCHOOL 2024: LATENT CLASS ANALYSIS
** 	DR ROXANNE CONNELLY, UNIVERSITY OF EDINBURGH
**	ACTIVITY 1
**
********************************************************************************

/*
	
	This activity demonstrates the process of undertaking a simple Latent
	Class Analysis. 
	
	You are studying alcohol drinking behaviour.
	
	You theorise that there are qualitatively different groups (or types) 
	of alcohol drinkers. 
	
	For example you might theorise that people fall into one of three different
	drinker types: abstainers, social drinkers or problem drinkers.
	
	Drinking type is a latent variable (i.e. it cannot be directly measured). 
	
	You are going to use manifest (i.e. observed) variables to group
	individuals using latent class analysis.
		
*/


********************************************************************************




********************************************************************************
**
**#	SET UP
**
********************************************************************************

* 	Here we specify which version of Stata this code is written for

	version 17

	
********************************************************************************
**
**#	GETTING STARTED
**
********************************************************************************	
			
/* 	Open the 'drinking.dta' dataset	

	Here I open the data using the path on my machine. You will need to 
	change this to match the file location on your machine.
	
	Alternatively you can open the file manually by cliking on file (in the 
	main Stata window) then open.											*/

	use "M:/Data/drinking.dta", clear	
	
	numlabel, add
	
* 	Examine the dataset															
	
	count
	
	codebook, compact
	
	list id like hard morning work drunk taste sleep rel bar in 1/10
	
	tab1 like hard morning work drunk taste sleep rel bar
	
	tab1 like hard morning work drunk taste sleep rel bar, mi
	
* 	Spend a moment browsing the data and looking at the patterns of responses 

	browse
	
* 	Close the data viewer window when you are done			
	

	
/*	Examine the correlation between items. A Tetrachoric correlation is 
	used to examine the association between binary variables.				*/

	tetrachoric like hard morning work drunk taste sleep rel bar
	
	

********************************************************************************
**
**#	FIT A LATENT CLASS MODEL
**
********************************************************************************	

/* 	We theorised that there would be three latent classes (i.e. three groups
	of drinkers). Let us start on that basis and fit a latent class analysis
	which specifies three latent groups.									*/	
	

	gsem (like hard morning work drunk taste sleep rel bar <- ), logit lclass(C 3)
	
	
* 	We store the results of this model under the name 'class3'	
	
	estimates store class3
	
	
/* 	We produce a table of marginal predicted means of the outcome within each 
	latent class.															*/
	
	
	estat lcmean, nose
	
/* 	The results under the 'Margin' heading show the probability of answering
	'yes' to each of these items in the three latent classes identified.
	
	If you belong to latent class 1 you have a probability of 0.31 of saying
	you 'like to drink', this probability is 0.91 for those in latent class
	2, and 0.92 for those in latent class 3.
	
	If you look down the items what do you observe?
	
	It seems those in latent class 1 are not so fond of drinking. Not many of
	them like to drink, few like the taste of alcohol, not many visit bars etc.
	We might decide to describe this group as the 'abstainers' group we
	theorised.
	
	It seems that those in latent class 3 might be labelled as 'problem 
	drinkers'. They tend to like to drink, drink to get drunk, and for many 
	drinking interferes with their relationships.
	
	Latent class 2 falls somewhere in the middle, so these might be best
	labelled as our 'social drinkers' group. They like drinking, they sometimes
	go to bars, but it doesn't seem to interfere with their lives.
	
	You will see that the decisions of what each group represents is 
	subjective. You need to interpret what each latent class means,
	and you come up with appropriate names for each latent class. This
	process should be guided by engagement with previous literature and
	appropriate theory.														*/
	
	

	
********************************************************************************
**
**#	ALLOCATE INDIVIDUALS TO LATENT GROUPS
**
********************************************************************************		
	
	
/* 	For each person in the dataset we can estimate what latent class they
	belong to (i.e. what type of drinker they are). For each person, Stata 
	will estimate the probability that they belong to the first, second,
	and third latent class.
	
	The probability of belonging to each latent class is called the
	posterior probability. We can estimate this using the 'predict'
	command.																*/

	capture drop class3post*
	
	predict class3post*, classposteriorpr
	
/*	The predict command has produced three new variables: class3post1,
	class3post2 and class3post3. Each of these variables shows the 
	probability of an individual belonging to class 1, 2 or 3 respectively.	*/
	
	summarize class3post1
	
	summarize class3post2
	
	summarize class3post3
	
	sort id
	
	list id class3post1 class3post2 class3post3 in 1/30
	
/* 	We can see for example that the individual with id number 27 has a 
	probability of 0.92 or being in class 1, 0.08 of being in class 2 and an
	almost negligible probability of being in class 3.		
	
	We can create a single variable which indicates which class individuals
	have the highest probability of being a member of using the code below.	*/
	
	capture drop class3max
	
	egen class3max = rmax(class3post*)
	
	summarize class3max
	
	list id class3post1 class3post2 class3post3 class3max in 1/30
	
/*	We first create the variable above which indicates what their highest
	probability of class membership is (class3max).					
	
	We then allocate the sample members to class 1, 2 or 3 depending on
	which probability this matches. For example if their highest proability
	is being in class 1, we allocate them to class 1.
	
	This is called modal allocation.										*/
	
	capture drop expclass3
	
	gen expclass3 = .
	replace expclass3 = 1 if class3post1 == class3max
	replace expclass3 = 2 if class3post2 == class3max
	replace expclass3 = 3 if class3post3 == class3max

	label variable expclass3 "3 Class model - modal LC"
	
	label define expclass3_lab 1 "Class 1 Abstainer" ///
								2 "Class 2 Social Drinker" ///
								3 "Class 3 Problem Drinker"
	
	label values expclass3 expclass3_lab

	tab expclass3

	sort id
	
	list id class3post1 class3post2 class3post3 class3max expclass3 in 1/30
	
/*	Spend a moment looking at the patterns in the listed cases to ensure you 
	understand what has been done here.				
	
	By examining the expclass3 variable we can see that class 2 is our 
	largest class with 64.6% of cases, class 1 is the second largest with
	28.8% of cases, and class 3 is the smallest with 6.6% of cases. We should
	consider whether this distribution fits with our theory of drinker type. */
	
	tab expclass3
	
	
	
/*	Now you have allocated individuals to classes you could use this variable
	as an outcome variable (aka dependent variable) in a further analysis 
	analysis (e.g. a regression analysis). This would allow you to examine 
	the characteristics of different types of drinkers (e.g. their gender,
	socio-economic status, job type, mental health etc.).
	
	You could also use this variable as an explanatory variable in a further
	analysis (e.g. if you were interested in the impact of 'drinker type' 
	on some outcome).														*/
	
	
	
********************************************************************************
**
**#	COMPARE DIFFERENT MODELS
**
********************************************************************************	

/* 	So far we have assumed that we are correct and that the three class
	model we theorised is the most appropriate. This is a good place to 
	start but you should also compare different model solutions to determine
	how many latent classes are most appropriate for the data you 
	have observed.															*/
		
	
	
	
/* 	Here we start with a one class model. This would place everyone within
	one latent class group.													*/
	
	gsem (like hard morning work drunk taste sleep rel bar <- ), logit lclass(C 1)
	
* 	We store the estimates from this model	
	
	estimates store class1 
	
* 	We examine the goodness of fit statistics for this model
	
	estat lcgof

*	You can see the BIC and AIC statistics in the table produced.
	
	
*	We repeat this process for the 2 class model	
	
	gsem (like hard morning work drunk taste sleep rel bar <- ), logit lclass(C 2)
	
	estimates store class2
	
	estat lcgof	


*	We repeat this process for the 3 class model (which we have considered above)
	
	gsem (like hard morning work drunk taste sleep rel bar <- ), logit lclass(C 3)
	
	estimates store class3
	
	estat lcgof		

/*	We repeat this process for the 4 class model.

	You will note that this model takes a long time to run and gives the 
	'not concave' warning throughout the process. When the model completes 
	there is a 'convergence not achieved' warning message. 
	
	This is described as non-convergence. Stata has been unable to fit this
	model. This happens a lot with latent class models as they are 
	quite complex.															*/

	
	gsem (like hard morning work drunk taste sleep rel bar <- ), logit lclass(C 4) 
	
	
/*	We can help a model converge by using some of the additional options for 
	the gsem command. In particular, changing way Stata selects starting
	values can help models converge.
	
	Here we specify some additional options which will try and help the model 
	converge.
	
	Note there is a lot of additional output, as Stata is performing 
	random draws for starting values 25 times.
	
	Remember you can always inspect the Stata help files for more information
	on all the options available for a command. You would do this by typing 
	'help gsem' in this case.												*/

	gsem (like hard morning work drunk taste sleep rel bar <- ), logit lclass(C 4) ///
		startvalues(randomid, draws(25) seed(1583)) em(iter(15))
		
		
/*	Specifying start values or additional iterations usually helps a latent
	class model converge (but not always as you might see above). 
	
	Sometimes you might have to try other solutions.
	
	At times more complex models simply won't converge and you have to accept
	that these are too complex for the data you have observed.	
	
	A simple point to remember is that you cannot have more latent classes
	than manifest indicators.
	
	This is not unique to latent class analysis, and occurs with many 
	advanced statistical techniques. Not all models work with 'real' data.	*/
	
	

	
/* 	The command below summarises the model fit statistics for each model which
	converged which you stored in Stata's memory.
	
	Which model is the best fitting model?									*/
	
	estimates stats class1 class2 class3
	
	
	
	
/*	It seems model 3 has the lowest AIC, but model 2 has the lowest BIC.
	
	This happens very often with model fit statistics, for any type of model.
	
	To decide between model 2 and model 3 you would want to look at the 
	patterns in your latent classes and be led by theory and prior research
	to decide which is your preferred model.
	
	As model 3 fits with our theory this is our preferred model.			*/
	


	
	

/*	You can also consider how 'crisp' or 'fuzzy' your model solution is. 
	Entropy is a measure of the certainty of a posterior classification.	*/
	
	gsem (like hard morning work drunk taste sleep rel bar <- ), logit lclass(C 3)

	lcaentropy
	
/*	Values closer to 1 indicate the model is more 'crisp' (i.e. a clear
	delineation between classes), and values closer to zero indicate that the 
	model is more 'fuzzy' (i.e. there is not a clear separation between the 
	classes).
	
	The entropy value for the 3 class solution is 0.55
	
	There is not an agreed upon cut-off value for entropy, although suggestions
	do exist in the literature. The value should be considered in relation
	to the specific research context.
	
	To improve the entropy of your latent class analysis model you would want
	to aim have indicators which discriminate strongly between the latent 
	classes.
	
	Entropy should not be relied upon as the single value to evaluate a model
	solution.	
	
	Note: You cannot retrieve an entropy value for a one class solution, as it 
	is a measure of crispness between groups and a one class solution only
	has one group.															*/
	
	
	
********************************************************************************
**
**#	A FEW EXTRA THINGS
**
********************************************************************************		

*	The code below shows the model output you have saved as 'class3'

	estimates replay class3

/*	The code below makes saved model results active in Stata memory (which
	allows you to work with these results).									*/

	estimates restore class3
	
	
/* 	Now that we have the results from the 3 class model active again, we could
	plot these results. A plot of the characteristics of each latent class
	might aid interpretation, particularly in a presentation (a picture 
	paints a thousand words!).	
	
	The code below works through a process of producing three separate graphs
	for each latent class, and then combining these graphs.
	
	Run each block of code separately. 
	
	You might wish to examine the Stata help files if you are unfamiliar 
	with these graphing commands.											*/
	

	margins, 	predict(outcome(like)  		class(1)) ///
				predict(outcome(hard)   	class(1)) ///
				predict(outcome(morning) 	class(1)) ///
				predict(outcome(work) 		class(1)) ///
				predict(outcome(drunk) 		class(1)) ///
				predict(outcome(taste) 		class(1)) ///
				predict(outcome(sleep) 		class(1)) ///
				predict(outcome(rel) 		class(1)) ///
				predict(outcome(bar) 		class(1)) 

	marginsplot, 	recast(bar) title("Class 1") xtitle("") ///
					xlabel(1 "Like" ///
					   2 "Hard" ///
					   3 "Morning" ///
					   4 "Work" ///
					   5 "Drunk" ///
					   6 "Taste" ///
					   7 "Sleep" ///
					   8 "Relationship" ///
					   9 "Bars", angle(45)) ///
				ytitle("Predicted Probability") ylabel(0(0.1)1, labsize(small)) ///
				title("Latent Class 1 (Abstainers)") ///
				scheme(s1color) name(class1, replace) ///
				plotopts(bcolor(navy)) ci1opt(color(black))


	margins, 	predict(outcome(like)  		class(2)) ///
				predict(outcome(hard)   	class(2)) ///
				predict(outcome(morning)  	class(2)) ///
				predict(outcome(work) 		class(2)) ///
				predict(outcome(drunk) 		class(2)) ///
				predict(outcome(taste) 		class(2)) ///
				predict(outcome(sleep) 		class(2)) ///
				predict(outcome(rel) 		class(2)) ///
				predict(outcome(bar) 		class(2)) 

	marginsplot, 	recast(bar) title("Class 2") xtitle("") ///
					xlabel(1 "Like" ///
					   2 "Hard" ///
					   3 "Morning" ///
					   4 "Work" ///
					   5 "Drunk" ///
					   6 "Taste" ///
					   7 "Sleep" ///
					   8 "Relationship" ///
					   9 "Bars", angle(45)) ///
				ytitle("Predicted Probability") ylabel(0(0.1)1, labsize(small)) ///
				title("Latent Class 2 (Social Drinkers)") ///
				scheme(s1color) name(class2, replace) ///
				plotopts(bcolor(maroon)) ci1opt(color(black))
				
				
	margins, 	predict(outcome(like)  		class(3)) ///
				predict(outcome(hard)    	class(3)) ///
				predict(outcome(morning)  	class(3)) ///
				predict(outcome(work) 		class(3)) ///
				predict(outcome(drunk) 		class(3)) ///
				predict(outcome(taste) 		class(3)) ///
				predict(outcome(sleep) 		class(3)) ///
				predict(outcome(rel) 		class(3)) ///
				predict(outcome(bar) 		class(3)) 

	marginsplot, 	recast(bar) title("Class 3") xtitle("") ///
					xlabel(1 "Like" ///
					   2 "Hard" ///
					   3 "Morning" ///
					   4 "Work" ///
					   5 "Drunk" ///
					   6 "Taste" ///
					   7 "Sleep" ///
					   8 "Relationship" ///
					   9 "Bars", angle(45)) ///
				ytitle("Predicted Probability") ylabel(0(0.1)1, labsize(small)) ///
				title("Latent Class 3 (Problem Drinkers)") ///
				scheme(s1color) name(class3, replace) ///
				plotopts(bcolor(forest_green)) ci1opt(color(black))
							
							
	graph combine class1 class2 class3, rows(2) cols(2)	scheme(s1color) ///
	title("Latent Class Analysis of Drinking Behaviour") 

											
	
********************************************************************************
**#	END OF FILE	