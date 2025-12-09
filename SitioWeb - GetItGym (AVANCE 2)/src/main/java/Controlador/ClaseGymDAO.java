/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controlador;

import Modelo.ClaseGym;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.sql.PreparedStatement;

public class ClaseGymDAO {

    private Connection con;

    public ClaseGymDAO() {
        try {
            Conexion cn = new Conexion();
            con = cn.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ---------------------------------------------------------
    // 1. Obtener TODAS las clases (para tu modal de edición)
    // ---------------------------------------------------------
    public List<ClaseGym> obtenerTodas() {
        List<ClaseGym> lista = new ArrayList<>();

        try {
            String sql = "SELECT * FROM clases_gym ORDER BY nombre_clase ASC";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ClaseGym c = new ClaseGym();
                c.setId(rs.getInt("id"));
                c.setNombre(rs.getString("nombre_clase"));
                lista.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    // ---------------------------------------------------------
    // 2. Obtener una clase por ID
    // ---------------------------------------------------------
    public ClaseGym obtenerClasePorId(int id) {
        ClaseGym clase = null;

        try {
            String sql = "SELECT * FROM clases_gym WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                clase = new ClaseGym();
                clase.setId(rs.getInt("id"));
                clase.setNombre(rs.getString("nombre_clase"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return clase;
    }

    // ---------------------------------------------------------
    // 3. Insertar clase (por si la ocupas más adelante)
    // ---------------------------------------------------------
    public boolean insertarClase(ClaseGym clase) {
        try {
            String sql = "INSERT INTO clases_gym(nombre_clase) VALUES(?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, clase.getNombre());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ---------------------------------------------------------
    // 4. Actualizar clase
    // ---------------------------------------------------------
    public boolean actualizarClase(ClaseGym clase) {
        try {
            String sql = "UPDATE clases_gym SET nombre_clase = ? WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, clase.getNombre());
            ps.setInt(2, clase.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ---------------------------------------------------------
    // 5. Eliminar clase
    // ---------------------------------------------------------
    public boolean eliminarClase(int id) {
        try {
            String sql = "DELETE FROM clases_gym WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
