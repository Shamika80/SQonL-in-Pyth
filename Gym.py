import mysql.connector

# ... (Other functions: list_distinct_trainers, count_members_per_trainer, get_members_in_age_range, add_workout_session) ...

def delete_workout_session(connection, session_id):
    """Deletes a workout session from the database by its ID."""

    try:
        cursor = connection.cursor()

        # Check if the session exists
        check_session_query = "SELECT * FROM WorkoutSessions WHERE session_id = %s"
        cursor.execute(check_session_query, (session_id,))
        session_exists = cursor.fetchone()

        if not session_exists:
            raise ValueError(f"Workout session with ID {session_id} not found.")

        # Delete the session
        delete_query = "DELETE FROM WorkoutSessions WHERE session_id = %s"
        cursor.execute(delete_query, (session_id,))
        connection.commit()

        print(f"Workout session with ID {session_id} deleted successfully!")
    except mysql.connector.Error as err:
        print(f"Database Error: {err}")
    except ValueError as e:
        print(f"Error: {e}")
    finally:
        if cursor:
            cursor.close()



# --- (Main Script) ---
def main():  # Fixed indentation here
    # (Database connection setup - replace with your actual credentials)
    config = {
        'user': 'your_username',
        'password': 'your_password',
        'host': 'localhost',
        'database': 'e_commerce_db'
    }

    try:
        connection = mysql.connector.connect(**config)
        if connection.is_connected():
            print("Connected to MySQL database successfully")

            # (Example usage of the functions)
            #add_member(connection, 101, "Alice Johnson", 30, 55)
            #add_workout_session(connection, 101, "2024-05-13", 60, 450)
            #update_member_age(connection, 101, 35)
            delete_workout_session(connection, 1)
            # ... and so on

    except mysql.connector.Error as err:
        print(f"Database Connection Error: {err}")
    finally:
        if connection and connection.is_connected():
            connection.close()
            print("MySQL connection is closed")

if __name__ == "__main__":
    main()