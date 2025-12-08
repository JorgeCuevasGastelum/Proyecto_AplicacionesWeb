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
        } catch (Exception e) {
            e.printStackTrace();
        }
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public int contarInscritosPorClase(int idClase) {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM clases_cliente WHERE id_clase = ?";

        try (Connection conn = Conexion.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idClase);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    public int obtenerTotalClientes() {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM clientes";

        try (Connection conn = Conexion.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    public int obtenerTotalClases() {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM clases";

        try (Connection conn = Conexion.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }
    
    public String obtenerSuscripcionMasUsada() {
    String tipo = "Sin datos";

    String sql = "SELECT s.tipo "
               + "FROM suscripciones_cliente sc "
               + "JOIN suscripciones s ON sc.id_suscripcion = s.id "
               + "GROUP BY s.tipo "
               + "ORDER BY COUNT(*) DESC "
               + "LIMIT 1";

    try (Connection conn = Conexion.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        if (rs.next()) {
            tipo = rs.getString("tipo");
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return tipo;
}


}
