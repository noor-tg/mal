
## Domain
- categories
- bloc
	- events
		- on app init : load all categories
	- state
		- categories
	- providers (on top level app)
		- on app init load all categories

## data
- sql data source
- sql repository

## UI
- screen
	- list

## tests
- data
	- sql find
		- fetch related categories list
		- count related categories count
	- repository
		- return correct result (list, count)