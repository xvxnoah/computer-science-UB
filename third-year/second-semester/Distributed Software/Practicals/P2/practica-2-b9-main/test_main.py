from fastapi.testclient import TestClient

from main import app
from schemas import *

client = TestClient(app)


def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Hello World"}


# METHOD TO DELETE TEAMS CREATED FOR TESTING
def delete_team_by_name(team_name: str):
    response = client.delete(f"/teams/{team_name}")
    assert response.status_code == 200
    assert response.json()["name"] == team_name


# METHOD TO DELETE COMPETITIONS CREATED FOR TESTING
def delete_competition_by_id(competition_id: int):
    response = client.delete(f"/competitions/{competition_id}")
    assert response.status_code == 200


# METHOD TO DELETE COMPETITIONS CREATED FOR TESTING
def delete_competition_by_name(competition_name: str):
    response = client.delete(f"/competitions/{competition_name}")
    assert response.status_code == 200


# METHOD TO DELETE MATCHES CREATED FOR TESTING
def delete_match_by_id(match_id: int):
    response = client.delete(f"/matches/{match_id}")
    assert response.status_code == 200


# TEST GET TEAMS ENDPOINT
def test_read_teams():
    response = client.get("/teams/")
    assert response.status_code == 200
    assert isinstance(response.json(), list)


def test_create_team():
    new_team = {
        "name": "Joanenc",
        "country": "Spain"
    }
    response = client.post("/teams/", json=new_team)
    assert response.status_code == 200
    assert response.json()["name"] == "Joanenc"


# TEST GET /teams/{team_name}/competitions
def test_get_team_competitions():
    team_name = "Joanenc"

    response = client.get(f"/team/{team_name}")
    team_id = response.json()["id"]
    team_country = response.json()["country"]

    team_to_add = Team(name=team_name, country=team_country, id=team_id)

    competition_data = {"name": "Primera Catalana", "category": "Senior", "sport": "Football",
                        "teams": [team_to_add.dict()]}

    # Create a competition for testing
    response = client.post("/competitions/", json=competition_data)
    competition_id = response.json()["id"]

    response = client.get(f"/teams/{team_name}/competitions")
    assert response.status_code == 200
    assert len(response.json()["competitions"]) > 0

    # Delete the competition created for testing
    delete_competition_by_id(competition_id)


# TEST GET TEAM_NAME ENDPOINT
def test_read_team():
    team_name = "Joanenc"

    response = client.get(f"/team/{team_name}")
    assert response.status_code == 200
    assert response.json()["name"] == team_name

    # Delete team created for testing
    delete_team_by_name("Joanenc")


def test_create_team2():
    team_data = {"name": "Logica i LLenguatges", "country": "UB", "description": "Maths team"}
    response = client.post("/teams/", json=team_data)
    assert response.status_code == 200
    assert response.json()["name"] == "Logica i LLenguatges"
    assert response.json()["country"] == "UB"
    assert response.json()["description"] == "Maths team"

    # Delete team created for testing
    delete_team_by_name("Logica i LLenguatges")


# TEST DELETE TEAM ENDPOINT
def test_delete_team():
    team_name = "Madrid"
    team_to_delete = {
        "name": "Madrid",
        "country": "Spain"
    }
    response = client.post("/teams/", json=team_to_delete)

    response = client.delete(f"/teams/{team_name}")
    assert response.status_code == 200
    assert response.json()["name"] == team_name


# TEST PUT TEAM ENDPOINT
def test_update_or_create_team():
    # We first create a team to update
    team_name = "Alicante"
    team_info = {
        "name": "Alicante",
        "country": "Spain"
    }

    response = client.post("/teams/", json=team_info)

    team_id = response.json()["id"]

    updated_team = Team(name="Alicante", country="France", id=team_id)
    response = client.put(f"/teams/{team_name}", json=updated_team.dict())

    assert response.status_code == 200
    assert response.json()["country"] == "France"

    # Delete team created for testing
    delete_team_by_name("Alicante")


# TEST GET COMPETITION ENDPOINT
def test_get_competitions():
    response = client.get("/competitions/")
    assert response.status_code == 200


# TEST POST COMPETITION ENDPOINT
def test_create_competition_without_teams():
    competition_data = {"name": "Test Competition", "category": "Senior", "sport": "Football"}
    response = client.post("/competitions/", json=competition_data)
    assert response.status_code == 200
    assert response.json()["name"] == "Test Competition"
    assert response.json()["category"] == "Senior"
    assert response.json()["sport"] == "Football"

    # Delete competition created for testing
    competition_id = response.json()["id"]
    delete_competition_by_id(competition_id)


def test_create_competition_with_teams():
    # We first create a team to add to the competition
    team_info = {
        "name": "Porcinos",
        "country": "Spain",
        "description": "Team of pigs"
    }

    response = client.post("/teams/", json=team_info)
    team_id = response.json()["id"]

    team_to_add = Team(name="Porcinos", country="Spain", description="Team of pigs", id=team_id)

    competition_data = {"name": "Test Competition", "category": "Senior", "sport": "Football",
                        "teams": [team_to_add.dict()]}

    response = client.post("/competitions/", json=competition_data)
    assert response.status_code == 200
    assert response.json()["name"] == "Test Competition"
    assert response.json()["category"] == "Senior"
    assert response.json()["sport"] == "Football"
    assert response.json()["teams"][0]["name"] == "Porcinos"

    # Delete the team created for testing
    delete_team_by_name("Porcinos")

    # Delete competition created for testing
    competition_id = response.json()["id"]

    delete_competition_by_id(competition_id)


# TEST GET /competitions/{competition_name}/matches
def test_get_competition_matches():
    # We first create two teams to add to the match
    team_1 = {"name": "Test 1",
              "country": "Country 1",
              "description": "Test Team 1"
              }

    team_2 = {"name": "Test 2",
              "country": "Country 2",
              "description": "Test Team 2"
              }

    response = client.post("/teams/", json=team_1)
    team_1_id = response.json()["id"]

    response = client.post("/teams/", json=team_2)
    team_2_id = response.json()["id"]

    team_1_to_add = Team(name="Test 1", country="Country 1", description="Test Team 1", id=team_1_id)
    team_2_to_add = Team(name="Test 2", country="Country 2", description="Test Team 2", id=team_2_id)

    # We then create a competition to add to the match
    competition_data = {"name": "Test Competition", "category": "Senior", "sport": "Football",
                        "teams": [team_1_to_add.dict(), team_2_to_add.dict()]}

    response = client.post("/competitions/", json=competition_data)
    competition_id = response.json()["id"]

    match_data = {
        "date": "2023-06-30T12:00:00Z",
        "price": 10.0,
        "local": team_1_to_add.dict(),
        "visitor": team_2_to_add.dict(),
        "competition": {
            "id": competition_id,
            "name": "Test Competition",
            "category": "Senior",
            "sport": "Football",
            "teams": [team_1_to_add.dict(), team_2_to_add.dict()]
        }
    }

    response = client.post("/matches/", json=match_data)
    match_id = response.json()["id"]

    # Test getting matches for the competition
    response = client.get(f"/competitions/{competition_data['name']}/matches")
    assert response.status_code == 200
    matches = response.json()
    assert len(matches) == 1

    # Delete competition created for testing
    delete_competition_by_id(competition_id)

    # Delete the teams created for testing
    delete_team_by_name("Test 1")
    delete_team_by_name("Test 2")

    # Delete the match created for testing
    delete_match_by_id(match_id)


# TEST GET /competitions/{competition_name}/teams
def test_get_competition_teams():
    # We first create a team to add to the competition
    team_info = {
        "name": "FC Barcelona",
        "country": "Spain",
        "description": "Un dia de partit"
    }

    response = client.post("/teams/", json=team_info)
    team_id = response.json()["id"]

    team_to_add = Team(name="FC Barcelona", country="Spain", description="Un dia de partit", id=team_id)

    competition_name = "Test Competition"
    competition_data = {"name": competition_name, "category": "Senior", "sport": "Football",
                        "teams": [team_to_add.dict()]}

    # First we create the competition
    response = client.post("/competitions/", json=competition_data)

    # And then we get the teams
    response2 = client.get(f"/competitions/{competition_name}/teams")
    assert response2.status_code == 200
    assert len(response2.json()["teams"]) > 0

    # Delete the team created for testing
    delete_team_by_name("FC Barcelona")

    # Delete competition created for testing
    competition_id = response.json()["id"]

    delete_competition_by_id(competition_id)


# TEST DELETE COMPETITION ENDPOINT
def test_delete_competition():
    competition_data = {"name": "Sample Competition", "category": "Junior", "sport": "Volleyball",
                        "teams": []}

    # Create a competition first
    response = client.post("/competitions/", json=competition_data)

    competition_id = response.json()["id"]

    response = client.delete(f"/competitions/{competition_id}")
    assert response.status_code == 200
    assert response.json()["name"] == "Sample Competition"


# TEST PUT COMPETITION ENDPOINT
def test_update_competition():
    # Create a competition first
    competition_data = {"name": "Sample Competition", "category": "Junior", "sport": "Volleyball",
                        "teams": []}

    response = client.post("/competitions/", json=competition_data)

    competition_id = response.json()["id"]

    updated_competition = {"id": competition_id, "name": "Updated Competition", "category": "Senior",
                           "sport": "Football",
                           "teams": []}
    response = client.put(f"/competitions/{competition_id}", json=updated_competition)
    assert response.status_code == 200
    assert response.json()["name"] == "Updated Competition"

    # Delete competition created for testing
    delete_competition_by_id(competition_id)


# TEST GET MATCH ENDPOINT
def test_get_matches():
    response = client.get("/matches/")
    assert response.status_code == 200


# TEST POST MATCH ENDPOINT
def test_create_match():
    # We first create two teams to add to the match
    team_1 = {"name": "Team 1",
              "country": "Country 1",
              "description": "Test Team 1"
              }

    team_2 = {"name": "Team 2",
              "country": "Country 2",
              "description": "Test Team 2"
              }

    response = client.post("/teams/", json=team_1)
    team_1_id = response.json()["id"]

    response = client.post("/teams/", json=team_2)
    team_2_id = response.json()["id"]

    team_1_to_add = Team(name="Team 1", country="Country 1", description="Test Team 1", id=team_1_id)
    team_2_to_add = Team(name="Team 2", country="Country 2", description="Test Team 2", id=team_2_id)

    # We then create a competition to add to the match
    competition_data = {"name": "Test Competition", "category": "Senior", "sport": "Football",
                        "teams": [team_1_to_add.dict(), team_2_to_add.dict()]}

    response = client.post("/competitions/", json=competition_data)
    competition_id = response.json()["id"]

    match_data = {
        "date": "2023-06-30T12:00:00Z",
        "price": 10.0,
        "local": team_1_to_add.dict(),
        "visitor": team_2_to_add.dict(),
        "competition": {
            "id": competition_id,
            "name": "Test Competition",
            "category": "Senior",
            "sport": "Football",
            "teams": [team_1_to_add.dict(), team_2_to_add.dict()]
        }
    }

    response = client.post("/matches/", json=match_data)

    print(response.json())
    assert response.status_code == 200
    assert response.json()["date"] + "Z" == match_data["date"]
    assert response.json()["price"] == match_data["price"]
    assert response.json()["local"] == match_data["local"]
    assert response.json()["visitor"] == match_data["visitor"]
    assert response.json()["competition"] == match_data["competition"]


# TEST GET MATCH ENDPOINT (ID)
def test_get_match():
    # We obtain the match that have created before
    response = client.get("/matches/1")
    assert response.status_code == 200


# TEST GET /matches/{match_id}/teams
def test_get_match_teams():
    # We obtain the teams of the match that have created before
    match_id = 1
    response = client.get(f"/matches/{match_id}/teams")
    assert response.status_code == 200
    assert "local" in response.json() and "visitor" in response.json()


# TEST GET /matches/{match_id}/competition
def test_get_match_competition():
    # We obtain the competition of the match that have created before
    match_id = 1
    response = client.get(f"/matches/{match_id}/competition")
    assert response.status_code == 200
    assert "competition" in response.json()


# TEST PUT MATCH ENDPOINT
def test_update_match():
    response = client.get(f"/matches/{1}")
    match_id = response.json()["id"]
    match_team_1 = response.json()["local"]
    match_team_2 = response.json()["visitor"]
    match_competition = response.json()["competition"]

    updated_match_data = {
        "date": "2023-05-30T12:00:00Z",
        "price": 70.0,
        "local": match_team_1,
        "visitor": match_team_2,
        "competition": match_competition,
        "id": match_id
    }

    response = client.put(f"/matches/{match_id}", json=updated_match_data)

    assert response.status_code == 200
    assert response.json()["local"] == match_team_1
    assert response.json()["visitor"] == match_team_2
    assert response.json()["date"] + "Z" == "2023-05-30T12:00:00Z"
    assert response.json()["price"] == 70.0


# TEST DELETE MATCH ENDPOINT
def test_delete_match():
    match_id = 1
    response = client.get(f"/matches/{match_id}")

    # Delete match created for testing
    match_id = response.json()["id"]

    response = client.delete(f"/matches/{match_id}")
    assert response.status_code == 200

    # Delete competition created for testing
    delete_competition_by_name("1")

    # Delete the teams created for testing
    delete_team_by_name("Team 1")
    delete_team_by_name("Team 2")

def test_create_match_s4():
    # We first get two teams to add to the match
    team_name1 = "Manchester City"
    team_name2 = "Real Madrid"

    response1 = client.get(f"/team/{team_name1}")
    response2 = client.get(f"/team/{team_name2}")

    team_1_to_add = Team(name=response1.json()["name"], country=response1.json()["country"], description=response1.json()["description"], id=response1.json()["id"])
    team_2_to_add = Team(name=response2.json()["name"], country=response2.json()["country"], description=response2.json()["description"], id=response2.json()["id"])

    # We then create a competition to add to the match
    competition_data = {"name": "ChampionsLeague", "category": "Senior", "sport": "Futsal",
                        "teams": [team_1_to_add.dict(), team_2_to_add.dict()]}

    response = client.post("/competitions/", json=competition_data)
    competition_id = response.json()["id"]

    match_data = {
        "date": "2023-05-17T21:00:00Z",
        "price": 25.0,
        "local": team_1_to_add.dict(),
        "visitor": team_2_to_add.dict(),
        "competition": {
            "id": competition_id,
            "name": "ChampionsLeague",
            "category": "Senior",
            "sport": "Futsal",
            "teams": [team_1_to_add.dict(), team_2_to_add.dict()]
        },
        "total_available_tickets": 50,
    }

    response = client.post("/matches/", json=match_data)

    assert response.status_code == 200
    assert response.json()["date"] + "Z" == match_data["date"]
    assert response.json()["price"] == match_data["price"]
    assert response.json()["local"] == match_data["local"]
    assert response.json()["visitor"] == match_data["visitor"]
    assert response.json()["competition"] == match_data["competition"]
