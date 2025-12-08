package Controlador;

import Modelo.Instructor;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class InstructorDAO {

    /* =========================
       INSERTAR INSTRUCTOR
       (USADO POR EL SERVLET)
       ========================= */
    public int insertar(Instructor i) {

        String sql
                = "INSERT INTO instructores (nombre, email, telefono, especialidad, activo) "
                + "VALUES (?, ?, ?, ?, 1)";

        try (Connection conn = Conexion.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // Validar duplicado
            if (existeInstructor(conn, i.getEmail())) {
                return -1;
            }

            ps.setString(1, i.getNombre());
            ps.setString(2, i.getEmail());
            ps.setString(3, i.getTelefono());
            ps.setString(4, i.getEspecialidad());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); // ID generado
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    /* =========================
       ASIGNAR CLASE A INSTRUCTOR
       ========================= */
    public void asignarClase(int idInstructor, int idClase) {

        String sql
                = "INSERT INTO instructores_clases (id_instructor, id_clase) VALUES (?, ?)";

        try (Connection conn = Conexion.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idInstructor);
            ps.setInt(2, idClase);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /* =========================
       VALIDAR EMAIL DUPLICADO
       ========================= */
    private boolean existeInstructor(Connection conn, String email) throws Exception {

        String sql = "SELECT COUNT(*) FROM instructores WHERE email = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /* =========================
       LISTAR INSTRUCTORES
       ========================= */
    public List<Instructor> listarInstructores() {

        List<Instructor> lista = new ArrayList<>();

        String sql
                = "SELECT i.id, i.nombre, i.email, i.telefono, i.especialidad, i.activo, "
                + "GROUP_CONCAT(DISTINCT cl.nombre SEPARATOR ', ') AS clases "
                + "FROM instructores i "
                + "LEFT JOIN instructores_clases ic ON ic.id_instructor = i.id "
                + "LEFT JOIN clases cl ON cl.id = ic.id_clase "
                + "GROUP BY i.id, i.nombre, i.email, i.telefono, i.especialidad, i.activo";

        try (Connection conn = Conexion.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Instructor inst = new Instructor();
                inst.setId(rs.getInt("id"));
                inst.setNombre(rs.getString("nombre"));
                inst.setEmail(rs.getString("email"));
                inst.setTelefono(rs.getString("telefono"));
                inst.setEspecialidad(rs.getString("especialidad"));
                inst.setActivo(rs.getBoolean("activo"));
                inst.setClases(rs.getString("clases"));
                lista.add(inst);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    /* =========================
       ELIMINAR INSTRUCTOR
       ========================= */
    public void eliminar(int id) {

        String sqlClases = "DELETE FROM instructores_clases WHERE id_instructor = ?";
        String sqlInstructor = "DELETE FROM instructores WHERE id = ?";

        try (Connection conn = Conexion.getConnection()) {

            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(sqlClases)) {
                ps1.setInt(1, id);
                ps1.executeUpdate();
            }

            try (PreparedStatement ps2 = conn.prepareStatement(sqlInstructor)) {
                ps2.setInt(1, id);
                ps2.executeUpdate();
            }

            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
