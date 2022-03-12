Feature: Karate API technical test - Users scenarios

	Background:
		* def requiredId = 11
		* def pageNumber = 2
		Given url "https://reqres.in/api/"
		And path "users"

	Scenario: Verifying get list and retrieving user with required id		
		And param page = pageNumber
		When method get
		Then status 200
		
		# Assertions
		And match response.page == pageNumber
		And match response.data == "#array"
		And match response.data contains deep {"id": "#(requiredId)"}
		
		# Extracting object of id = 11
		* def temp = karate.jsonPath(response, "$.data[?(@.id==" + requiredId + ")]")
		* match temp[0].id == requiredId
		
	Scenario: Verifying get single user with required id + bonus: comparing with user from get list
		Given path requiredId
		When method get
		Then status 200
		
		# Assertions		
		And match response.data == "#object"
		And match response.data.id == requiredId
		And match response.data.email == "#present"
		And match response.data.first_name == "#present"
		And match response.data.last_name == "#present"
		And match response.data.avatar == "#present"		
		
		# Bonus: Checking that the get single user sends the same user as get users list. 
		# I added bonus to this scenario cause it is a nice extra check for testing get
		# single user request and to avoid duplicating code in a bonus separate scenario
		* def temp = response.data
		Given path "users"
		And param page = pageNumber
		When method get
		Then status 200
		And match response.data contains deep temp
		
	Scenario: Verifying post create user
		* def payload = read("../testData/userPostRequest.json")
		* def responseSchema = read("../testData/postResponseSchema.json")
		Given request payload
		When method post
		Then status 201
		
		# Assertions
		And match response.id == "#present"
		And match response.createdAt == "#present"
		And match response == responseSchema
		And match response contains payload
		* print response
		
		# The API doesn't persist newly created users, so it fails, but I would definitely check if
		# I can get the new user with get single user method. In this case, API response status is
		# 404 and this is why I commented the following code
		
		# Checking that we can retrieve the new user
		# * def createdUserId = response.id
		# Given path "users/" + createdUserId
		# When method get
		# Then status 200
		# And match response.data contains payload
		