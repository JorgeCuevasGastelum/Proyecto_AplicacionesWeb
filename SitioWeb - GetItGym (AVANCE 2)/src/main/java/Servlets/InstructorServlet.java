/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Servlets;

import Controlador.CatalogosDAO;
import Controlador.InstructorDAO;
import Modelo.ClaseGym;
import Modelo.Instructor;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author aleja
 */
@WebServlet("/InstructorServlet")
public class InstructorServlet extends HttpServlet {

    InstructorDAO instructorDAO = new InstructorDAO();
    CatalogosDAO catalogosDAO = new CatalogosDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if (accion == null) {
            listar(request, response);
            return;
        }

        switch (accion) {
            case "eliminar":
                eliminar(request, response);
                break;
            default:
                listar(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if (accion == null) {
            listar(request, response);
            return;
        }

        switch (accion) {
            case "registrar":
                registrar(request, response);
                break;
            default:
                listar(request, response);
                break;
        }
    }

    /* ===================== LISTAR ===================== */
    private void listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Instructor> listaInstructores = instructorDAO.listarInstructores();
        List<ClaseGym> listaClases = catalogosDAO.obtenerClases();

        request.setAttribute("listaInstructores", listaInstructores);
        request.setAttribute("listaClases", listaClases);

        request.getRequestDispatcher("panelAdministradores.jsp")
                .forward(request, response);
    }

    /* ===================== REGISTRAR ===================== */
    private void registrar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String telefono = request.getParameter("telefono");
        String especialidad = request.getParameter("especialidad");
        String[] clasesIds = request.getParameterValues("clasesIds");

        Instructor instructor = new Instructor();
        instructor.setNombre(nombre);
        instructor.setEmail(email);
        instructor.setTelefono(telefono);
        instructor.setEspecialidad(especialidad);

        // Guardar instructor
        int idInstructor = instructorDAO.insertar(instructor);

        // Guardar relación instructor-clase
        if (clasesIds != null) {
            for (String idClase : clasesIds) {
                instructorDAO.asignarClase(idInstructor, Integer.parseInt(idClase));
            }
        }

        response.sendRedirect("InstructorServlet");
    }

    /* ===================== ELIMINAR ===================== */
    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        instructorDAO.eliminar(id);

        response.sendRedirect("InstructorServlet");
    }
}
