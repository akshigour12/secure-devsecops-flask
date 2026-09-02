import pytest
from app import app


@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


def test_home_page(client):
    response = client.get("/")
    assert response.status_code == 200


def test_login_page(client):
    response = client.get("/login")
    assert response.status_code == 200


def test_about_page(client):
    response = client.get("/about")
    assert response.status_code == 200


def test_contact_page(client):
    response = client.get("/contact")
    assert response.status_code == 200


def test_dashboard_page(client):
    response = client.get("/dashboard")
    assert response.status_code == 200


def test_health_endpoint(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json["status"] == "UP"


def test_404_page(client):
    response = client.get("/invalid-page")
    assert response.status_code == 404
