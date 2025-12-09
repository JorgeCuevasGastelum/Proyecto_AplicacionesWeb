package Controlador;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminDAO {

    /**
     * Verifica si las credenciales corresponden a un administrador.
     * @param usuario El nombre de usuario (ej: 'admin')
     * @param password La contraseña
     * @return true si es válido, false si no
     */
    public boolean loginAdmin(String usuario, String password) {
        // Tu tabla se llama 'administradores' y tiene columnas 'usuario' y 'password'
        String sql = "SELECT id FROM administradores WHERE usuario = ? AND password = ?";
        
        try (Connection conn = Conexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, usuario);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                // Si rs.next() es true, significa que encontró un registro coincidente
                return rs.next(); 
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}