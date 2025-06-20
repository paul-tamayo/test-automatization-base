Feature: Prueba de automatización de endpoints con Karate Framework

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/diego-tamayo'
    * def character = { "id": '#number', "name": '#string', "alterego": '#string', "description": '#string', "powers": '#array' }
    * configure ssl = true

  Scenario: Verificación para obtener todos los personajes
    Given path '/api/characters'
    When method GET
    Then status 200
    And match response == '#[]'
    * if (response.length == 0) {      karate.call('classpath:create-character.feature')    }

  Scenario: Verificar el ciclo de vida de un personaje
    # Creación del personaje de Scarlet Witch
    Given path '/api/characters'
    And request {name : "Scarlet Witch", alterego: "Wanda Maximoff", description: "Poderosa mutante con habilidades mágicas y de alteración de la realidad.", powers: ["Fuerza", "Alteración de la realidad"]}
    When method POST
    Then status 201
    And match response == character
    * def characterId = response.id

    # Obtener el personaje de Scarlet Witch creado
    Given path '/api/characters', characterId
    When method GET
    Then status 200
    And match response == character
    And match response.id == characterId
    And match response.name == "Scarlet Witch"
    And match response.alterego == "Wanda Maximoff"
    And match response.description == "Poderosa mutante con habilidades mágicas y de alteración de la realidad."
    And match response.powers == ["Fuerza", "Alteración de la realidad"]

    # Actualizar el personaje de Scarlet Witch
    Given path '/api/characters', characterId
    And request {name : "Scarlet Witch", alterego: "Wanda Maximoff", description: "Habilidades mágicas", powers: ["Fuerza", "Alteración de la realidad", "Visión de rayos X"]}
    When method PUT
    Then status 200
    And match response == character
    And match response.id == characterId
    And match response.powers == ["Fuerza", "Alteración de la realidad", "Visión de rayos X"]

    # Eliminar el personaje de Scarlet Witch
    Given path '/api/characters', characterId
    When method DELETE
    Then status 204

  Scenario: Verificar que el personaje del Captain America una vez eliminado ya no exista
    # Creación del personaje del Captain America
    Given path '/api/characters'
    And request {name : "Captain America ", alterego: "Steve Rogers", description: "Súper soldado con escudo indestructible.", powers: ["Fuerza", "Chipote Chillón"]}
    When method POST
    Then status 201
    * def characterId = response.id

    # Eliminar el personaje del Captain America
    Given path '/api/characters', characterId
    When method DELETE
    Then status 204

    # Eliminar el personaje del Captain America nuevamente para verificar que no existe
    Given path '/api/characters', characterId
    When method DELETE
    Then status 404

  Scenario: Verificar que el personaje de Ant-Man no se crea por campos faltantes
    Given path '/api/characters'
    And request {name : "Ant-Man", alterego: "Scott Lang"}
    When method POST
    Then status 400
    And match response == {"powers": "Powers are required","description": "Description is required"}

  Scenario: Obtener un personaje que no existe
    Given path '/api/characters', 999999999
    When method GET
    Then status 404
    And match response == {"error": "Character not found"}

  Scenario: Enviando a generar un error 500 para verificar el manejo de errores
    Given path '/api/characters', 999999999999999999999999999999999
    When method GET
    Then status 500
    And match response == {"error": "Internal server error"}

  Scenario: Actualizar un personaje que no existe
    Given path '/api/characters/999999999'
    And request {name : "Scarlet Witch", alterego: "Wanda Maximoff", description: "Habilidades mágicas", powers: ["Fuerza", "Alteración de la realidad", "Visión de rayos X"]}
    When method PUT
    Then status 404
    And match response == {"error": "Character not found"}
