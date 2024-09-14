import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class AverageGPACalculator {

    public static void main(String[] args) {
        String fileName = "grades.txt";
        double totalGPA = 0;
        int numStudents = 0;

        try (BufferedReader br = new BufferedReader(new FileReader(fileName))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(";");
                double gpa = Double.parseDouble(parts[1]);
                totalGPA += gpa;
                numStudents++;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        if (numStudents > 0) {
            double averageGPA = totalGPA / numStudents;
            System.out.println("Average GPA of the students: " + averageGPA);
        } else {
            System.out.println("No students found.");
        }
    }
}
