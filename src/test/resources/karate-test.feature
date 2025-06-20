Feature: Prueba de automatización de endpoints con Karate Framework

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/diego-tamayo'
    * def character = { "id": '#number', "name": '#string', "alterego": '#string', "description": '#string', "powers": '#array' }
    * configure ssl = true

  #Scenario: Crear un nuevo personaje
  #  Given path '/api/characters'
  # And request {name : "Iron Man", alterego: "Tony Stark", description: "Genius billionaire", powers: ["Armor", "Flight"]}
  # When method POST
  # Then status 201
  # And match response == character
  # And match response.id == '#number'


  Scenario: Verificación para obtener todos los personajes
    Given path '/api/characters'
    When method GET
    Then status 200
    And match response == '#[]'
    And match each response == character

  Scenario: Verificar el ciclo de vida de un personaje
    # Creación del persona de Superman
    Given path '/api/characters'
    And request {name : "Superman", alterego: "Clark Kent", description: "Hijo de cripton", powers: ["Fuerza", "Volar"]}
    When method POST
    Then status 201
    And match response == character
    * def characterId = response.id

    # Obtener el personaje de Superman creado
    Given path '/api/characters', characterId
    When method GET
    Then status 200
    And match response == character
    And match response.id == characterId
    And match response.name == "Superman"
    And match response.alterego == "Clark Kent"
    And match response.description == "Hijo de cripton"
    And match response.powers == ["Fuerza", "Volar"]

    # Actualizar el personaje de Superman
    Given path '/api/characters', characterId
    And request {name : "Superman", alterego: "Clark Kent", description: "Hijo de cripton", powers: ["Fuerza", "Volar", "Visión de rayos X"]}
    When method PUT
    Then status 200
    And match response == character
    And match response.id == characterId
    And match response.powers == ["Fuerza", "Volar", "Visión de rayos X"]

    # Eliminar el personaje de Superman
    Given path '/api/characters', characterId
    When method DELETE
    Then status 204
