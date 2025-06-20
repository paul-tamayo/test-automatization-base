Feature: Prueba de automatización de endpoints con Karate Framework

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/diego-tamayo'
    * def character = { "id": '#number', "name": '#string', "alterego": '#string', "description": '#string', "powers": '#array' }
    * configure ssl = true

  Scenario: Crear un nuevo personaje
    # Crear un personaje
    Given path '/api/characters'
    And request {name : "Iron Man", alterego: "Tony Stark", description: "Genius billionaire", powers: ["Armor", "Flight"]}
    When method POST
    Then status 201

    # Listar todos los personajes
    Given path '/api/characters'
    When method GET
    Then status 200
    And match response == '#[]'
    And match each response == character