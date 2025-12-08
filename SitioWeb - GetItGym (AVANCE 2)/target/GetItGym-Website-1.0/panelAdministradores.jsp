<%-- Document : panelAdministradores
     Created on : 15 nov 2025
     Author     : jorge
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Modelo.Cliente"%>
<%@page import="Modelo.ClaseGym"%>
<%@page import="Modelo.Instructor"%>
<%@page import="Modelo.Suscripcion"%>
<%@page import="Controlador.CatalogosDAO"%>

<%-- ============================
     VALIDACIÓN SESIÓN Y DAO
     ============================ --%>
<%
    HttpSession ses = request.getSession(false);
    if (ses == null || ses.getAttribute("admin") == null) {
        response.sendRedirect("loginPanelAdmin.jsp");
        return;
    }

    // Instanciamos DAO y obtenemos listas (una sola vez)
    CatalogosDAO catDao = new CatalogosDAO();
    List<ClaseGym> listaClases = catDao.obtenerClases();
    List<Suscripcion> listaSuscripciones = catDao.obtenerSuscripciones();

    // Listas recibidas desde el servlet (si las envía)
    List<Cliente> misClientes = (List<Cliente>) request.getAttribute("misClientes");
    List<Instructor> listaInstructores = (List<Instructor>) request.getAttribute("listaInstructores");

    // Estadísticas (si vienen del servlet); si no, se muestran vacías/0
    Object totalClientesObj = request.getAttribute("totalClientes");
    Object totalClasesObj = request.getAttribute("totalClases");
    Object suscripcionTopObj = request.getAttribute("suscripcionTop");
    String totalClientes = totalClientesObj != null ? totalClientesObj.toString() : "0";
    String totalClases = totalClasesObj != null ? totalClasesObj.toString() : (listaClases != null ? String.valueOf(listaClases.size()) : "0");
    String suscripcionTop = suscripcionTopObj != null ? suscripcionTopObj.toString() : "-";
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Panel Administrador - Get It Gym</title>

        <!-- Estilos (mantén tus rutas) -->
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
                                <%-- Aquí podrías poner un link a un LogoutServlet --%>
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
                    <!-- ================= USUARIOS ================= -->
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
                                                        '<%= cli.getNombre().replace("'", "\\'")%>',
                                                        '<%= cli.getEmail().replace("'", "\\'")%>',
                                                        '<%= cli.getTelefono() != null ? cli.getTelefono().replace("'", "\\'") : ""%>',
                                                        '<%= cli.getClase() != null ? cli.getClase().replace("'", "\\'") : "Sin clase"%>',
                                                        '<%= cli.getPlazo() != null ? cli.getPlazo().replace("'", "\\'") : "Sin pase"%>',
                                                        '<%= cli.getEdad()%>'
                                                        )">
                                                Editar
                                            </button>
                                            <button class="btn btn-danger btn-sm btn-crud" onclick="eliminarCliente('<%= cli.getId()%>')">Eliminar</button>
                                        </td>
                                    </tr>
                                    <%
                                        } // fin for
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="7" class="text-center">No hay usuarios registrados o no se cargaron los datos.</td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </section>

                    <!-- ================= CLASES ================= -->
                    <section id="clases" class="dashboard-card mt-4">
                        <h2><i class="fa fa-dumbbell"></i> Clases Disponibles</h2>

                        <%
                            int cupoMaximo = 20;
                            if (listaClases != null && !listaClases.isEmpty()) {
                                for (ClaseGym c : listaClases) {
                                    int inscritos = catDao.contarInscritosPorClase(c.getId());
                                    int porcentaje = 0;
                                    if (cupoMaximo > 0) {
                                        porcentaje = (inscritos * 100) / cupoMaximo;
                                    }
                        %>
                        <div class="col-md-6 class-card mb-3">
                            <h5><%= c.getNombre()%></h5>
                            <p>Cupo: <%= inscritos%> / <%= cupoMaximo%></p>
                            <div class="progress">
                                <div class="progress-bar bg-success" style="width:<%= porcentaje%>%;">
                                    <%= porcentaje%>% 
                                </div>
                            </div>
                        </div>
                        <%
                            } // fin for clases
                        } else {
                        %>
                        <p>No hay clases registradas</p>
                        <%
                            }
                        %>
                    </section>

                    <!-- ================= INSTRUCTORES ================= -->
                    <section id="instructores" class="dashboard-card mt-4">
                        <h2><i class="fa fa-chalkboard-teacher"></i> Instructores</h2>

                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>Nombre</th>
                                        <th>Email</th>
                                        <th>Especialidad</th>
                                        <th>Clases</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        if (listaInstructores != null && !listaInstructores.isEmpty()) {
                                            for (Instructor i : listaInstructores) {
                                    %>
                                    <tr>
                                        <td><%= i.getNombre()%></td>
                                        <td><%= i.getEmail()%></td>
                                        <td><%= i.getEspecialidad()%></td>
                                        <td><%= i.getClases() != null ? i.getClases() : "Sin clases"%></td>
                                        <td>
                                            <button class="btn btn-danger btn-sm" onclick="eliminarInstructor('<%= i.getId()%>')">Eliminar</button>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="5" class="text-center">No hay instructores registrados</td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>

                        <!-- FORM AGREGAR INSTRUCTOR -->
                        <form action="InstructorServlet" method="POST" class="mt-3">
                            <input type="hidden" name="accion" value="registrar">
                            <input type="text" name="nombre" placeholder="Nombre" class="form-control mb-2" required>
                            <input type="email" name="email" placeholder="Email" class="form-control mb-2" required>
                            <input type="text" name="telefono" placeholder="Teléfono" class="form-control mb-2">
                            <input type="text" name="especialidad" placeholder="Especialidad" class="form-control mb-2">

                            <h6>Clases</h6>
                            <% if (listaClases != null) {
                            for (ClaseGym c : listaClases) {%>
                            <label>
                                <input type="checkbox" name="clasesIds" value="<%= c.getId()%>">
                                <%= c.getNombre()%>
                            </label><br>
                            <%  }
                        }%>

                            <button class="btn btn-success mt-2">Guardar Instructor</button>
                        </form>
                    </section>

                    <!-- ================= ESTADÍSTICAS ================= -->
                    <section id="estadisticas" class="dashboard-card mt-4">
                        <h2><i class="fa fa-chart-bar"></i> Estadísticas Generales</h2>
                        <div class="row">
                            <div class="col-md-4">
                                <div class="stat-card">
                                    <h4>Total de Clientes</h4>
                                    <p class="stat-number"><%= totalClientes%></p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="stat-card">
                                    <h4>Total de Clases</h4>
                                    <p class="stat-number"><%= totalClases%></p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="stat-card">
                                    <h4>Suscripción Más Usada</h4>
                                    <p class="stat-number"><%= suscripcionTop%></p>
                                </div>
                            </div>
                        </div>
                    </section>

                </div> <!-- fin col-lg-9 -->
            </div> <!-- fin row -->
        </div> <!-- fin container-fluid -->

        <!-- SCRIPTS -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery-2.1.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/popper.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <script>
                                            // Animación de barras progresivas (verifica que existan)
                                            $(document).ready(function () {
                                                $('.progress-bar').each(function () {
                                                    try {
                                                        var style = $(this).attr('style') || '';
                                                        var match = style.match(/width:(\d+)%/);
                                                        var width = match ? match[1] : 0;
                                                        $(this).css('width', '0').animate({width: width + '%'}, 1200);
                                                    } catch (e) {
                                                        // No romper si algo falla
                                                        console.error(e);
                                                    }
                                                });
                                            });

                                            function abrirModalEditar(id, nombre, email, telefono, clase, plazo, edad) {
                                                // Seguridad: si los campos no existen, no intentar asignar
                                                if (document.getElementById("edit-id")) {
                                                    document.getElementById("edit-id").value = id || "";
                                                }
                                                if (document.getElementById("edit-nombre")) {
                                                    document.getElementById("edit-nombre").value = nombre || "";
                                                }
                                                if (document.getElementById("edit-email")) {
                                                    document.getElementById("edit-email").value = email || "";
                                                }
                                                if (document.getElementById("edit-telefono")) {
                                                    document.getElementById("edit-telefono").value = telefono || "";
                                                }

                                                // Manejo seguro de clase y pase
                                                if (document.getElementById("edit-clase")) {
                                                    if (!clase || clase === "null" || clase === "Sin clase") {
                                                        document.getElementById("edit-clase").value = "";
                                                    } else {
                                                        document.getElementById("edit-clase").value = clase;
                                                    }
                                                }
                                                if (document.getElementById("edit-plazo")) {
                                                    if (!plazo || plazo === "null" || plazo === "Sin pase") {
                                                        document.getElementById("edit-plazo").value = "";
                                                    } else {
                                                        document.getElementById("edit-plazo").value = plazo;
                                                    }
                                                }
                                                if (document.getElementById("edit-edad")) {
                                                    document.getElementById("edit-edad").value = edad || "";
                                                }

                                                if (typeof $ !== 'undefined' && $("#modalEditar").length) {
                                                    $("#modalEditar").modal("show");
                                                }
                                            }

                                            function editarFilaCliente(btn) {
                                                // Esta función no se usa directamente en el código original, la dejo por compatibilidad
                                                var fila = btn.closest("tr");
                                                var columnas = fila.getElementsByTagName("td");
                                                var idCliente = btn.getAttribute("data-id");
                                                if (!idCliente || idCliente.trim() === "") {
                                                    Swal.fire("Error", "No se encontró el ID del cliente", "error");
                                                    return;
                                                }
                                                if (document.getElementById("edit-id")) {
                                                    document.getElementById("edit-id").value = idCliente;
                                                }
                                                if (document.getElementById("edit-nombre")) {
                                                    document.getElementById("edit-nombre").value = columnas[0].innerText;
                                                }
                                                if (document.getElementById("edit-email")) {
                                                    document.getElementById("edit-email").value = columnas[1].innerText;
                                                }
                                                if (document.getElementById("edit-telefono")) {
                                                    document.getElementById("edit-telefono").value = columnas[2].innerText;
                                                }
                                                if (document.getElementById("edit-clase")) {
                                                    document.getElementById("edit-clase").value = (columnas[3].innerText === "Sin clase" ? "" : columnas[3].innerText.trim());
                                                }
                                                if (document.getElementById("edit-plazo")) {
                                                    // columna 4 es el pase
                                                    document.getElementById("edit-plazo").value = (columnas[4].innerText === "Sin pase" ? "" : columnas[4].innerText.trim());
                                                }
                                                if (document.getElementById("edit-edad")) {
                                                    document.getElementById("edit-edad").value = columnas[5].innerText;
                                                }
                                                if (typeof $ !== 'undefined' && $("#modalEditar").length) {
                                                    $("#modalEditar").modal("show");
                                                }
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

                                            function eliminarInstructor(idInstructor) {
                                                Swal.fire({
                                                    title: "¿Eliminar instructor?",
                                                    text: "Esta acción no se puede deshacer.",
                                                    icon: "warning",
                                                    showCancelButton: true,
                                                    confirmButtonText: "Eliminar",
                                                    cancelButtonText: "Cancelar"
                                                }).then((result) => {
                                                    if (result.isConfirmed) {
                                                        // Redirige al servlet de instructor con accion eliminar
                                                        window.location.href = "InstructorServlet?accion=eliminar&id=" + idInstructor;
                                                    }
                                                });
                                            }

                                            function agregarUsuario() {
                                                alert("Para agregar usuarios, use el formulario de Registro público.");
                                            }

                                            function validarFormularioEditar() {
                                                const idEl = document.getElementById("edit-id");
                                                const nombreEl = document.getElementById("edit-nombre");
                                                const emailEl = document.getElementById("edit-email");
                                                const telefonoEl = document.getElementById("edit-telefono");
                                                const claseEl = document.getElementById("edit-clase");
                                                const plazoEl = document.getElementById("edit-plazo");
                                                const edadEl = document.getElementById("edit-edad");

                                                const id = idEl ? idEl.value.trim() : "";
                                                const nombre = nombreEl ? nombreEl.value.trim() : "";
                                                const email = emailEl ? emailEl.value.trim() : "";
                                                const edad = edadEl ? edadEl.value.trim() : "";

                                                if (id === "") {
                                                    Swal.fire("Error", "No se encontró el ID del cliente.", "error");
                                                    return;
                                                }
                                                if (nombre === "" || email === "" || edad === "") {
                                                    Swal.fire("Campos incompletos", "Por favor llena todos los campos obligatorios.", "warning");
                                                    return;
                                                }
                                                // enviar formulario
                                                const form = document.getElementById("formEditarCliente");
                                                if (form)
                                                    form.submit();
                                            }

                                            // Protección: si el form existe, agregar listener; si no, omitir
                                            if (document.getElementById("formEditarCliente")) {
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
                                            }
        </script>

        <style>
            /* Mantengo tu estilo mínimo para modal */
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
                                    <% if (listaClases != null) {
                                    for (ClaseGym c : listaClases) {%>
                                    <option value="<%= c.getNombre()%>"><%= c.getNombre()%></option>
                                    <%  }
                                } %>
                                </select>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label text-dark">Pase</label>
                                <select name="plazo" id="edit-plazo" class="form-control" required>
                                    <option value="">-- Selecciona el tipo de pase --</option>
                                    <% if (listaSuscripciones != null) {
                                    for (Suscripcion s : listaSuscripciones) {%>
                                    <option value="<%= s.getTipo()%>"><%= s.getTipo()%> - $<%= s.getPrecio()%></option>
                                    <%  }
                                }%>
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
