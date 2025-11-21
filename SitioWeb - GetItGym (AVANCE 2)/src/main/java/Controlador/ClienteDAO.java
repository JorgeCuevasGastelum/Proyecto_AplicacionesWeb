/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controlador;

import Modelo.Cliente;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    public boolean registrarCliente(Cliente c) {
        String sqlCliente = "INSERT INTO clientes(nombre,email,telefono,edad,objetivos) VALUES(?,?,?,?,?)";

        try (Connection conn = Conexion.getConnection(); PreparedStatement psCliente = conn.prepareStatement(sqlCliente, Statement.RETURN_GENERATED_KEYS)) {

            if (existeCliente(conn, c)) {
                return false; // señalamos error por duplicado
            }

            psCliente.setString(1, c.getNombre());
            psCliente.setString(2, c.getEmail());
            psCliente.setString(3, c.getTelefono());
            psCliente.setInt(4, c.getEdad());
            psCliente.setString(5, c.getObjetivos());
            psCliente.executeUpdate();

            ResultSet rs = psCliente.getGeneratedKeys();
            if (!rs.next()) {
                return false;
            }

            int idCliente = rs.getInt(1);

            registrarClaseCliente(conn, idCliente, c.getClase());
            registrarSuscripcionCliente(conn, idCliente, c.getPlazo());

            return true;

        } catch (Exception e) {
            System.out.println("Error registrando cliente: " + e.getMessage());
            return false;
        }
    }

    private void registrarClaseCliente(Connection conn, int idCliente, String clase) throws Exception {
        if (clase.equals("sin-clase")) {
            return;
        }

        String sql = "INSERT INTO clases_cliente(id_cliente, id_clase) VALUES(?, ?)";
        int idClase;

        switch (clase) {
            case "primera":
                idClase = 1;
                break;
            case "segunda":
                idClase = 2;
                break;
            case "tercera":
                idClase = 3;
                break;
            case "cuarta":
                idClase = 4;
                break;
            case "quinta":
                idClase = 5;
                break;
            default:
                idClase = 1;
                break;
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idCliente);
            ps.setInt(2, idClase);
            ps.executeUpdate();
        }
    }

    private void registrarSuscripcionCliente(Connection conn, int idCliente, String plazo) throws Exception {

        String sql = "INSERT INTO suscripciones_cliente(id_cliente, id_suscripcion, fecha_inicio, fecha_fin) VALUES(?, ?, ?, ?)";

        int idSus;
        switch (plazo) {
            case "diario":
                idSus = 1;
                break;
            case "semanal":
                idSus = 2;
                break;
            case "mensual":
                idSus = 3;
                break;
            case "trimestral":
                idSus = 4;
                break;
            case "anual":
                idSus = 5;
                break;
            default:
                idSus = 1;
                break;
        }

        LocalDate inicio = LocalDate.now();
        LocalDate fin;

        switch (plazo) {
            case "diario":
                fin = inicio.plusDays(1);
                break;
            case "semanal":
                fin = inicio.plusWeeks(1);
                break;
            case "mensual":
                fin = inicio.plusMonths(1);
                break;
            case "trimestral":
                fin = inicio.plusMonths(3);
                break;
            case "anual":
                fin = inicio.plusYears(1);
                break;
            default:
                fin = inicio.plusDays(1);
                break;
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idCliente);
            ps.setInt(2, idSus);
            ps.setDate(3, java.sql.Date.valueOf(inicio));
            ps.setDate(4, java.sql.Date.valueOf(fin));
            ps.executeUpdate();
        }
    }

    private boolean existeCliente(Connection conn, Cliente c) throws Exception {
        String sql = "SELECT COUNT(*) FROM clientes WHERE email = ? OR telefono = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getEmail());
            ps.setString(2, c.getTelefono());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    // Método para listar clientes en el Panel de Admin
    public List<Cliente> listarClientes() {
    List<Cliente> lista = new ArrayList<>();
    
    try (Connection conn = Conexion.getConnection()) {

        String sql = "SELECT c.id, c.nombre, c.email, c.telefono, c.edad, c.objetivos, "
                + "cl.nombre AS clase, "
                + "s.tipo AS suscripcion "
                + "FROM clientes c "
                + "LEFT JOIN clases_cliente cc ON cc.id_cliente = c.id "
                + "LEFT JOIN clases cl ON cl.id = cc.id_clase "
                + "LEFT JOIN suscripciones_cliente sc ON sc.id_cliente = c.id "
                + "LEFT JOIN suscripciones s ON s.id = sc.id_suscripcion;";

        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Cliente cli = new Cliente();

            cli.setId(rs.getInt("id"));
            cli.setNombre(rs.getString("nombre"));
            cli.setEmail(rs.getString("email"));
            cli.setTelefono(rs.getString("telefono"));
            cli.setEdad(rs.getInt("edad"));
            cli.setObjetivos(rs.getString("objetivos"));
            cli.setClase(rs.getString("clase"));
            cli.setPlazo(rs.getString("suscripcion"));

            lista.add(cli);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return lista;
}


    public boolean eliminarCliente(int id) {

        String sqlSuscripciones = "DELETE FROM suscripciones_cliente WHERE id_cliente = ?";
        String sqlClases = "DELETE FROM clases_cliente WHERE id_cliente = ?";
        String sqlCliente = "DELETE FROM clientes WHERE id = ?";

        try (Connection conn = Conexion.getConnection()) {

            conn.setAutoCommit(false); // iniciar transacción

            // 1. Eliminar suscripciones
            try (PreparedStatement ps1 = conn.prepareStatement(sqlSuscripciones)) {
                ps1.setInt(1, id);
                ps1.executeUpdate();
            }

            // 2. Eliminar clases
            try (PreparedStatement ps2 = conn.prepareStatement(sqlClases)) {
                ps2.setInt(1, id);
                ps2.executeUpdate();
            }

            // 3. Eliminar cliente
            int filas;
            try (PreparedStatement ps3 = conn.prepareStatement(sqlCliente)) {
                ps3.setInt(1, id);
                filas = ps3.executeUpdate();
            }

            if (filas > 0) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
