/*			Part I � Queries for Gringotts Database			*/

SELECT * FROM WizzardDeposits

/*
1. Records' Count
Import the database and send the total count of records from the one and only table to Mr. Bodrog. Make sure nothing gets lost.
Example

		Count
		162

*/

SELECT COUNT(Id) AS [Count] FROM WizzardDeposits


/*
2. Longest Magic Wand
Select the size of the longest magic wand. Rename the new column appropriately.
Example

		LongestMagicWand
			  31
*/


SELECT MAX(MagicWandSize)AS [LongestMagicWand] FROM WizzardDeposits


/*
3. Longest Magic Wand Per Deposit Groups
For wizards in each deposit group show the longest magic wand. Rename the new column appropriately.
Example

			DepositGroup	LongestMagicWand
			Blue Phoenix		  31

*/

SELECT DepositGroup, MAX(MagicWandSize)AS [LongestMagicWand] FROM WizzardDeposits
GROUP BY DepositGroup

/*
4. Smallest Deposit Group Per Magic Wand Size
Select the two deposit groups with the lowest average wand size.
Example

	DepositGroup
	Troll Chest
	Venomous Tongue

*/

SELECT TOP 2 DepositGroup FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

/*
5. Deposits Sum
Select all deposit groups and their total deposit sums.
Example

	DepositGroup	TotalSum
	Blue Phoenix	819598.73
	 Human Pride	1041291.52

*/

SELECT w.DepositGroup, SUM(w.DepositAmount) AS TotalSum FROM WizzardDeposits AS w
GROUP BY w.DepositGroup

/*
6. Deposits Sum for Ollivander Family
Select all deposit groups and their total deposit sums, but only for the wizards, who have their magic wands crafted by the Ollivander family.
Example

	DepositGroup	TotalSum
	Blue Phoenix	52968.96
	Human Pride	188366.86

*/

SELECT w.DepositGroup, SUM(w.DepositAmount) AS TotalSum FROM WizzardDeposits AS w
WHERE w.MagicWandCreator = 'Ollivander family'
GROUP BY w.DepositGroup

/*
7. Deposits Filter
Select all deposit groups and their total deposit sums, but only for the wizards, who have their magic wands crafted by the Ollivander family. 
Filter total deposit amounts lower than 150000. Order by total deposit amount in descending order.
Example

		DepositGroup	TotalSum
		Troll Chest		126585.18
*/

SELECT w.DepositGroup, SUM(w.DepositAmount) AS TotalSum FROM WizzardDeposits AS w
WHERE w.MagicWandCreator = 'Ollivander family'
GROUP BY w.DepositGroup
HAVING SUM(w.DepositAmount) < 150000
ORDER BY SUM(w.DepositAmount) DESC

/*
8. Deposit Charge
Create a query that selects:
�	Deposit group 
�	Magic wand creator
�	Minimum deposit charge for each group 
Select the data in ascending order by MagicWandCreator and DepositGroup.
Example

	DepositGroup		MagicWandCreator		MinDepositCharge
	Blue Phoenix		Antioch Peverell		30.00
*/

SELECT w.DepositGroup, w.MagicWandCreator, MIN(w.DepositCharge) AS TotalSum FROM WizzardDeposits AS w
GROUP BY w.DepositGroup, w.MagicWandCreator
ORDER BY w.MagicWandCreator, w.DepositGroup


/*
9. Age Groups
Write down a query that creates 7 different groups based on their age.
Age groups should be as follows:
�	[0-10]
�	[11-20]
�	[21-30]
�	[31-40]
�	[41-50]
�	[51-60]
�	[61+]

The query should return
�	Age groups
�	Count of wizards in it
Example

	AgeGroup	WizardCount
	[11-20]			21

*/

WITH AgeGrouped AS ( -- Common Table Expression --
    SELECT 
        CASE
            WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
            WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
            WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
            WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
            WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
            WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
            WHEN Age >= 61 THEN '[61+]'
        END AS AgeGroup
    FROM WizzardDeposits
)
SELECT AgeGroup, COUNT(*) AS WizardCount
FROM AgeGrouped
GROUP BY AgeGroup
ORDER BY AgeGroup;

/*
10. First Letter
Create a query that returns all the unique wizard first letters of their first names only if they have deposit of type Troll Chest. 
Order them alphabetically. Use GROUP BY for uniqueness.

Example

		FirstLetter
			A
			�
*/

SELECT LEFT(FirstName, 1) AS FirstLetter
FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
GROUP BY LEFT(FirstName, 1)
ORDER BY FirstLetter

/*
11. Average Interest 
Mr. Bodrog is highly interested in profitability. He wants to know the average interest of all deposit groups, split by whether the deposit has expired or not. 
But that's not all. He wants you to select deposits with start date after 01/01/1985. Order the data descending by Deposit Group and ascending by Expiration Flag.

The output should consist of the following columns:
Example

			DepositGroup		IsDepositExpired		AverageInterest
			Venomous Tongue				0					16.698947
*/


SELECT w.DepositGroup, w.IsDepositExpired, AVG(w.DepositInterest) AS AverageInterest FROM WizzardDeposits AS w
WHERE w.DepositStartDate > '1985-01-01'
GROUP BY w.DepositGroup, w.IsDepositExpired
ORDER BY w.DepositGroup DESC, w.IsDepositExpired

/*
12. *Rich Wizard, Poor Wizard
Mr. Bodrog definitely likes his werewolves more than you. This is your last chance to survive! Give him some data to play his favorite game Rich Wizard, Poor Wizard. 
The rules are simple: 
You compare the deposits of every wizard with the wizard after him. 
If a wizard is the last one in the database, simply ignore it. 
In the end you have to sum the difference between the deposits.

	Host Wizard			Host Wizard Deposit	Guest Wizard	Guest Wizard Deposit	Difference
		Harry			10 000					Tom				12 000					-2000
		Tom				12 000					....			.......					......

At the end your query should return a single value: the SUM of all differences.

*/

SELECT * FROM WizzardDeposits

SELECT 
    SUM(DepositAmount - NextWizardDeposit) AS SumDifference
FROM (
    SELECT 
        DepositAmount, 
        LEAD(DepositAmount) OVER (ORDER BY id) AS NextWizardDeposit
    FROM WizzardDeposits
) SUBQUERY
WHERE NextWizardDeposit IS NOT NULL;