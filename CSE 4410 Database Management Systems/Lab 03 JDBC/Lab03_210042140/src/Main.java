import java.sql.*;
import java.util.Scanner;

class jdbc_practice {
    public static void main(String args[]) {
        try {
            // step1 load the driver class
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // step2 create the connection object
            Connection con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:xe", "SYSTEM", "1211");

            // step3 create the statement object
            Statement stmt = con.createStatement();


            // Step 4 Execute query
             // Task 01. Number of departments that did not get affected
            String unaffectedDepartments = "SELECT COUNT(*) AS UNAFFECTED_DEPARTMENTS FROM DEPARTMENT WHERE BUDGET <= 99999";
            ResultSet unaffectedDepartmentsResult = stmt.executeQuery(unaffectedDepartments);

            if (unaffectedDepartmentsResult.next()) {
                int unaffectedDepartmentsCount = unaffectedDepartmentsResult.getInt("UNAFFECTED_DEPARTMENTS");
                System.out.println("Number of departments that did not get affected: " + unaffectedDepartmentsCount);
            }

            // Task 01. Decrease the budget by 10%
            String decreaseBudget = "UPDATE DEPARTMENT SET BUDGET = BUDGET * 0.9 WHERE BUDGET > 99999";
            int affectedRows = stmt.executeUpdate(decreaseBudget);
            System.out.println("Budgets decreased for " + affectedRows + " departments.");

            //Task 02.
            // Step 1: Take input from the user
            Scanner scanner = new Scanner(System.in);

            System.out.print("Enter the day of the week (e.g., M, T, W, R, F): ");
            String dayOfWeek = scanner.nextLine().toUpperCase();

            System.out.print("Enter the starting hour (24-hour format): ");
            int startHour = scanner.nextInt();

            System.out.print("Enter the ending hour (24-hour format): ");
            int endHour = scanner.nextInt();

            // Step 2: Execute query to retrieve instructors taking classes during the specified time
            String instructorsSql = "SELECT DISTINCT I.NAME FROM INSTRUCTOR I " +
                    "JOIN TEACHES T ON I.ID = T.ID " +
                    "JOIN SECTION S ON T.COURSE_ID = S.COURSE_ID " +
                    "JOIN TIME_SLOT TS ON S.TIME_SLOT_ID = TS.TIME_SLOT_ID " +
                    "WHERE TS.DAY = ? " +
                    "AND TS.START_HR <= ? " +
                    "AND TS.END_HR >= ?";

            PreparedStatement preparedStatement = con.prepareStatement(instructorsSql);
            preparedStatement.setString(1, dayOfWeek);
            preparedStatement.setInt(2, startHour);
            preparedStatement.setInt(3, endHour);

            ResultSet instructorsResult = preparedStatement.executeQuery();

            // Step 3: Print the names of instructors
            System.out.println("Instructors taking classes during " + dayOfWeek + " from " + startHour + " to " + endHour + ":");
            while (instructorsResult.next()) {
                System.out.println(instructorsResult.getString("NAME"));
            }

            //Task 03.
            // Step 1: Take input from the user for N
            scanner = new Scanner(System.in);
            System.out.print("Enter the value of N: ");
            int N = scanner.nextInt();

            // Step 2: Execute query to find the top N students based on the number of courses
            String topStudentsSql = "SELECT S.ID, S.NAME, S.DEPT_NAME, COUNT(T.COURSE_ID) AS COURSE_COUNT " +
                    "FROM STUDENT S " +
                    "LEFT JOIN TAKES T ON S.ID = T.ID " +
                    "GROUP BY S.ID, S.NAME, S.DEPT_NAME " +
                    "ORDER BY COURSE_COUNT DESC";

            preparedStatement = con.prepareStatement(topStudentsSql);
            ResultSet topStudentsResult = preparedStatement.executeQuery();

            // Step 3: Print the information for the top N students
            System.out.println("Top " + N + " students based on the number of courses taken:");
            int count = 0;
            while (topStudentsResult.next() && (count < N || N <= 0)) {
                System.out.println("ID: " + topStudentsResult.getString("ID") +
                        ", Name: " + topStudentsResult.getString("NAME") +
                        ", Department: " + topStudentsResult.getString("DEPT_NAME") +
                        ", Courses Taken: " + topStudentsResult.getInt("COURSE_COUNT"));
                count++;
            }

            //Task 04.
            // Step 1: Find the highest existing ID value among the current students
            String maxIdQuery = "SELECT MAX(CAST(ID AS NUMBER)) AS MAX_ID FROM STUDENT";
            ResultSet maxIdResult = stmt.executeQuery(maxIdQuery);
            int highestId = 0;
            if (maxIdResult.next()) {
                highestId = maxIdResult.getInt("MAX_ID");
            }

            // Step 2: Determine the department with the lowest number of students
            String lowestDeptQuery = "SELECT DEPT_NAME " +
                    "FROM DEPARTMENT " +
                    "ORDER BY (SELECT COUNT(*) FROM STUDENT WHERE DEPT_NAME = DEPARTMENT.DEPT_NAME) " +
                    "FETCH FIRST 1 ROWS ONLY";
            ResultSet lowestDeptResult = stmt.executeQuery(lowestDeptQuery);
            String lowestDeptName = "";
            if (lowestDeptResult.next()) {
                lowestDeptName = lowestDeptResult.getString("DEPT_NAME");
            }

            // Step 3: Increment the highest ID value by 1 to obtain the new student's ID
            int newStudentId = highestId + 1;

            // Step 4: Insert the new student into the department with the lowest number of students
            String insertStudentSql = "INSERT INTO STUDENT (ID, NAME, DEPT_NAME, TOT_CRED) " +
                    "VALUES (?, 'Jane Doe', ?, 0)";
            preparedStatement = con.prepareStatement(insertStudentSql);
            preparedStatement.setInt(1, newStudentId);
            preparedStatement.setString(2, lowestDeptName);
            preparedStatement.executeUpdate();

            System.out.println("New student 'Jane Doe' inserted with ID: " + newStudentId +
                    ", Department: " + lowestDeptName);


            //Task 05.
            // Step 1: Find the list of students without an advisor
            String studentsWithoutAdvisorQuery = "SELECT S.ID, S.NAME, S.DEPT_NAME " +
                    "FROM STUDENT S " +
                    "LEFT JOIN ADVISOR A ON S.ID = A.S_ID " +
                    "WHERE A.S_ID IS NULL";
            ResultSet studentsWithoutAdvisorResult = stmt.executeQuery(studentsWithoutAdvisorQuery);

            // Step 2: For each student without an advisor, assign an advisor from their department
            while (studentsWithoutAdvisorResult.next()) {
                String studentId = studentsWithoutAdvisorResult.getString("ID");
                String studentName = studentsWithoutAdvisorResult.getString("NAME");
                String deptName = studentsWithoutAdvisorResult.getString("DEPT_NAME");

                // Find the advisor with the least number of students advised from the student's department
                String advisorQuery = "SELECT I.NAME, COUNT(A.S_ID) AS ADVISEE_COUNT " +
                        "FROM INSTRUCTOR I " +
                        "LEFT JOIN ADVISOR A ON I.ID = A.I_ID " +
                        "WHERE I.DEPT_NAME = ? " +
                        "GROUP BY I.NAME " +
                        "ORDER BY ADVISEE_COUNT " +
                        "FETCH FIRST 1 ROWS ONLY";
                PreparedStatement advisorStatement = con.prepareStatement(advisorQuery);
                advisorStatement.setString(1, deptName);
                ResultSet advisorResult = advisorStatement.executeQuery();

                if (advisorResult.next()) {
                    String advisorName = advisorResult.getString("NAME");
                    int adviseeCount = advisorResult.getInt("ADVISEE_COUNT");

                    // Assign the advisor to the student
                    String assignAdvisorQuery = "INSERT INTO ADVISOR (S_ID, I_ID) VALUES (?, " +
                            "(SELECT I.ID FROM INSTRUCTOR I WHERE I.NAME = ?))";
                    PreparedStatement assignAdvisorStatement = con.prepareStatement(assignAdvisorQuery);
                    assignAdvisorStatement.setString(1, studentId);
                    assignAdvisorStatement.setString(2, advisorName);
                    assignAdvisorStatement.executeUpdate();

                    System.out.println("Assigned advisor " + advisorName + " to student " + studentName +
                            " (ID: " + studentId + ") from department " + deptName +
                            ". Number of students advised by the advisor: " + adviseeCount);
                }
            }





            // step5 close the connection object

            con.close();

        } catch (Exception e) {
            System.out.println(e);
        }

    }
}




// Scanner scanner = new Scanner(System.in);

// System.out.print("Enter your last name: ");
// String lastName = scanner.nextLine();

// System.out.print("Enter your first name: ");
// String firstName = scanner.nextLine();

// System.out.print("Enter your email: ");
// String email = scanner.nextLine();


// // 2. Create a statement
// String sql = "insert into employees "
// 		+ " (last_name, first_name, email)" + " values (?, ?, ?)";

// myStmt = myConn.prepareStatement(sql);

// // set param values
// myStmt.setString(1, lastName);
// myStmt.setString(2, firstName);
// myStmt.setString(3, email);

// // 3. Execute SQL query
// myStmt.executeUpdate();