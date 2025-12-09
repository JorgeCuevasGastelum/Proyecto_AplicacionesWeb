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
 // CORRECCIÓN 1: Agregamos la columna 'password' y un ? extra (ahora son 6)
        String sqlCliente = "INSERT INTO clientes(nombre, email, password, telefono, edad, objetivos) VALUES(?, ?, ?, ?, ?, ?)";

        try (Connection conn = Conexion.getConnection(); 
             PreparedStatement psCliente = conn.prepareStatement(sqlCliente, Statement.RETURN_GENERATED_KEYS)) {

            if (existeCliente(conn, c)) {
                return false; 
            }

            // CORRECCIÓN 2: Asegurar que el orden coincida con el SQL de arriba
            psCliente.setString(1, c.getNombre());
            psCliente.setString(2, c.getEmail());
            psCliente.setString(3, c.getPassword()); // El 3er ? es password
            psCliente.setString(4, c.getTelefono()); // El 4to ? es telefono
            psCliente.setInt(5, c.getEdad());        // El 5to ? es edad
            psCliente.setString(6, c.getObjetivos());// El 6to ? es objetivos
            
            psCliente.executeUpdate();

            ResultSet rs = psCliente.getGeneratedKeys();
            if (!rs.next()) {
                return false;
            }

            int idCliente = rs.getInt(1);

            // Estos métodos ya deben manejar sus propios INSERTs
            registrarClaseCliente(conn, idCliente, c.getClase());
            registrarSuscripcionCliente(conn, idCliente, c.getPlazo());

            return true;

        } catch (Exception e) {
            e.printStackTrace(); // Imprime el error completo en la consola
            System.out.println("Error registrando cliente: " + e.getMessage());
            return false;
        }
    }
    
    // 2. NUEVO MÉTODO: LOGIN DE CLIENTE
    public Cliente loginCliente(String email, String password) {
        Cliente c = null;
        String sql = "SELECT * FROM clientes WHERE email = ? AND password = ?";
        
        try (Connection conn = Conexion.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                c = new Cliente();
                c.setId(rs.getInt("id"));
                c.setNombre(rs.getString("nombre"));
                c.setEmail(rs.getString("email"));
                c.setEdad(rs.getInt("edad"));
                c.setTelefono(rs.getString("telefono"));
                c.setObjetivos(rs.getString("objetivos"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return c;
    }

    
/**
     * Actualiza cliente. Si 'password' tiene valor, lo actualiza. Si es null/vacío, lo ignora.
     */
    public boolean actualizarCliente(int id, String nombre, String email, String password, String telefono, int edad, int idNuevaSuscripcion) {
        
        // Construimos el SQL dinámicamente dependiendo si hay cambio de contraseña
        String sqlCliente;
        boolean cambiarPass = (password != null && !password.trim().isEmpty());

        if (cambiarPass) {
            sqlCliente = "UPDATE clientes SET nombre=?, email=?, password=?, telefono=?, edad=? WHERE id=?";
        } else {
            sqlCliente = "UPDATE clientes SET nombre=?, email=?, telefono=?, edad=? WHERE id=?";
        }
        
        String sqlSus = "UPDATE suscripciones_cliente SET id_suscripcion=? WHERE id_cliente=? ORDER BY fecha_inicio DESC LIMIT 1";

        Connection conn = null;
        try {
            conn = Conexion.getConnection();
            conn.setAutoCommit(false);

            // 1. Actualizar Datos Personales
            try (PreparedStatement ps = conn.prepareStatement(sqlCliente)) {
                int i = 1;
                ps.setString(i++, nombre);
                ps.setString(i++, email);
                
                if (cambiarPass) {
                    ps.setString(i++, password); // Aquí iría un hash en un sistema real (MD5/SHA)
                }
                
                ps.setString(i++, telefono);
                ps.setInt(i++, edad);
                ps.setInt(i++, id);
                
                ps.executeUpdate();
            }

            // 2. Actualizar Suscripción
            try (PreparedStatement ps = conn.prepareStatement(sqlSus)) {
                ps.setInt(1, idNuevaSuscripcion);
                ps.setInt(2, id);
                int filas = ps.executeUpdate();
                
                // Insertar si no existía (Misma lógica de antes)
                if(filas == 0) {
                    String sqlInsert = "INSERT INTO suscripciones_cliente (id_cliente, id_suscripcion, fecha_inicio, fecha_fin) VALUES (?, ?, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY))";
                    try(PreparedStatement psIn = conn.prepareStatement(sqlInsert)){
                        psIn.setInt(1, id);
                        psIn.setInt(2, idNuevaSuscripcion);
                        psIn.executeUpdate();
                    }
                }
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ex) {}
            return false;
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
    // 3. NUEVO MÉTODO: OBTENER DATOS COMPLETOS PARA DASHBOARD
   // Método que usa AuthServlet para llenar el panel
    public Cliente obtenerDetallesCliente(int idCliente) {
        Cliente c = null;
        
        // Hacemos JOIN con 'suscripciones_cliente' para sacar la fecha_fin real
        String sql = "SELECT c.*, " +
                     "COALESCE(cl.nombre, 'Sin clase') as nombre_clase, " +
                     "COALESCE(s.tipo, 'Sin plan') as tipo_suscripcion, " +
                     "sc.fecha_fin " +  // <--- Aquí pedimos la fecha a la base de datos
                     "FROM clientes c " +
                     "LEFT JOIN clases_cliente cc ON c.id = cc.id_cliente " +
                     "LEFT JOIN clases cl ON cc.id_clase = cl.id " +
                     "LEFT JOIN suscripciones_cliente sc ON c.id = sc.id_cliente " +
                     "LEFT JOIN suscripciones s ON sc.id_suscripcion = s.id " +
                     "WHERE c.id = ? " +
                     "ORDER BY sc.fecha_inicio DESC LIMIT 1";

        try (Connection conn = Conexion.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idCliente);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                c = new Cliente();
                // Llenamos datos básicos
                c.setId(rs.getInt("id"));
                c.setNombre(rs.getString("nombre"));
                c.setEmail(rs.getString("email"));
                c.setTelefono(rs.getString("telefono"));
                c.setEdad(rs.getInt("edad"));
                c.setObjetivos(rs.getString("objetivos"));
                
                // Llenamos los auxiliares
                c.setClase(rs.getString("nombre_clase"));
                c.setPlazo(rs.getString("tipo_suscripcion"));
                
                // AQUÍ GUARDAMOS LA FECHA EN EL OBJETO
                // Si es nula, guardamos un texto vacío o null
                c.setFechaFin(rs.getString("fecha_fin")); 
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return c;
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

            String sql
                    = "SELECT "
                    + "c.id, "
                    + "ANY_VALUE(c.nombre) AS nombre, "
                    + "ANY_VALUE(c.email) AS email, "
                    + "ANY_VALUE(c.telefono) AS telefono, "
                    + "ANY_VALUE(c.edad) AS edad, "
                    + "ANY_VALUE(c.objetivos) AS objetivos, "
                    + "GROUP_CONCAT(DISTINCT cl.nombre SEPARATOR ', ') AS clase, "
                    + "COALESCE(ANY_VALUE(s.tipo), 'Sin pase') AS suscripcion "
                    + "FROM clientes c "
                    + "LEFT JOIN clases_cliente cc ON cc.id_cliente = c.id "
                    + "LEFT JOIN clases cl ON cl.id = cc.id_clase "
                    + "LEFT JOIN suscripciones_cliente sc ON sc.id_cliente = c.id "
                    + "LEFT JOIN suscripciones s ON s.id = sc.id_suscripcion "
                    + "GROUP BY c.id";

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

    public boolean actualizarCliente(int id, String nombre, String email,
            String telefono, String claseNombre,
            String plazo, int edad) {

        String sqlUpdateCliente = "UPDATE clientes SET nombre=?, email=?, telefono=?, edad=? WHERE id=?";
        String sqlDeleteClase = "DELETE FROM clases_cliente WHERE id_cliente=?";
        String sqlDeleteSus = "DELETE FROM suscripciones_cliente WHERE id_cliente=?";

        try (Connection conn = Conexion.getConnection()) {

            conn.setAutoCommit(false);

            // 1. Actualizar datos del cliente (sin clase/plazo porque no existen ahí)
            try (PreparedStatement ps1 = conn.prepareStatement(sqlUpdateCliente)) {
                ps1.setString(1, nombre);
                ps1.setString(2, email);
                ps1.setString(3, telefono);
                ps1.setInt(4, edad);
                ps1.setInt(5, id);
                ps1.executeUpdate();
            }

            // 2. Actualizar clase
            try (PreparedStatement ps2 = conn.prepareStatement(sqlDeleteClase)) {
                ps2.setInt(1, id);
                ps2.executeUpdate();
            }
            registrarClaseCliente(conn, id, claseNombre);

            // 3. Actualizar suscripción
            try (PreparedStatement ps3 = conn.prepareStatement(sqlDeleteSus)) {
                ps3.setInt(1, id);
                ps3.executeUpdate();
            }
            registrarSuscripcionCliente(conn, id, plazo);

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
