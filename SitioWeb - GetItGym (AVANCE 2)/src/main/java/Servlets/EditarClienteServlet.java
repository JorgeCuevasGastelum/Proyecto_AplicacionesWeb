package Servlets;

import Controlador.ClienteDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class EditarClienteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        try {
            // 1. Recibir datos
            int id = Integer.parseInt(request.getParameter("id"));
            String nombre = request.getParameter("nombre");
            String email = request.getParameter("email");
            String telefono = request.getParameter("telefono");
            int edad = Integer.parseInt(request.getParameter("edad"));
            int idSuscripcion = Integer.parseInt(request.getParameter("idSuscripcion"));
            
            // Contraseñas
            String pass1 = request.getParameter("newPassword");
            String pass2 = request.getParameter("confirmPassword");
            String passwordFinal = null;

            // 2. Validar Contraseña (si el usuario escribió algo)
            if (pass1 != null && !pass1.isEmpty()) {
                if (!pass1.equals(pass2)) {
                    // Si no coinciden, devolvemos error y mantenemos en la vista de usuarios
                    response.sendRedirect("AdminDashboardServlet?view=usuarios&error=PasswordNoCoincide");
                    return;
                }
                passwordFinal = pass1; // Si coinciden, esta es la que guardamos
            }

            // 3. Llamar al DAO
            ClienteDAO dao = new ClienteDAO();
            boolean exito = dao.actualizarCliente(id, nombre, email, passwordFinal, telefono, edad, idSuscripcion);

            // 4. Redirigir INTELIGENTEMENTE
          if (exito) {
                // IMPORTANTE: ?view=usuarios mantiene la pestaña abierta
                // IMPORTANTE: &msg=UsuarioActualizado activa el SweetAlert verde
                response.sendRedirect("AdminDashboardServlet?view=usuarios&msg=UsuarioActualizado");
            } else {
                response.sendRedirect("AdminDashboardServlet?view=usuarios&error=ErrorAlActualizar");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminDashboardServlet?view=usuarios&error=Server");
        }
    }
}