/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Servlets;

import Controlador.CatalogosDAO;
import Controlador.ClienteDAO;
import Controlador.InstructorDAO;
import Modelo.Cliente;
import Modelo.Instructor;
import java.io.IOException;
import java.util.ArrayList;
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

        HttpSession session = request.getSession(false);
        String rol = (session != null) ? (String) session.getAttribute("rol") : null;

        if (session == null || rol == null || !rol.equals("ADMIN")) {
            response.sendRedirect("login.jsp");
            return;
        }

        // ⭐ NUEVO
        String view = request.getParameter("view");
        if (view != null) {
            request.setAttribute("view", view);
        }

        ClienteDAO clienteDao = new ClienteDAO();
        List<Cliente> listaClientes = clienteDao.listarClientes();

        CatalogosDAO catDao = new CatalogosDAO();
        request.setAttribute("totalClientes", catDao.obtenerTotalClientes());
        request.setAttribute("totalClases", catDao.obtenerTotalClases());
        request.setAttribute("suscripcionTop", catDao.obtenerSuscripcionMasUsada());

        InstructorDAO instructorDAO = new InstructorDAO();
        request.setAttribute("listaInstructores", instructorDAO.listarInstructores());

        request.setAttribute("misClientes", listaClientes);

        request.getRequestDispatcher("panelAdministradores.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("editarInstructor".equals(action)) {
            procesarEdicionInstructor(request, response);
            return;
        }

        if ("eliminarInstructor".equals(action)) {
            procesarEliminacionInstructor(request, response);
            return;
        }
        

        response.sendRedirect("AdminDashboardServlet");
    }

    // =======================================================
    // MÉTODO PARA ELIMINAR INSTRUCTOR
    // =======================================================
    private void procesarEliminacionInstructor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("idInstructor"));

            InstructorDAO dao = new InstructorDAO();
            dao.eliminar(id);

            // Recargar dashboard igual que en doGet y en editar
            cargarDashboard(request);

            request.setAttribute("msg", "InstructorEliminado");

            request.getRequestDispatcher("panelAdministradores.jsp?view=instructores")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminDashboardServlet?error=1");
        }
    }

    // =======================================================
    // MÉTODO COMPARTIDO PARA CARGAR TODO EL DASHBOARD
    // =======================================================
    private void cargarDashboard(HttpServletRequest request) {

        ClienteDAO clienteDao = new ClienteDAO();
        List<Cliente> listaClientes = clienteDao.listarClientes();

        CatalogosDAO catDao = new CatalogosDAO();
        request.setAttribute("totalClientes", catDao.obtenerTotalClientes());
        request.setAttribute("totalClases", catDao.obtenerTotalClases());
        request.setAttribute("suscripcionTop", catDao.obtenerSuscripcionMasUsada());

        InstructorDAO instructorDAO = new InstructorDAO();
        request.setAttribute("listaInstructores", instructorDAO.listarInstructores());

        request.setAttribute("misClientes", listaClientes);
    }

    // =======================================================
    // VALIDAR SESIÓN
    // =======================================================
    private boolean validarSesion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        String rol = (session != null) ? (String) session.getAttribute("rol") : null;

        if (session == null || rol == null || !rol.equals("ADMIN")) {
            response.sendRedirect("login.jsp");
            return false;
        }
        return true;
    }

    // =======================================================
    // EDITAR (NO MODIFICADO — YA FUNCIONABA)
    // =======================================================
    private void procesarEdicionInstructor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("idInstructor"));
            String nombre = request.getParameter("nombre");
            String email = request.getParameter("email");
            String telefono = request.getParameter("telefono");
            String especialidad = request.getParameter("especialidad");

            String clasesStr = request.getParameter("clasesAsignadasHidden");
            List<Integer> clasesAsignadas = new ArrayList<>();

            if (clasesStr != null && !clasesStr.trim().isEmpty()) {
                for (String c : clasesStr.split(",")) {
                    clasesAsignadas.add(Integer.parseInt(c));
                }
            }

            InstructorDAO dao = new InstructorDAO();
            dao.actualizar(new Instructor(id, nombre, email, telefono, especialidad, clasesStr, clasesAsignadas, true));

            cargarDashboard(request);

            request.getRequestDispatcher("panelAdministradores.jsp?view=instructores")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("panelAdministradores.jsp?error=1");
        }
    }
}
