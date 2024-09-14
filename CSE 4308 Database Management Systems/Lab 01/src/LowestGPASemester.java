import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class LowestGPASemester {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Enter Student ID: ");
        String studentID = scanner.nextLine();

        Map<String, String> studentNameMap = new HashMap<>();
        Map<String, Double> lowestGPAMap = new HashMap<>();

        try (BufferedReader reader = new BufferedReader(new FileReader("studentInfo.txt"))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(";");
                String id = parts[0];
                String name = parts[1];
                studentNameMap.put(id, name);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        try (BufferedReader reader = new BufferedReader(new FileReader("grades.txt"))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(";");
                if (parts.length >= 3) { // Check the length to avoid index out of bounds
                    String id = parts[0];
                    double gpa = Double.parseDouble(parts[1]);
                    String semester = parts[2];
                    if (!lowestGPAMap.containsKey(id) || gpa < lowestGPAMap.get(id)) {
                        lowestGPAMap.put(id, gpa);
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        if (studentNameMap.containsKey(studentID) && lowestGPAMap.containsKey(studentID)) {
            String studentName = studentNameMap.get(studentID);
            double lowestGPA = lowestGPAMap.get(studentID);
            System.out.println("Student Name: " + studentName);
            System.out.println("Lowest GPA: " + lowestGPA);

            try (BufferedReader reader = new BufferedReader(new FileReader("grades.txt"))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String[] parts = line.split(";");
                    if (parts.length >= 3) { // Check the length to avoid index out of bounds
                        String id = parts[0];
                        double gpa = Double.parseDouble(parts[1]);
                        String semester = parts[2];
                        if (id.equals(studentID) && gpa == lowestGPA) {
                            System.out.println("Semester with Lowest GPA: " + semester);
                            break;
                        }
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("Student ID not found in the database.");
        }
    }
}
