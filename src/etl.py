from pathlib import Path
import pyodbc

# Configuración de la conexión a SQL Server
server = "localhost"
database = "etl_practica1"
username = "sa"
password = "BaseDatos2+"
connection_string = (
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER={server};"
    f"DATABASE={database};"
    f"UID={username};"
    f"PWD={password}"
)


# Función para ejecutar un script SQL
def execute_sql_script(script_path):
    try:
        # Validar path
        if script_path is None:
            print("Ruta nula")
            return
        # Crear una conexión a la base de datos
        with pyodbc.connect(connection_string) as conn:
            # Crear un cursor
            with conn.cursor() as cursor:
                # Ejecutar cada script
                with open(script_path, "r", encoding="utf_8") as file:
                    sql_script = file.read()
                    sql_statements = sql_script.split(";")
                    for statement in sql_statements:
                        fixed_statement = statement.strip()
                        if fixed_statement:
                            cursor.execute(fixed_statement)
                            if cursor.description:
                                columns = [column[0] for column in cursor.description]
                                print(" | ".join(columns))
                                print("-" * 50)
                                rows = cursor.fetchall()
                                for row in rows:
                                    print(" | ".join(str(value) for value in row))
                                print("-" * 50)
                conn.commit()
                print("Todos los scripts se ejecutaron correctamente.")
    except Exception as e:
        # Manejo de errores
        print(f"Ocurrió un error: {e}")


def extract_info(delete_model_sql, create_model_sql, load_info_sql, queries_sql):
    menu_extract_str: str = """
1. Script para Borrar Modelo
2. Script para Crear Modelo
3. Script para Cargar Informacion
4. Script para Consultas
5. Salir
"""
    while True:
        print(menu_extract_str)
        try:
            match int(input("Selecciona una opcion: ")):
                case 1:
                    delete_model_sql = Path(input("/> ")).resolve()
                    print(delete_model_sql)
                case 2:
                    create_model_sql = Path(input("/> ")).resolve()
                    print(create_model_sql)
                case 3:
                    load_info_sql = Path(input("/> ")).resolve()
                    print(load_info_sql)
                case 4:
                    queries_sql = Path(input("/> ")).resolve()
                    print(queries_sql)
                case 5:
                    return (
                        delete_model_sql,
                        create_model_sql,
                        load_info_sql,
                        queries_sql,
                    )
        except ValueError:
            print("Opcion no valida")
            continue


def main():
    delete_model_sql: str = None
    create_model_sql: str = None
    load_info_sql: str = None
    queries_sql: str = None

    menu_str: str = """
1. Borrar Modelo
2. Crear Modelo
3. Extraer Informacion
4. Cargar Informacion
5. Consultas
6. Salir
"""
    while True:
        print(menu_str)
        try:
            match int(input("Selecciona una opcion: ")):
                case 1:
                    execute_sql_script(delete_model_sql)
                case 2:
                    execute_sql_script(create_model_sql)
                case 3:
                    delete_model_sql, create_model_sql, load_info_sql, queries_sql = (
                        extract_info(
                            delete_model_sql, create_model_sql, load_info_sql, queries_sql
                        )
                    )
                case 4:
                    execute_sql_script(load_info_sql)
                case 5:
                    execute_sql_script(queries_sql)
                case 6:
                    break
        except ValueError:
            print("Opcion invalida")
            continue


if __name__ == "__main__":
    main()
