/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Servlets;

import Controlador.CatalogosDAO;
import Controlador.ClienteDAO;
import Controlador.InstructorDAO;
import Modelo.Cliente;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author infemovdev
 */
@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

  // 1. Verificar sesión (Seguridad)
        HttpSession session = request.getSession(false);
        
        // CORRECCIÓN: Obtenemos el rol guardado
        String rol = (session != null) ? (String) session.getAttribute("rol") : null;

        // Validamos:
        // 1. Que la sesión exista
        // 2. Que el rol no sea nulo
        // 3. Que el rol sea explícitamente "ADMIN"
        if (session == null || rol == null || !rol.equals("ADMIN")) {
            response.sendRedirect("login.jsp"); 
            return;
        }

        // 2. Obtener datos de la BD (Igual que antes)
        ClienteDAO clienteDao = new ClienteDAO();
        List<Cliente> listaClientes = clienteDao.listarClientes();
        
        CatalogosDAO catDao = new CatalogosDAO();
        request.setAttribute("totalClientes", catDao.obtenerTotalClientes());
        request.setAttribute("totalClases", catDao.obtenerTotalClases());
        request.setAttribute("suscripcionTop", catDao.obtenerSuscripcionMasUsada());
        
        InstructorDAO instructorDAO = new InstructorDAO();
        request.setAttribute("listaInstructores", instructorDAO.listarInstructores());

        // 3. Pasarlos al JSP
        request.setAttribute("misClientes", listaClientes);
        request.getRequestDispatcher("panelAdministradores.jsp").forward(request, response);
    }
}