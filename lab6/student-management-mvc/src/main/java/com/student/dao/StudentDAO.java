package com.student.dao;

import com.student.model.Student;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    // Database configuration
    private static final String DB_URL = "jdbc:mysql://localhost:3307/student_management"
            + "?useSSL=false"
            + "&allowPublicKeyRetrieval=true"
            + "&serverTimezone=UTC";
    private static final String DB_USER = "user1";
    private static final String DB_PASSWORD = "user1";

    // Get database connection
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL Driver not found", e);
        }
    }

    // Get all students
    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students ORDER BY id DESC";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setStudentCode(rs.getString("student_code"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
                student.setCreatedAt(rs.getTimestamp("created_at"));
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    // Get student by ID
    public Student getStudentById(int id) {
        String sql = "SELECT * FROM students WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setStudentCode(rs.getString("student_code"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
                student.setCreatedAt(rs.getTimestamp("created_at"));
                return student;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Add new student
    public boolean addStudent(Student student) {
        String sql = "INSERT INTO students (student_code, full_name, email, major) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, student.getStudentCode());
            pstmt.setString(2, student.getFullName());
            pstmt.setString(3, student.getEmail());
            pstmt.setString(4, student.getMajor());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update student
    public boolean updateStudent(Student student) {
        String sql = "UPDATE students SET student_code = ?, full_name = ?, email = ?, major = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, student.getStudentCode());
            pstmt.setString(2, student.getFullName());
            pstmt.setString(3, student.getEmail());
            pstmt.setString(4, student.getMajor());
            pstmt.setInt(5, student.getId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete student
    public boolean deleteStudent(int id) {
        String sql = "DELETE FROM students WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Student> searchStudents(String query) {
        List<Student> result = new ArrayList<>();
        if (query == null || query.trim().length() == 0) {
            return result;
        }

        String sql = "SELECT * FROM students " +
                "WHERE student_code LIKE ? " +
                "OR full_name LIKE ? " +
                "OR email LIKE ? " +
                "ORDER BY id DESC";

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            String val = "%" + query.trim() + "%";

            for (int i = 1; i <= 3; i++) {
                ps.setString(i, val);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Student s = new Student();
                s.setId(rs.getInt("id"));
                s.setStudentCode(rs.getString("student_code"));
                s.setFullName(rs.getString("full_name"));
                s.setEmail(rs.getString("email"));
                s.setMajor(rs.getString("major"));
                s.setCreatedAt(rs.getTimestamp("created_at"));

                result.add(s);
            }
            rs.close();

        } catch (Exception ex) {
            System.out.println("Search error: " + ex.getMessage());
        }
        return result;
    }

    public List<Student> getStudentsSorted(String sortBy, String order) {
        List<Student> students = new ArrayList<>();

        String validSort = "id";
        if (sortBy != null) {
            if (sortBy.equals("student_code") || sortBy.equals("full_name") ||
                    sortBy.equals("email") || sortBy.equals("major")) {
                validSort = sortBy;
            }
        }

        String validOrder = "ASC";
        if (order != null && order.equalsIgnoreCase("desc")) {
            validOrder = "DESC";
        }

        String sql = "SELECT * FROM students ORDER BY " + validSort + " " + validOrder;

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setStudentCode(rs.getString("student_code"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
                student.setCreatedAt(rs.getTimestamp("created_at"));
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    public List<Student> getStudentsByMajor(String major) {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students WHERE major = ? ORDER BY id DESC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, major);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setStudentCode(rs.getString("student_code"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
                student.setCreatedAt(rs.getTimestamp("created_at"));
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    public List<Student> getStudentsFiltered(String major, String sortBy, String order) {
        List<Student> students = new ArrayList<>();

        String validSort = "id";
        if (sortBy != null) {
            if (sortBy.equals("student_code") || sortBy.equals("full_name") ||
                    sortBy.equals("email") || sortBy.equals("major")) {
                validSort = sortBy;
            }
        }

        String validOrder = "ASC";
        if (order != null && order.equalsIgnoreCase("desc")) {
            validOrder = "DESC";
        }

        StringBuilder sql = new StringBuilder("SELECT * FROM students ");
        boolean hasMajor = (major != null && !major.trim().isEmpty());

        if (hasMajor) {
            sql.append("WHERE major = ? ");
        }

        sql.append("ORDER BY ").append(validSort).append(" ").append(validOrder);

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            if (hasMajor) {
                pstmt.setString(1, major);
            }

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setStudentCode(rs.getString("student_code"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
                student.setCreatedAt(rs.getTimestamp("created_at"));
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    public int getTotalStudents() {
        int count = 0;
        String sql = "SELECT COUNT(id) FROM students";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            // The result set for a COUNT query will have one row.
            if (rs.next()) {
                // Get the count from the first column.
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }


    public static void main(String[] args) {
        StudentDAO dao = new StudentDAO();
        List<Student> results = dao.searchStudents("john");
        System.out.println("Found " + results.size() + " students");
        for (Student s : results) {
            System.out.println(s);
        }
    }
}


