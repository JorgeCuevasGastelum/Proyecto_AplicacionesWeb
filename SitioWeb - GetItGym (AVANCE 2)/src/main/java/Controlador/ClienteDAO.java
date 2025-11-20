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
            // OJO: Aquí hago un JOIN simple para ver los nombres de la clase y suscripción si ya los guardaste con IDs.
            // Si en tu tabla clientes guardas strings directos, usa "SELECT * FROM clientes".
            String sql = "SELECT * FROM clientes"; 
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Cliente c = new Cliente();
                c.setId(rs.getInt("id")); // Asegúrate de tener este campo en tu modelo Cliente
                c.setNombre(rs.getString("nombre"));
                c.setEmail(rs.getString("email"));
                c.setTelefono(rs.getString("telefono"));
               
                // c.setClase(...) -> Depende como lo guardes
                lista.add(c);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }
    
}
