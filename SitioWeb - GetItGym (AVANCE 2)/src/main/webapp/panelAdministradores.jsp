<%-- 
    Document   : panelAdministradores
    Created on : 15 nov 2025
    Author     : jorge
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- IMPORTACIONES PARA LA LISTA --%>
<%@page import="java.util.List"%>
<%@page import="Modelo.Cliente"%>

<%
    // Validación de seguridad: Si no hay admin en sesión, patada al login
    HttpSession ses = request.getSession(false);
    if (ses == null || ses.getAttribute("admin") == null) {
        response.sendRedirect("loginPanelAdmin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Panel Administrador - Get It Gym</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/font-awesome.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/templatemo-training-studio.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/loginCSS.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/panelAdmin.css">
    </head>

    <body>

        <header class="header-area header-sticky">
            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <nav class="main-nav">
                            <a href="index.html" class="logo">GET IT<em> GYM</em></a>
                            <ul class="nav">
                                <%-- Aquí podríamos poner un link a un LogoutServlet --%>
                                <li class="main-button"><a href="index.html">CERRAR SESION</a></li>
                            </ul>
                            <a class='menu-trigger'><span>Menú</span></a>
                        </nav>
                    </div>
                </div>
            </div>
        </header>

        <div class="container-fluid" id="content">
            <div class="row">
                <div class="col-lg-3" id="sidebar">
                    <h5>Menú Admin</h5>
                    <a href="#usuarios">Usuarios Registrados</a>
                    <a href="#clases">Clases Disponibles</a>
                    <a href="#instructores">Instructores</a>
                    <a href="#estadisticas">Estadísticas</a>
                </div>

                <div class="col-lg-9">

                    <section id="usuarios" class="dashboard-card">
                        <h2><i class="fa fa-users"></i> Usuarios Registrados</h2>
                        <button class="btn btn-success btn-sm mb-2" onclick="agregarUsuario()">Agregar Usuario</button>

                        <div class="table-responsive">
                            <table class="table table-bordered" id="tabla-usuarios">
                                <thead>
                                    <tr>
                                        <th>Nombre</th>
                                        <th>Email</th>
                                        <th>Teléfono</th>
                                        <th>Clase</th>
                                        <th>Pase</th>
                                        <th>Edad</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        // Recibimos la lista que nos mandó el Servlet
                                        List<Cliente> misClientes = (List<Cliente>) request.getAttribute("misClientes");

                                        if (misClientes != null && !misClientes.isEmpty()) {
                                            for (Cliente cli : misClientes) {
                                    %>
                                    <tr>
                                        <td><%= cli.getNombre()%></td>
                                        <td><%= cli.getEmail()%></td>
                                        <td><%= cli.getTelefono()%></td>
                                        <td><%= (cli.getClase() != null) ? cli.getClase() : "Sin clase"%></td>
                                        <td><%= (cli.getPlazo() != null) ? cli.getPlazo() : "Sin pase"%></td>
                                        <td><%= cli.getEdad()%></td>
                                        <td>
                                            <button class="btn btn-primary btn-sm btn-crud" onclick="editarFila(this)">Editar</button>
                                            <button class="btn btn-danger btn-sm btn-crud" 
                                                    onclick="eliminarCliente('<%= cli.getId()%>')">Eliminar</button>

                                        </td>
                                    </tr>
                                    <%
                                        } // Fin del for
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="7" class="text-center">No hay usuarios registrados o no se cargaron los datos.</td>
                                    </tr>
                                    <% }%>
                                </tbody>
                            </table>
                        </div>
                    </section>

                    <section id="clases" class="dashboard-card">
                        <h2><i class="fa fa-dumbbell"></i> Clases Disponibles</h2>
                        <button class="btn btn-success btn-sm mb-2">Agregar Clase</button>
                        <div class="row" id="clases-container">
                            <div class="col-md-6 class-card">
                                <h5>Yoga</h5>
                                <p>Cupo: 20 personas</p>
                                <div class="progress">
                                    <div class="progress-bar progress-bar-yoga" style="width:60%;">60%</div>
                                </div>
                            </div>
                            <div class="col-md-6 class-card">
                                <h5>Body Building</h5>
                                <p>Cupo: 15 personas</p>
                                <div class="progress">
                                    <div class="progress-bar progress-bar-body" style="width:53%;">53%</div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <section id="instructores" class="dashboard-card">
                        <h2><i class="fa fa-chalkboard-teacher"></i> Instructores</h2>
                        <p>Sección en construcción...</p>
                    </section>

                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/jquery-2.1.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/popper.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

        <script>
                                                        $(document).ready(function () {
                                                            $('.progress-bar').each(function () {
                                                                var width = $(this).attr('style').match(/width:(\d+)%/)[1];
                                                                $(this).css('width', '0').animate({width: width + '%'}, 1200);
                                                            });
                                                        });

                                                        // Funciones JS solo para efectos visuales por ahora
                                                        function editarFila(btn) {
                                                            alert("Funcionalidad de edición pendiente de conectar al Servlet");
                                                        }
                                                        function eliminarCliente(idCliente) {
                                                            if (!confirm("¿Seguro que deseas eliminar este cliente?")) {
                                                                return;
                                                            }

                                                            fetch("EliminarClienteServlet?id=" + idCliente, {method: "GET"})
                                                                    .then(r => r.text())
                                                                    .then(resp => {
                                                                        if (resp.trim() === "OK") {
                                                                            alert("Cliente eliminado exitosamente");
                                                                            location.reload(); // refresca la tabla
                                                                        } else {
                                                                            alert("Error eliminando cliente: " + resp);
                                                                        }
                                                                    })
                                                                    .catch(err => alert("Error en la petición: " + err));
                                                        }

                                                        function agregarUsuario() {
                                                            alert("Para agregar usuarios, use el formulario de Registro público.");
                                                        }
        </script>
    </body>
</html>