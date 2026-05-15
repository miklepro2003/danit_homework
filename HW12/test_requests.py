import requests

BASE_URL = "http://127.0.0.1:5000/students"


def save_result(title, response):

    text = f"\n{title}\n"
    text += f"STATUS: {response.status_code}\n"
    text += f"BODY: {response.text}\n"

    print(text)

    with open("results.txt", "a", encoding="utf-8") as file:
        file.write(text)


# очистка файла результатов
with open("results.txt", "w", encoding="utf-8") as file:
    file.write("REST API TEST RESULTS\n")


# GET все студенты
resp = requests.get(BASE_URL)
save_result("GET ALL STUDENTS", resp)


# POST студент 1
resp = requests.post(
    BASE_URL,
    json={
        "name": "Ivan",
        "surname": "Petrov",
        "age": 20
    }
)
save_result("CREATE STUDENT 1", resp)


# POST студент 2
resp = requests.post(
    BASE_URL,
    json={
        "name": "Anna",
        "surname": "Ivanova",
        "age": 21
    }
)
save_result("CREATE STUDENT 2", resp)


# POST студент 3
resp = requests.post(
    BASE_URL,
    json={
        "name": "Max",
        "surname": "Sidorov",
        "age": 22
    }
)
save_result("CREATE STUDENT 3", resp)


# GET все студенты
resp = requests.get(BASE_URL)
save_result("GET ALL STUDENTS", resp)


# PATCH возраст второго
resp = requests.patch(
    f"{BASE_URL}/2",
    json={
        "age": 30
    }
)
save_result("PATCH STUDENT 2", resp)


# GET второй студент
resp = requests.get(f"{BASE_URL}?id=2")
save_result("GET STUDENT 2", resp)


# PUT третий студент
resp = requests.put(
    f"{BASE_URL}/3",
    json={
        "name": "Alex",
        "surname": "Brown",
        "age": 40
    }
)
save_result("PUT STUDENT 3", resp)


# GET третий студент
resp = requests.get(f"{BASE_URL}?id=3")
save_result("GET STUDENT 3", resp)


# GET все студенты
resp = requests.get(BASE_URL)
save_result("GET ALL STUDENTS", resp)


# DELETE первый студент
resp = requests.delete(f"{BASE_URL}/1")
save_result("DELETE STUDENT 1", resp)


# GET все студенты
resp = requests.get(BASE_URL)
save_result("GET ALL STUDENTS", resp)