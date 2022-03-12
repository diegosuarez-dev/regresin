Feature: Karate API technical test - Register scenarios

	Scenario: Verifying post register unsuccessful
		* def payload = read("../testData/registerPostUnsuccessfulRequest.json")
		* def expectedResponse = read("../testData/registerPostUnsuccessfulResponse.json")
		Given url "https://reqres.in/api/"
		And path "register"
		And request payload
		When method post
		Then status 400
		
		# Assertions
		And match response == expectedResponse
		And match response.id == "#notpresent"
		And match response.token == "#notpresent"
		