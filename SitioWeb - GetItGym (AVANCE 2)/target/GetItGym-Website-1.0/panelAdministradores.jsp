<%-- 
    Document   : panelAdministradores
    Created on : 15 nov 2025
    Author     : jorge
--%>

<%@page import="Modelo.ClaseGym"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- IMPORTACIONES PARA LA LISTA --%>
<%@page import="java.util.List"%>
<%@page import="Modelo.Cliente"%>
<%-- IMPORTACIONES NECESARIAS PARA TRAER DATOS DE BD --%>
<%@page import="Modelo.Suscripcion"%>
<%@page import="Controlador.CatalogosDAO"%>
<%
    // Instanciamos el DAO y traemos las listas de la BD
    CatalogosDAO catDao = new CatalogosDAO();
    List<ClaseGym> listaClases = catDao.obtenerClases();
    List<Suscripcion> listaSuscripciones = catDao.obtenerSuscripciones();
%>
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
                                            <button class="btn btn-primary btn-sm btn-crud"
                                                    onclick="abrirModalEditar(
                                                                    '<%= cli.getId()%>',
                                                                    '<%= cli.getNombre()%>',
                                                                    '<%= cli.getEmail()%>',
                                                                    '<%= cli.getTelefono()%>',
                                                                    '<%= cli.getClase()%>',
                                                                    '<%= cli.getPlazo()%>',
                                                                    '<%= cli.getEdad()%>'
                                                                    )">
                                                Editar
                                            </button>


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
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
                                                        $(document).ready(function () {
                                                            $('.progress-bar').each(function () {
                                                                var width = $(this).attr('style').match(/width:(\d+)%/)[1];
                                                                $(this).css('width', '0').animate({width: width + '%'}, 1200);
                                                            });
                                                        });

                                                        function abrirModalEditar(id, nombre, email, telefono, clase, plazo, edad) {

                                                            document.getElementById("edit-id").value = id;
                                                            document.getElementById("edit-nombre").value = nombre;
                                                            document.getElementById("edit-email").value = email;
                                                            document.getElementById("edit-telefono").value = telefono;

                                                            // ---- MANEJO SEGURO DE LA CLASE ----
                                                            if (!clase || clase === "null" || clase === "Sin clase") {
                                                                document.getElementById("edit-clase").value = "";
                                                            } else {
                                                                document.getElementById("edit-clase").value = clase;
                                                            }

                                                            // ---- MANEJO SEGURO DE PASE ----
                                                            if (!plazo || plazo === "null" || plazo === "Sin pase") {
                                                                document.getElementById("edit-plazo").value = "";
                                                            } else {
                                                                document.getElementById("edit-plazo").value = plazo;
                                                            }

                                                            document.getElementById("edit-edad").value = edad;

                                                            $("#modalEditar").modal("show");
                                                        }




                                                        function editarFilaCliente(btn) {

                                                            let fila = btn.closest("tr");
                                                            let columnas = fila.getElementsByTagName("td");

                                                            let idCliente = btn.getAttribute("data-id");

                                                            if (!idCliente || idCliente.trim() === "") {
                                                                Swal.fire("Error", "No se encontró el ID del cliente", "error");
                                                                return;
                                                            }

                                                            document.getElementById("edit-id").value = idCliente;
                                                            document.getElementById("edit-nombre").value = columnas[0].innerText;
                                                            document.getElementById("edit-email").value = columnas[1].innerText;
                                                            document.getElementById("edit-telefono").value = columnas[2].innerText;

                                                            document.getElementById("edit-clase").value =
                                                                    (columnas[3].innerText === "Sin clase" ? "" : columnas[3].innerText.trim());


                                                            document.getElementById("edit-plazo").value = plazo;

                                                            document.getElementById("edit-edad").value = columnas[5].innerText;

                                                            $("#modalEditar").modal("show");
                                                        }


                                                        function eliminarCliente(idCliente) {

                                                            Swal.fire({
                                                                title: "¿Eliminar cliente?",
                                                                text: "Esta acción no se puede deshacer.",
                                                                icon: "warning",
                                                                showCancelButton: true,
                                                                confirmButtonText: "Eliminar",
                                                                cancelButtonText: "Cancelar"
                                                            }).then((result) => {

                                                                if (result.isConfirmed) {

                                                                    fetch("EliminarClienteServlet?id=" + idCliente, {method: "GET"})
                                                                            .then(r => r.text())
                                                                            .then(resp => {

                                                                                if (resp.trim() === "OK") {
                                                                                    Swal.fire("Eliminado", "El cliente fue eliminado exitosamente", "success")
                                                                                            .then(() => location.reload());
                                                                                } else {
                                                                                    Swal.fire("Error", resp, "error");
                                                                                }

                                                                            })
                                                                            .catch(err => Swal.fire("Error en la petición", err, "error"));
                                                                }
                                                            });
                                                        }



                                                        function agregarUsuario() {
                                                            alert("Para agregar usuarios, use el formulario de Registro público.");
                                                        }
                                                        function validarFormularioEditar() {
                                                            const nombre = document.getElementById("edit-nombre").value.trim();
                                                            const email = document.getElementById("edit-email").value.trim();
                                                            const telefono = document.getElementById("edit-telefono").value.trim();
                                                            const clase = document.getElementById("edit-clase").value.trim();
                                                            const plazo = document.getElementById("edit-plazo").value.trim();
                                                            const edad = document.getElementById("edit-edad").value.trim();
                                                            const id = document.getElementById("edit-id").value.trim();

                                                            if (id === "") {
                                                                Swal.fire("Error", "No se encontró el ID del cliente.", "error");
                                                                return;
                                                            }

                                                            if (nombre === "" || email === "" || edad === "") {
                                                                Swal.fire("Campos incompletos", "Por favor llena todos los campos obligatorios.", "warning");
                                                                return;
                                                            }

                                                            // Si pasa todo → ENVIAR FORMULARIO
                                                            document.getElementById("formEditarCliente").submit();
                                                        }


                                                        document.getElementById("formEditarCliente").addEventListener("submit", function (e) {
                                                            let id = document.getElementById("edit-id").value.trim();
                                                            let nombre = document.getElementById("edit-nombre").value.trim();
                                                            let email = document.getElementById("edit-email").value.trim();
                                                            let edad = document.getElementById("edit-edad").value.trim();

                                                            if (id === "" || nombre === "" || email === "" || edad === "") {
                                                                e.preventDefault();
                                                                Swal.fire({
                                                                    icon: "error",
                                                                    title: "Campos vacíos",
                                                                    text: "Debes llenar todos los campos.",
                                                                });
                                                                return;
                                                            }

                                                            if (isNaN(edad) || edad <= 0) {
                                                                e.preventDefault();
                                                                Swal.fire({
                                                                    icon: "error",
                                                                    title: "Edad inválida",
                                                                    text: "Ingresa un número válido de edad.",
                                                                });
                                                                return;
                                                            }
                                                        });



        </script>
        <style>
            #modalEditar label {
                color: black !important;
                font-weight: bold;
            }
        </style>

        <!-- MODAL EDITAR CLIENTE -->
        <div class="modal fade" id="modalEditar" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">

                    <div class="modal-header">
                        <h5 class="modal-title">Editar Cliente</h5>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>

                    <form id="formEditarCliente" method="POST" action="EditarClienteServlet">
                        <div class="modal-body">

                            <input type="hidden" name="id" id="edit-id">

                            <div class="form-group">
                                <label>Nombre</label>
                                <input type="text" id="edit-nombre" name="nombre" class="form-control" required>
                            </div>

                            <div class="form-group">
                                <label>Email</label>
                                <input type="email" id="edit-email" name="email" class="form-control" required>
                            </div>

                            <div class="form-group">
                                <label>Teléfono</label>
                                <input type="text" id="edit-telefono" name="telefono" class="form-control">
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label text-dark">Clase</label>
                                <select name="clase" id="edit-clase" class="form-control">
                                    <option value="">-- Selecciona una clase --</option>
                                    <% for (ClaseGym c : listaClases) {%>
                                    <option value="<%= c.getNombre()%>">
                                        <%= c.getNombre()%>
                                    </option>
                                    <% }%>
                                </select>
                            </div>


                            <div class="col-md-6 mb-3">
                                <label class="form-label text-dark">Pase</label>
                                <select name="plazo" id="edit-plazo" class="form-control" required>
                                    <option value="">-- Selecciona el tipo de pase --</option>
                                    <% for (Suscripcion s : listaSuscripciones) {%>
                                    <option value="<%= s.getTipo()%>">
                                        <%= s.getTipo()%> - $<%= s.getPrecio()%>
                                    </option>
                                    <% }%>
                                </select>
                            </div>


                            <div class="form-group">
                                <label>Edad</label>
                                <input type="number" id="edit-edad" name="edad" class="form-control" required>
                            </div>

                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-primary" onclick="validarFormularioEditar()">Guardar Cambios</button>
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                        </div>
                    </form>

                </div>
            </div>
        </div>

    </body>
</html>