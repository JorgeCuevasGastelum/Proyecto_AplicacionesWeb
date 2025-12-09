<%@page import="Modelo.Suscripcion"%>
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
    List<Suscripcion> listaSuscripciones = catDao.obtenerSuscripciones();
    

    // Estadísticas
    Object totalClientesObj = request.getAttribute("totalClientes");
    String totalClientes = totalClientesObj != null ? totalClientesObj.toString() : "0";
    
// Lógica para saber qué pestaña activar
    String view = request.getParameter("view");
    String activeEstadisticas = (view == null || view.equals("estadisticas")) ? "active" : "";
    String activeUsuarios = (view != null && view.equals("usuarios")) ? "active" : "";
    String activeInstructores = (view != null && view.equals("instructores")) ? "active" : "";
    String activeClases = (view != null && view.equals("clases")) ? "active" : "";
    
    // Para el menú lateral (clase CSS)
    String menuEstadisticas = activeEstadisticas.isEmpty() ? "" : "active";
    String menuUsuarios = activeUsuarios.isEmpty() ? "" : "active";
    String menuInstructores = activeInstructores.isEmpty() ? "" : "active";
    String menuClases = activeClases.isEmpty() ? "" : "active";

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
        <a href="#" class="<%= menuEstadisticas %>" onclick="cambiarVista('estadisticas', this)">
        <i class="fa fa-bar-chart"></i> Estadísticas
    </a>
    <a href="#" class="<%= menuUsuarios %>" onclick="cambiarVista('usuarios', this)">
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

        <div id="estadisticas" class="content-section <%= activeEstadisticas %>">
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

        <div id="usuarios" class="content-section <%= activeUsuarios %>">
            <div class="card-dark">
              <div class="card-header-flex">
                    <h2><i class="fa fa-users"></i> Gestión de Usuarios</h2>
                    <a href="registroClientes.jsp" target="_blank" class="btn-neon" style="text-decoration:none;">
                        <i class="fa fa-plus"></i> Nuevo Usuario
                    </a>
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
<button class="btn btn-sm btn-info" 
        onclick="cargarDatosEditar(
            '<%= cli.getId() %>', 
            '<%= cli.getNombre() %>', 
            '<%= cli.getEmail() %>', 
            '<%= cli.getTelefono() %>', 
            '<%= cli.getEdad() %>',  <%-- NUEVO CAMPO --%>
            '<%= cli.getPlazo() %>'
        )" 
        title="Editar">
    <i class="fa fa-pencil"></i>
</button>
    
    <button class="btn btn-sm btn-danger" onclick="eliminarCliente(<%= cli.getId() %>)" title="Eliminar">
        <i class="fa fa-trash"></i>
    </button>
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
        // 1. CARGAR DATOS EN EL MODAL (Edición)
        function cargarDatosEditar(id, nombre, email, telefono, edad, planNombre) {
            // Llenar campos simples
            document.getElementById('edit_id').value = id;
            document.getElementById('edit_nombre').value = nombre;
            document.getElementById('edit_email').value = email;
            document.getElementById('edit_telefono').value = telefono;
            document.getElementById('edit_edad').value = edad;

            // Limpiar campos de contraseña
            document.getElementById('newPass').value = '';
            document.getElementById('confirmPass').value = '';

            // Seleccionar plan en el dropdown
            let select = document.getElementById('edit_suscripcion');
            if(select) {
                for (let i = 0; i < select.options.length; i++) {
                    if (select.options[i].text.toUpperCase().includes(planNombre.toUpperCase())) {
                        select.selectedIndex = i;
                        break;
                    }
                }
            }
            // Abrir el modal
            $('#modalEditarUsuario').modal('show');
        }

        // 2. NAVEGACIÓN Y MENÚ MÓVIL
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

        // 3. ELIMINAR CLIENTE
        function eliminarCliente(id) {
            Swal.fire({
                title: '¿Eliminar Usuario?',
                text: "No podrás revertir esta acción",
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

        // ==========================================
        //  ZONA SEGURA: $(document).ready
        //  Todo lo que esté aquí espera a que el HTML cargue
        // ==========================================
        $(document).ready(function() {
            
            // A. VALIDACIÓN DE CONTRASEÑAS (SOLUCIÓN DEL ERROR)
            var formEditar = document.getElementById('formEditarCliente');
            
            if (formEditar) { // Solo si el formulario existe, agregamos el evento
                formEditar.addEventListener('submit', function(event) {
                    var pass1 = document.getElementById('newPass').value;
                    var pass2 = document.getElementById('confirmPass').value;

                    // Solo validamos si escribió algo
                    if (pass1.length > 0) {
                        if (pass1 !== pass2) {
                            event.preventDefault(); // Detiene el envío
                            Swal.fire({
                                title: 'Error de Contraseña',
                                text: 'Las contraseñas no coinciden.',
                                icon: 'error',
                                confirmButtonColor: '#fb030a',
                                background: '#1e1e1e', color: '#fff'
                            });
                            return;
                        }
                        if (pass1.length < 4) {
                            event.preventDefault();
                            Swal.fire({
                                title: 'Muy corta',
                                text: 'La contraseña debe tener al menos 4 caracteres.',
                                icon: 'warning',
                                confirmButtonColor: '#fb030a',
                                background: '#1e1e1e', color: '#fff'
                            });
                            return;
                        }
                    }
                });
            } else {
                console.error("No se encontró el formulario 'formEditarCliente'. Revisa el ID en el HTML.");
            }

            // B. CONFIGURACIÓN DATATABLES (Español)
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
                }
            };

            $('#tablaUsuarios').DataTable({ "language": idiomaEsp, "lengthChange": false, "pageLength": 8 });
            $('#tablaInstructores').DataTable({ "language": idiomaEsp, "lengthChange": false, "pageLength": 8 });

            // C. ALERTAS DE URL (DETECTAR ÉXITO O ERROR AL RECARGAR)
            const urlParams = new URLSearchParams(window.location.search);
            const msg = urlParams.get('msg');
            const error = urlParams.get('error');

            if (msg === 'UsuarioActualizado') {
                Swal.fire({
                    title: '¡Actualizado!',
                    text: 'Los datos del cliente se guardaron correctamente.',
                    icon: 'success',
                    confirmButtonColor: '#fb030a',
                    background: '#1e1e1e', color: '#fff',
                    timer: 3000
                }).then(() => {
                    window.history.replaceState(null, null, window.location.pathname + "?view=usuarios");
                });
            }

            if (error === 'PasswordNoCoincide') {
                Swal.fire({
                    title: 'Error',
                    text: 'Las contraseñas no coinciden.',
                    icon: 'error',
                    confirmButtonColor: '#fb030a',
                    background: '#1e1e1e', color: '#fff'
                });
            }
            
            if (error === 'DatosIncompletos' || error === 'Server' || error === 'ErrorAlActualizar') {
                Swal.fire({
                    title: 'Error',
                    text: 'No se pudieron guardar los cambios.',
                    icon: 'error',
                    confirmButtonColor: '#fb030a',
                    background: '#1e1e1e', color: '#fff'
                });
            }
        });
    </script>
    
    
    
    <div class="modal fade" id="modalEditarUsuario" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content" style="background-color: #1e1e1e; border: 1px solid #333; color: #fff;">
            <div class="modal-header" style="border-bottom: 1px solid #333;">
                <h5 class="modal-title" style="font-weight: 700; color: #fff;">
                    <i class="fa fa-pencil" style="color: #fb030a;"></i> Editar Cliente
                </h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: #fff;">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            
            <form action="EditarClienteServlet" method="POST" id="formEditarCliente">
                <div class="modal-body">
                    <input type="hidden" name="id" id="edit_id">

                    <div class="form-row">
                        <div class="form-group col-md-8">
                            <label style="color: #bbb;">Nombre Completo</label>
                            <input type="text" name="nombre" id="edit_nombre" class="form-control" required style="background:#252525; color:#fff; border:1px solid #444;">
                        </div>
                        <div class="form-group col-md-4">
                            <label style="color: #bbb;">Edad</label>
                            <input type="number" name="edad" id="edit_edad" class="form-control" required style="background:#252525; color:#fff; border:1px solid #444;">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label style="color: #bbb;">Email</label>
                            <input type="email" name="email" id="edit_email" class="form-control" required style="background:#252525; color:#fff; border:1px solid #444;">
                        </div>
                        <div class="form-group col-md-6">
                            <label style="color: #bbb;">Teléfono</label>
                            <input type="text" name="telefono" id="edit_telefono" class="form-control" required style="background:#252525; color:#fff; border:1px solid #444;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label style="color: #bbb;">Plan (Suscripción)</label>
                        <select name="idSuscripcion" id="edit_suscripcion" class="form-control" required style="background:#252525; color:#fff; border:1px solid #444;">
                            <% if(listaSuscripciones != null) { 
                                for(Modelo.Suscripcion s : listaSuscripciones) { %>
                                    <option value="<%= s.getId() %>">
                                        <%= s.getTipo().toUpperCase() %> - $<%= s.getPrecio() %>
                                    </option>
                            <%  } 
                               } %>
                        </select>
                    </div>

                <hr style="border-top: 1px solid #444;">
<p style="color:#fb030a; font-size:0.9rem; margin-bottom:10px;">
    <i class="fa fa-lock"></i> Seguridad (Opcional)
</p>
<div class="form-row">
    <div class="form-group col-md-6">
        <label style="color: #bbb; font-size: 0.8rem;">Nueva Contraseña</label>
        <input type="password" name="newPassword" id="newPass" class="form-control" placeholder="Dejar vacío si no cambia" style="background:#252525; color:#fff; border:1px solid #444;">
    </div>
    <div class="form-group col-md-6">
        <label style="color: #bbb; font-size: 0.8rem;">Confirmar Contraseña</label>
        <input type="password" name="confirmPassword" id="confirmPass" class="form-control" placeholder="Repetir contraseña" style="background:#252525; color:#fff; border:1px solid #444;">
    </div>
</div>
                </div>
                
                <div class="modal-footer" style="border-top: 1px solid #333;">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn" style="background-color: #fb030a; color: white;">Guardar Cambios</button>
                </div>
            </form>
        </div>
    </div>
</div>
    
    
</body>
</html>