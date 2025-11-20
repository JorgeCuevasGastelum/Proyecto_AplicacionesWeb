/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controlador;

import Modelo.ClaseGym;
import Modelo.Suscripcion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CatalogosDAO {
    
    public List<ClaseGym> obtenerClases() {
        List<ClaseGym> lista = new ArrayList<>();
        try (Connection conn = Conexion.getConnection()) {
            String sql = "SELECT id, nombre FROM clases";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(new ClaseGym(rs.getInt("id"), rs.getString("nombre")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public List<Suscripcion> obtenerSuscripciones() {
        List<Suscripcion> lista = new ArrayList<>();
        try (Connection conn = Conexion.getConnection()) {
            String sql = "SELECT id, tipo, precio FROM suscripciones";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(new Suscripcion(rs.getInt("id"), rs.getString("tipo"), rs.getDouble("precio")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }
}