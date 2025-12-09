<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Modelo.Cliente"%>
<%@page import="Modelo.Instructor"%>
<%@page import="Modelo.ClaseGym"%>
<%@page import="Controlador.CatalogosDAO"%>

<%
    // Seguridad
    HttpSession ses = request.getSession(false);
    String rol = (ses != null) ? (String) ses.getAttribute("rol") : null;
    if (ses == null || rol == null || !rol.equals("ADMIN")) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Datos
    CatalogosDAO catDao = new CatalogosDAO();
    List<ClaseGym> listaClases = catDao.obtenerClases();
    List<Cliente> misClientes = (List<Cliente>) request.getAttribute("misClientes");
    List<Instructor> listaInstructores = (List<Instructor>) request.getAttribute("listaInstructores");

    // Estadísticas
    Object totalClientesObj = request.getAttribute("totalClientes");
    String totalClientes = totalClientesObj != null ? totalClientesObj.toString() : "0";
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Panel - Get It Gym</title>
    
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/font-awesome.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap4.min.css">
    <link rel="stylesheet" href="assets/css/panelAdmin.css">
</head>
<body>

    <div class="overlay" onclick="toggleMenu()"></div>

    <div class="sidebar" id="sidebar">
        <div class="logo-box">
            <h3>GET IT <span>GYM</span></h3>
        </div>
        
        <div class="sidebar-menu">
            <a href="#" class="active" onclick="cambiarVista('estadisticas', this)">
                <i class="fa fa-bar-chart"></i> Estadísticas
            </a>
            <a href="#" onclick="cambiarVista('usuarios', this)">
                <i class="fa fa-users"></i> Usuarios
            </a>
            <a href="#" onclick="cambiarVista('instructores', this)">
                <i class="fa fa-graduation-cap"></i> Instructores
            </a>
            <a href="#" onclick="cambiarVista('clases', this)">
                <i class="fa fa-trophy"></i> Clases
            </a>
        </div>

        <div class="logout-box">
            <a href="AuthServlet" class="btn-logout">
                <i class="fa fa-sign-out"></i> Cerrar Sesión
            </a>
        </div>
    </div>

    <div class="main-content">
        <button class="mobile-toggle" onclick="toggleMenu()"><i class="fa fa-bars"></i></button>

        <div id="estadisticas" class="content-section active">
            <h2>Dashboard General</h2>
            <div class="row">
                <div class="col-md-4 mb-3">
                    <div class="stat-card">
                        <i class="fa fa-users fa-3x" style="color: #fb030a; margin-bottom:10px;"></i>
                        <div class="stat-number"><%= totalClientes %></div>
                        <div class="stat-label">Clientes</div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="stat-card">
                        <i class="fa fa-trophy fa-3x" style="color: #fb030a; margin-bottom:10px;"></i>
                        <div class="stat-number"><%= (listaClases != null) ? listaClases.size() : 0 %></div>
                        <div class="stat-label">Clases</div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="stat-card">
                        <i class="fa fa-graduation-cap fa-3x" style="color: #fb030a; margin-bottom:10px;"></i>
                        <div class="stat-number"><%= (listaInstructores != null) ? listaInstructores.size() : 0 %></div>
                        <div class="stat-label">Instructores</div>
                    </div>
                </div>
            </div>
        </div>

        <div id="usuarios" class="content-section">
            <div class="card-dark">
                <div class="card-header-flex">
                    <h2>Gestión de Usuarios</h2>
                </div>
                <div class="table-responsive">
                    <table id="tablaUsuarios" class="table table-bordered" style="width:100%">
                        <thead>
                            <tr>
                                <th>Nombre</th>
                                <th>Email</th>
                                <th>Teléfono</th>
                                <th>Clase</th>
                                <th>Plan</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (misClientes != null) { for (Cliente cli : misClientes) { %>
                            <tr>
                                <td><%= cli.getNombre() %></td>
                                <td><%= cli.getEmail() %></td>
                                <td><%= cli.getTelefono() %></td>
                                <td><%= cli.getClase() != null ? cli.getClase() : "-" %></td>
                                <td><%= cli.getPlazo() != null ? cli.getPlazo() : "-" %></td>
                                <td>
                                    <button class="btn btn-sm btn-info" onclick="alert('Editar')"><i class="fa fa-pencil"></i></button>
                                    <button class="btn btn-sm btn-danger" onclick="eliminarCliente(<%= cli.getId() %>)"><i class="fa fa-trash"></i></button>
                                </td>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div id="instructores" class="content-section">
            <div class="card-dark">
                <div class="card-header-flex">
                    <h2>Instructores</h2>
                    <button class="btn-neon" onclick="alert('Modal Nuevo')"><i class="fa fa-plus"></i> Nuevo</button>
                </div>
                <div class="table-responsive">
                    <table id="tablaInstructores" class="table table-bordered" style="width:100%">
                        <thead>
                            <tr>
                                <th>Nombre</th>
                                <th>Especialidad</th>
                                <th>Email</th>
                                <th>Clases</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (listaInstructores != null) { for (Instructor i : listaInstructores) { %>
                            <tr>
                                <td><%= i.getNombre() %></td>
                                <td><%= i.getEspecialidad() %></td>
                                <td><%= i.getEmail() %></td>
                                <td><%= i.getClases() != null ? i.getClases() : "-" %></td>
                                <td>
                                    <button class="btn btn-sm btn-danger"><i class="fa fa-trash"></i></button>
                                </td>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div id="clases" class="content-section">
            <div class="card-header-flex">
                <h2>Catálogo de Clases</h2>
            </div>
            <div class="row">
                <% if (listaClases != null) { for (ClaseGym c : listaClases) { %>
                <div class="col-md-4 mb-4">
                    <div class="card-dark text-center" style="border-top: 3px solid #fb030a;">
                        <br>
                        <i class="fa fa-trophy fa-3x" style="color: #fb030a; margin-bottom:15px;"></i>
                        <h4><%= c.getNombre() %></h4>
                        <p style="color:#aaa;">ID: <%= c.getId() %></p>
                    </div>
                </div>
                <% } } %>
            </div>
        </div>

    </div>

    <script src="assets/js/jquery-2.1.0.min.js"></script>
    <script src="assets/js/popper.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        function toggleMenu() {
            document.getElementById('sidebar').classList.toggle('active');
            document.querySelector('.overlay').classList.toggle('active');
        }

        function cambiarVista(id, btn) {
            $('.content-section').removeClass('active');
            $('#' + id).addClass('active');
            $('.sidebar a').removeClass('active');
            $(btn).addClass('active');
            if(window.innerWidth < 992) toggleMenu();
        }

        function eliminarCliente(id) {
            Swal.fire({
                title: '¿Eliminar?',
                text: "No podrás revertir esto",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#fb030a',
                cancelButtonColor: '#333',
                confirmButtonText: 'Sí, eliminar',
                background: '#1e1e1e', color: '#fff'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = "EliminarClienteServlet?id=" + id;
                }
            })
        }

        // DATATABLES EN ESPAÑOL (HARDCODED PARA QUE NO FALLE)
        $(document).ready(function() {
            var idiomaEsp = {
                "sProcessing":     "Procesando...",
                "sLengthMenu":     "Mostrar _MENU_ registros",
                "sZeroRecords":    "No se encontraron resultados",
                "sEmptyTable":     "Ningún dato disponible en esta tabla",
                "sInfo":           "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
                "sInfoEmpty":      "Mostrando registros del 0 al 0 de un total de 0 registros",
                "sInfoFiltered":   "(filtrado de un total de _MAX_ registros)",
                "sSearch":         "Buscar:",
                "sInfoThousands":  ",",
                "sLoadingRecords": "Cargando...",
                "oPaginate": {
                    "sFirst":    "Primero",
                    "sLast":     "Último",
                    "sNext":     "Siguiente",
                    "sPrevious": "Anterior"
                },
                "oAria": {
                    "sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
                    "sSortDescending": ": Activar para ordenar la columna de manera descendente"
                }
            };

            $('#tablaUsuarios').DataTable({ "language": idiomaEsp, "lengthChange": false, "pageLength": 8 });
            $('#tablaInstructores').DataTable({ "language": idiomaEsp, "lengthChange": false, "pageLength": 8 });
        });
    </script>
</body>
</html>