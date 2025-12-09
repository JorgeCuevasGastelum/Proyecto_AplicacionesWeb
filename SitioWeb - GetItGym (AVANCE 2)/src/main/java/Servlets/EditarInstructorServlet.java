/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlets;

import Controlador.ClaseGymDAO;
import Controlador.InstructorDAO;
import Modelo.ClaseGym;
import Modelo.Instructor;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author jorge
 */
public class EditarInstructorServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet EditarInstructorServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditarInstructorServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        InstructorDAO instructorDAO = new InstructorDAO();
        ClaseGymDAO claseDAO = new ClaseGymDAO();

        // 1. Cargar lista de instructores
        List<Instructor> listaInstructores = instructorDAO.listarInstructores();

        // 2. Cargar lista de clases (para mostrar catálogo)
        List<ClaseGym> listaClases = claseDAO.obtenerTodas();

        // 3. Crear mapa: idInstructor -> lista de ids de clases
        Map<Integer, List<Integer>> clasesPorInstructor = new HashMap<>();

        for (Instructor inst : listaInstructores) {
            List<Integer> clases = instructorDAO.obtenerClasesPorInstructor(inst.getId());
            clasesPorInstructor.put(inst.getId(), clases);
        }

        // 4. Enviar atributos al JSP
        request.setAttribute("listaInstructores", listaInstructores);
        request.setAttribute("listaClases", listaClases);
        request.setAttribute("clasesPorInstructor", clasesPorInstructor);

        // 5. Redirigir a tu dashboard
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // ==============================
            // 1) Recibir parámetros
            // ==============================
            int id = Integer.parseInt(request.getParameter("id"));
            String nombre = request.getParameter("nombre");
            String email = request.getParameter("email");
            String telefono = request.getParameter("telefono");
            String especialidad = request.getParameter("especialidad");

            String clasesCSV = request.getParameter("clasesSeleccionadas");
            List<Integer> clasesSeleccionadas = new ArrayList<>();

            if (clasesCSV != null && !clasesCSV.trim().isEmpty()) {
                for (String s : clasesCSV.split(",")) {
                    clasesSeleccionadas.add(Integer.parseInt(s.trim()));
                }
            }

            // ==============================
            // 2) Actualizar datos del instructor
            // ==============================
            InstructorDAO dao = new InstructorDAO();
            Instructor ins = new Instructor();

            ins.setId(id);
            ins.setNombre(nombre);
            ins.setEmail(email);
            ins.setTelefono(telefono);
            ins.setEspecialidad(especialidad);

            dao.actualizar(ins);  // YA DEBE EXISTIR EN TU DAO

            // ==============================
            // 3) Actualizar tabla instructores_clases
            // ==============================
            // Borrar asignaciones anteriores
            dao.eliminarClasesDeInstructor(id);

            // Insertar nuevas asignaciones
            for (Integer idClase : clasesSeleccionadas) {
                dao.insertarClaseAInstructor(id, idClase);
            }

            // ==============================
            // 4) Redireccionar al panel
            // ==============================
            request.setAttribute("mensaje", "Instructor actualizado correctamente.");
            request.getRequestDispatcher("AdminDashboardServlet?view=instructores").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error al editar instructor: " + e.getMessage());
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
