package Servlets;

import Controlador.AdminDAO;
import Controlador.ClienteDAO;
import Modelo.Cliente;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AuthServlet")
public class AuthServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Recibimos "credencial" que puede ser el Usuario (admin) o el Email (cliente)
        String credencial = request.getParameter("credencial"); 
        String password = request.getParameter("password");

        HttpSession session = request.getSession();

        // 1. PRIMERO VERIFICAMOS SI ES ADMIN
        AdminDAO adminDao = new AdminDAO();
        if (adminDao.loginAdmin(credencial, password)) {
            session.setAttribute("rol", "ADMIN");
            session.setAttribute("usuario", credencial);
            // Redirigir al Dashboard de Admin
            response.sendRedirect("AdminDashboardServlet");
            return;
        }

        // 2. SI NO ES ADMIN, VERIFICAMOS SI ES CLIENTE
        ClienteDAO clienteDao = new ClienteDAO();
        // Nota: Asumimos que el cliente usa su email como credencial
        Cliente cliente = clienteDao.loginCliente(credencial, password);
        
        if (cliente != null) {
            // Traemos los detalles completos para el perfil
            Cliente detalles = clienteDao.obtenerDetallesCliente(cliente.getId());
            
            session.setAttribute("rol", "CLIENTE");
            session.setAttribute("clienteLogueado", detalles);
            // Redirigir al Panel del Cliente
            response.sendRedirect("panelCliente.jsp");
            return;
        }

        // 3. SI LLEGAMOS AQUÍ, NO EXISTE NI UNO NI OTRO
        request.setAttribute("error", "Usuario/Email o contraseña incorrectos");
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    // Método para CERRAR SESIÓN (Logout unificado)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Destruye la sesión sea quien sea
        }
        response.sendRedirect("index.html");
    }
}