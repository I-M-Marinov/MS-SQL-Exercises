/*			Part I – Queries for Gringotts Database			*/

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

