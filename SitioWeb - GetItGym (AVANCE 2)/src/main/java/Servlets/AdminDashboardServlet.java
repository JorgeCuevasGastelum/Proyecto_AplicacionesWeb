/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Servlets;

import javax.servlet.annotation.WebServlet;
import Controlador.ClienteDAO;
import Modelo.Cliente;
import java.io.IOException;
import java.io.PrintWriter;
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
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("loginPanelAdmin.jsp");
            return;
        }

        // 2. Obtener datos de la BD
        ClienteDAO clienteDao = new ClienteDAO();
        List<Cliente> listaClientes = clienteDao.listarClientes();

        // 3. Pasarlos al JSP
        request.setAttribute("misClientes", listaClientes);
        request.getRequestDispatcher("panelAdministradores.jsp").forward(request, response);
    }
}
