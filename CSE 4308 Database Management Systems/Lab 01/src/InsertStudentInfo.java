import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

public class InsertStudentInfo {
    public static boolean isValidGPA(double gpa) {
        return gpa >= 2.50 && gpa <= 4.00;
    }

    public static boolean isValidSemester(int semester) {
        return semester >= 1 && semester <= 8;
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Enter Student ID: ");
        String studentID = scanner.nextLine();

        System.out.print("Enter GPA: ");
        double gpa = scanner.nextDouble();

        System.out.print("Enter Semester: ");
        int semester = scanner.nextInt();

        if (!isValidGPA(gpa)) {
            System.out.println("Invalid GPA. GPA should be between 2.50 and 4.00.");
            return;
        }

        if (!isValidSemester(semester)) {
            System.out.println("Invalid Semester. Semester should be between 1 and 8.");
            return;
        }

        try {
            BufferedWriter writer = new BufferedWriter(new FileWriter("grades.txt", true));
            writer.write(studentID + ";" + String.format("%.2f", gpa) + ";" + semester);
            writer.newLine();
            writer.close();

            System.out.println("Information inserted successfully!");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
