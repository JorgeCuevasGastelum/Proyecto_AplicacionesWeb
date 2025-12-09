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

    private void registrar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        // 1. Recoger datos del instructor
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String telefono = request.getParameter("telefono");
        String especialidad = request.getParameter("especialidad");

        // 2. Recoger el String de las clases del input hidden
        String clasesStr = request.getParameter("clasesSeleccionadas"); // "1,5,2"

        Instructor instructor = new Instructor();
        instructor.setNombre(nombre);
        instructor.setEmail(email);
        instructor.setTelefono(telefono);
        instructor.setEspecialidad(especialidad);

        // 3. INSERTAR Y OBTENER EL ID (Paso Crítico)
        // Tu método insertar devuelve el ID generado (ej: 15)
        int idNuevoInstructor = instructorDAO.insertar(instructor);

        // 4. Si el ID es válido (>0), procedemos a guardar las relaciones
        if (idNuevoInstructor > 0) {

            System.out.println("Instructor creado con ID: " + idNuevoInstructor);

            if (clasesStr != null && !clasesStr.isEmpty()) {
                // Separamos "1,5" en ["1", "5"]
                String[] ids = clasesStr.split(",");

                for (String idClaseStr : ids) {
                    try {
                        if (!idClaseStr.trim().isEmpty()) {
                            int idClase = Integer.parseInt(idClaseStr.trim());

                            // 5. LLAMAMOS AL DAO PARA CREAR LA RELACIÓN
                            // Esto llena la tabla 'instructores_clases'
                            instructorDAO.asignarClase(idNuevoInstructor, idClase);

                            System.out.println(" -> Relación creada: Instructor " + idNuevoInstructor + " con Clase " + idClase);
                        }
                    } catch (NumberFormatException e) {
                        System.out.println("Error parseando ID clase: " + idClaseStr);
                    }
                }
            }

            // Todo salió bien
            response.sendRedirect("AdminDashboardServlet?view=instructores&msg=UsuarioCreado");
        } else {
            // Falló al crear (probablemente email duplicado)
            response.sendRedirect("AdminDashboardServlet?view=instructores&error=ErrorAlCrear");
        }
    }

    /* ===================== ELIMINAR ===================== */
    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        instructorDAO.eliminar(id);

        response.sendRedirect("InstructorServlet");
    }
}
