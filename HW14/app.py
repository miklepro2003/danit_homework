from flask import Flask, request, jsonify
import csv

app = Flask(__name__)

CSV_FILE = "students.csv"


# чтение всех студентов из CSV
def read_students():

    students = []

    with open(CSV_FILE, "r", encoding="utf-8") as file:

        reader = csv.DictReader(file)

        for row in reader:
            students.append(row)

    return students


# запись всех студентов в CSV
def write_students(students):

    with open(CSV_FILE, "w", newline="", encoding="utf-8") as file:

        fieldnames = ["id", "name", "surname", "age"]

        writer = csv.DictWriter(file, fieldnames=fieldnames)

        writer.writeheader()

        for student in students:
            writer.writerow(student)


# GET все студенты
@app.route("/students", methods=["GET"])
def get_students():

    surname = request.args.get("surname")
    student_id = request.args.get("id")

    students = read_students()

    # поиск по ID
    if student_id:

        for student in students:

            if student["id"] == student_id:
                return jsonify(student)

        return jsonify({"error": "student not found"}), 404

    # поиск по фамилии
    if surname:

        result = []

        for student in students:

            if student["surname"] == surname:
                result.append(student)

        if len(result) == 0:
            return jsonify({"error": "surname not found"}), 404

        return jsonify(result)

    # вернуть всех
    return jsonify(students)


# POST создать студента
@app.route("/students", methods=["POST"])
def create_student():

    data = request.json

    allowed_fields = ["name", "surname", "age"]

    if not data:
        return jsonify({"error": "empty body"}), 400

    for key in data:

        if key not in allowed_fields:
            return jsonify({"error": "invalid field"}), 400

    for field in allowed_fields:

        if field not in data:
            return jsonify({"error": f"{field} is required"}), 400

    students = read_students()

    new_id = 1

    if len(students) > 0:
        new_id = int(students[-1]["id"]) + 1

    new_student = {
        "id": str(new_id),
        "name": data["name"],
        "surname": data["surname"],
        "age": str(data["age"])
    }

    students.append(new_student)

    write_students(students)

    return jsonify(new_student), 201


# PUT обновить полностью
@app.route("/students/<student_id>", methods=["PUT"])
def update_student(student_id):

    data = request.json

    allowed_fields = ["name", "surname", "age"]

    if not data:
        return jsonify({"error": "empty body"}), 400

    for key in data:

        if key not in allowed_fields:
            return jsonify({"error": "invalid field"}), 400

    for field in allowed_fields:

        if field not in data:
            return jsonify({"error": f"{field} is required"}), 400

    students = read_students()

    for student in students:

        if student["id"] == student_id:

            student["name"] = data["name"]
            student["surname"] = data["surname"]
            student["age"] = str(data["age"])

            write_students(students)

            return jsonify(student)

    return jsonify({"error": "student not found"}), 404


# PATCH обновить возраст
@app.route("/students/<student_id>", methods=["PATCH"])
def update_age(student_id):

    data = request.json

    if not data:
        return jsonify({"error": "empty body"}), 400

    if "age" not in data:
        return jsonify({"error": "age is required"}), 400

    if len(data) != 1:
        return jsonify({"error": "only age field allowed"}), 400

    students = read_students()

    for student in students:

        if student["id"] == student_id:

            student["age"] = str(data["age"])

            write_students(students)

            return jsonify(student)

    return jsonify({"error": "student not found"}), 404


# DELETE удалить студента
@app.route("/students/<student_id>", methods=["DELETE"])
def delete_student(student_id):

    students = read_students()

    new_students = []

    found = False

    for student in students:

        if student["id"] == student_id:
            found = True

        else:
            new_students.append(student)

    if not found:
        return jsonify({"error": "student not found"}), 404

    write_students(new_students)

    return jsonify({"message": "student deleted"})