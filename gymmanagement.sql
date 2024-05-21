
def list_distinct_trainers(connection):
    """Fetches a list of distinct trainer IDs from the 'Members' table."""
    try:
        cursor = connection.cursor()
        query = "SELECT DISTINCT trainer_id FROM Members"
        cursor.execute(query)
        return [row[0] for row in cursor.fetchall()]

    except mysql.connector.Error as err:
        print(f"Database Error: {err}")
        return []
    finally:
        if cursor:
            cursor.close()


def count_members_per_trainer(connection):
    """Counts the number of members assigned to each trainer."""

    try:
        cursor = connection.cursor()
        query = """
            SELECT trainer_id, COUNT(*) AS member_count
            FROM Members
            GROUP BY trainer_id
        """
        cursor.execute(query)
        return {trainer_id: count for trainer_id, count in cursor.fetchall()}

    except mysql.connector.Error as err:
        print(f"Database Error: {err}")
        return {}
    finally:
        if cursor:
            cursor.close()


def get_members_in_age_range(connection, start_age, end_age):

    try:
        if start_age > end_age:
            raise ValueError("Start age cannot be greater than end age.")

        cursor = connection.cursor()
        query = """
            SELECT member_id, name, age, trainer_id 
            FROM Members
            WHERE age BETWEEN %s AND %s
        """
        cursor.execute(query, (start_age, end_age))
        return cursor.fetchall()

    except mysql.connector.Error as err:
        print(f"Database Error: {err}")
        return []
    except ValueError as e:
        print(f"Error: {e}")
    finally:
        if cursor:
            cursor.close()

def add_workout_session(connection, member_id, date, duration_minutes, calories_burned):  # Fixed indentation here
    """Adds a new workout session to the 'WorkoutSessions' table."""

    try:
        cursor = connection.cursor()

        # Check if the member exists
        check_member_query = "SELECT * FROM Members WHERE member_id = %s"
        cursor.execute(check_member_query, (member_id,))
        member_exists = cursor.fetchone()

        if not member_exists:
            raise ValueError(f"Member with ID {member_id} does not exist.")
        
        # Check for duplicate session
        check_duplicate_query = """
            SELECT * FROM WorkoutSessions 
            WHERE member_id = %s AND date = %s 
            AND duration_minutes = %s AND calories_burned = %s
        """
        cursor.execute(check_duplicate_query, (member_id, date, duration_minutes, calories_burned))
        duplicate_exists = cursor.fetchone()
        
        if duplicate_exists:
            raise ValueError(f"Workout session for member {member_id} with same details already exists.")

        # Insert the workout session
        insert_query = """
            INSERT INTO WorkoutSessions (member_id, date, duration_minutes, calories_burned)
            VALUES (%s, %s, %s, %s)
        """
        values = (member_id, date, duration_minutes, calories_burned)
        cursor.execute(insert_query, values)
        connection.commit()

        print("Workout session added successfully!")
    except mysql.connector.Error as err:
        print(f"Database Error: {err}")
    except ValueError as e:
        print(f"Error: {e}")
    finally:
        if cursor:
            cursor.close()