def delete_workout_session(connection, session_id):
    """Deletes a workout session from the database by its ID."""

    try:
        cursor = connection.cursor()

        check_session_query = "SELECT * FROM WorkoutSessions WHERE session_id = %s"
        cursor.execute(check_session_query, (session_id,))
        session_exists = cursor.fetchone()

        if not session_exists:
            raise ValueError(f"Workout session with ID {session_id} not found.")


        delete_query = "DELETE FROM WorkoutSessions WHERE session_id = %s"
        cursor.execute(delete_query, (session_id,))
        connection.commit()

        print(f"Workout session with ID {session_id} deleted successfully!")
    except "mysql".connector.Error as err:
        print(f"Database Error: {err}")
    except ValueError as e:
        print(f"Error: {e}")
    finally:
        if cursor:
            cursor.close()



def main():  
    config = {
        'user': 'your_username',
        'password': 'your_password',
        'host': 'localhost',
        'database': 'e_commerce_db'
    }

    try:
        connection = "mysql".connector.connect(**config)
        if connection.is_connected():
            print("Connected to MySQL database successfully")

            delete_workout_session(connection, 1)
            

    except "mysql".connector.Error as err:
        print(f"Database Connection Error: {err}")
    finally:
        if connection and connection.is_connected():
            connection.close()
            print("MySQL connection is closed")

if __name__ == "__main__":
    main()