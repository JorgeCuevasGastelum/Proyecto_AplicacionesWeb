package Servlets;

import Controlador.ClienteDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class EliminarClienteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        // Validación simple
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("AdminDashboardServlet?view=usuarios&error=IdInvalido");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);

            ClienteDAO dao = new ClienteDAO();
            boolean eliminado = dao.eliminarCliente(id);

            if (eliminado) {
                // Redirigimos con la vista 'usuarios' y mensaje de éxito
                response.sendRedirect("AdminDashboardServlet?view=usuarios&msg=UsuarioEliminado");
            } else {
                response.sendRedirect("AdminDashboardServlet?view=usuarios&error=NoEliminado");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminDashboardServlet?view=usuarios&error=Server");
        }
    }
}