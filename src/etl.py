from pathlib import Path
import pyodbc
from dotenv import load_dotenv
import os

load_dotenv()


def get_connection_string():
    server = os.getenv("DB_SERVER")
    database = os.getenv("DB_DATABASE")
    username = os.getenv("DB_USERNAME")
    password = os.getenv("DB_PASSWORD")

    return (
        f"DRIVER={{ODBC Driver 17 for SQL Server}};"
        f"SERVER={server};"
        f"DATABASE={database};"
        f"UID={username};"
        f"PWD={password}"
    )


def execute_sql_script(script_path):
    if not script_path:
        print("Ruta nula")
        return

    try:
        connection_string = get_connection_string()
        with pyodbc.connect(connection_string) as conn, conn.cursor() as cursor, open(
            script_path, "r", encoding="utf_8"
        ) as file:
            sql_statements = file.read().split(";")
            execute_statements(cursor, sql_statements)
            conn.commit()
            print("Todos los scripts se ejecutaron correctamente.")
    except Exception as e:
        print(f"Ocurrió un error: {e}")


def execute_statements(cursor, sql_statements):
    for statement in map(str.strip, sql_statements):
        if statement:
            cursor.execute(statement)
            print_results(cursor)


def print_results(cursor):
    if cursor.description:
        columns = [column[0] for column in cursor.description]
        print(" | ".join(columns))
        print("-" * 50)
        for row in cursor.fetchall():
            print(" | ".join(str(value) for value in row))
        print("-" * 50)


def get_script_paths():
    menu_extract = """
1. Script para Borrar Modelo
2. Script para Crear Modelo
3. Script para Cargar Información
4. Script para Consultas
5. Salir
"""
    paths = {
        "delete_model": None,
        "create_model": None,
        "load_info": None,
        "queries": None,
    }

    while True:
        print(menu_extract)
        try:
            option = int(input("Selecciona una opción: "))
            if option in range(1, 5):
                script_path = Path(input("/> ")).resolve()
                print(script_path)
                if option == 1:
                    paths["delete_model"] = script_path
                elif option == 2:
                    paths["create_model"] = script_path
                elif option == 3:
                    paths["load_info"] = script_path
                elif option == 4:
                    paths["queries"] = script_path
            elif option == 5:
                return paths
        except ValueError:
            print("Opción no válida")
            continue


def main():
    script_paths = {
        "delete_model": None,
        "create_model": None,
        "load_info": None,
        "queries": None,
    }

    menu_main = """
1. Borrar Modelo
2. Crear Modelo
3. Extraer Información
4. Cargar Información
5. Consultas
6. Salir
"""
    while True:
        print(menu_main)
        try:
            option = int(input("Selecciona una opción: "))
            if option == 1:
                execute_sql_script(script_paths["delete_model"])
            elif option == 2:
                execute_sql_script(script_paths["create_model"])
            elif option == 3:
                script_paths = get_script_paths()
            elif option == 4:
                execute_sql_script(script_paths["load_info"])
            elif option == 5:
                execute_sql_script(script_paths["queries"])
            elif option == 6:
                break
        except ValueError:
            print("Opción inválida")
            continue


if __name__ == "__main__":
    main()
