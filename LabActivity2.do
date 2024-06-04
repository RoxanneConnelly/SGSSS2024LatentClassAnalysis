STOP
********************************************************************************
**
**# SGSSS SUMMER SCHOOL 2024: LATENT CLASS ANALYSIS
** 	DR ROXANNE CONNELLY, UNIVERSITY OF EDINBURGH
**	ACTIVITY 2
**
********************************************************************************

/*
	You never really learn data analysis until you have to do it yourself.
	
	In this activity you will apply the code from activity 1 to a new 
	example. Work at your own pace and practice the commands. Feel free to
	work in a group if you prefer.
	
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

******************************************************************************
**
**#	GETTING STARTED
**
********************************************************************************

*	Open the 'atrisk.dta' dataset												
		
	
	
	
*	Examine the dataset (e.g. using codebook)

	


* 	How many observations are in this dataset?	

	

*	What is a average age of the sample?

	
	
*	What proportion of respondents had ever consumed alcohol?

	

*	What proportion of respondents had ever engaged in vandalism?

	

*	What proportion of respondents had ever stolen something worth more than $25?

	
	
* 	What proportion of respondents had more than 10 unexcused absences from school?

	
	
*	What proportion of respondents had ever used a weapon in a fight?

	
	
	
	
	

	


/*	Fit a tetrachoric correlation using the variables listed below:

	alcohol truant vandalism theft weapon
	
	Describe the overall pattern of correlation between these variables?	
	
*/

	


/*	You are researching risky behaviours in adolescence using these five
	manifest variables.
	
	Spend a moment thinking about these variables. 
	
	Knowing what you know about adolescence, what latent class groups of 
	'risky behavious' do you theorise you might find?						*/
	
	
	
	
	
	

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

	
	

*	2 Class Model
	



*	3 Class Model



	
*	4 Class Model


	
	

	
	
/*	Compare the fit of these models. 

	Consider the entropy of these different models.

	Which is your preferred model? How did you come to this decision?		*/

	
	
	
	
	
	
/*	Using your preferred model, examine the marginal predicted means of
	each manifest item.														*/
	
	
	
	
	
	
	
/* 	Based on what you observe, what would you name each latent group?		*/
	


	
	
	
	
	
/*	Make a graph to illustrate the patterns of marginal predicted means 
	for your preferred model.												*/

	
	
	
	

	
	
********************************************************************************
**
**#	ALLOCATE INDIVIDUALS TO LATENT GROUPS
**
********************************************************************************	

/* 	Using your preferred model allocate the sample members to their most
	probable latent class.
	
	How many sample members fall in each of your latent class groups?		*/


	
	
	
	
	
	
	

	
********************************************************************************
**
**#	ANALYSE CLASS MEMBERSHIP
**
********************************************************************************	
	
/*	Run a multinomial logistic regression with your class membership variable	
	as the outcome (dependent) variable and 'age' and 'male' as your 
	explanatory variables.													*/
	
	help mlogit
	
	
	
	
*	What does this model tell you about the composition of your latent classes?

	
	
	
	
	
/*	If you had appropriate variables in your dataset you could use your
	latent class variable as an explanatory variable in further analysis.
	
	For example you might examine the association between risky adolescent 
	behaviours and completing secondary school, getting a criminal conviction, 
	becoming the victim of a crime, or adult unemployment.					*/
	

	
	
	
*	Well done, you can now undertake a latent class analysis!	
	
********************************************************************************
**#	END OF FILE	