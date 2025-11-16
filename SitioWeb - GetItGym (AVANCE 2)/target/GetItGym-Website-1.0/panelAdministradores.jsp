<%-- 
    Document   : panelAdministradores
    Created on : 15 nov 2025, 5:14:15 p.m.
    Author     : jorge
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession ses = request.getSession(false);
    if (ses == null || ses.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
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

        <!-- Header -->
        <header class="header-area header-sticky">
            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <nav class="main-nav">
                            <a href="index.html" class="logo">GET IT<em> GYM</em></a>
                            <ul class="nav">
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
                <!-- Sidebar -->
                <div class="col-lg-3" id="sidebar">
                    <h5>Menú Admin</h5>
                    <a href="#usuarios">Usuarios Registrados</a>
                    <a href="#clases">Clases Disponibles</a>
                    <a href="#instructores">Instructores</a>
                    <a href="#estadisticas">Estadísticas</a>
                    <a href="#">Cerrar sesión</a>
                </div>

                <!-- Contenido principal -->
                <div class="col-lg-9">

                    <!-- Usuarios -->
                    <section id="usuarios" class="dashboard-card">
                        <h2><i class="fa fa-users"></i> Usuarios Registrados</h2>
                        <button class="btn btn-success btn-sm mb-2" onclick="agregarUsuario()">Agregar Usuario</button>
                        <table class="table table-bordered" id="tabla-usuarios">
                            <thead>
                                <tr>
                                    <th>Nombre</th>
                                    <th>Email</th>
                                    <th>Teléfono</th>
                                    <th>Tipo de Pase</th>
                                    <th>Clase Inscrita</th>
                                    <th>Registro</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Juan Pérez</td>
                                    <td>juan@email.com</td>
                                    <td>555-1234</td>
                                    <td>Mensual</td>
                                    <td>Yoga</td>
                                    <td>2025-01-15</td>
                                    <td>
                                        <button class="btn btn-primary btn-sm btn-crud" onclick="editarFila(this)">Editar</button>
                                        <button class="btn btn-danger btn-sm btn-crud" onclick="eliminarFila(this)">Eliminar</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </section>

                    <!-- Clases -->
                    <section id="clases" class="dashboard-card">
                        <h2><i class="fa fa-dumbbell"></i> Clases Disponibles</h2>
                        <button class="btn btn-success btn-sm mb-2" onclick="agregarClase()">Agregar Clase</button>
                        <div class="row" id="clases-container">
                            <div class="col-md-6 class-card">
                                <h5>Yoga</h5>
                                <p>Cupo: 20 personas</p>
                                <p>Ocupación: 12 personas</p>
                                <div class="progress">
                                    <div class="progress-bar progress-bar-yoga" style="width:60%;">60%</div>
                                </div>
                            </div>
                            <div class="col-md-6 class-card">
                                <h5>Body Building</h5>
                                <p>Cupo: 15 personas</p>
                                <p>Ocupación: 8 personas</p>
                                <div class="progress">
                                    <div class="progress-bar progress-bar-body" style="width:53%;">53%</div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- Instructores -->
                    <section id="instructores" class="dashboard-card">
                        <h2><i class="fa fa-chalkboard-teacher"></i> Instructores</h2>
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Nombre</th>
                                    <th>Email</th>
                                    <th>Teléfono</th>
                                    <th>Clases que imparte</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Bret D. Bowers</td>
                                    <td>bret@email.com</td>
                                    <td>555-1111</td>
                                    <td>Body Building, Avanzado</td>
                                    <td>
                                        <button class="btn btn-primary btn-sm btn-crud" onclick="editarFila(this)">Editar</button>
                                        <button class="btn btn-danger btn-sm btn-crud" onclick="eliminarFila(this)">Eliminar</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Hector T. Daigle</td>
                                    <td>hector@email.com</td>
                                    <td>555-2222</td>
                                    <td>Yoga, Intermedio</td>
                                    <td>
                                        <button class="btn btn-primary btn-sm btn-crud" onclick="editarFila(this)">Editar</button>
                                        <button class="btn btn-danger btn-sm btn-crud" onclick="eliminarFila(this)">Eliminar</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </section>

                    <!-- Estadísticas -->
                    <section id="estadisticas" class="dashboard-card">
                        <h2><i class="fa fa-chart-line"></i> Estadísticas Generales</h2>
                        <div class="row text-center">
                            <div class="col-md-3">
                                <h3>45</h3>
                                <p>Usuarios Activos</p>
                            </div>
                            <div class="col-md-3">
                                <h3>78</h3>
                                <p>Clases Totales</p>
                            </div>
                            <div class="col-md-3">
                                <h3>65%</h3>
                                <p>Ocupación Promedio</p>
                            </div>
                            <div class="col-md-3">
                                <h3>10</h3>
                                <p>Usuarios con pase diario</p>
                            </div>
                        </div>
                    </section>

                </div>
            </div>
        </div>

        <script src="assets/js/jquery-2.1.0.min.js"></script>
        <script src="assets/js/popper.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>

        <script>
                            $(document).ready(function () {
                                $('.progress-bar').each(function () {
                                    var width = $(this).attr('style').match(/width:(\d+)%/)[1];
                                    $(this).css('width', '0').animate({width: width + '%'}, 1200);
                                });
                            });

                            function agregarUsuario() {
                                const tabla = document.getElementById('tabla-usuarios').getElementsByTagName('tbody')[0];
                                const fila = tabla.insertRow();
                                fila.innerHTML = `
              <td>Nuevo Usuario</td>
              <td>nuevo@email.com</td>
              <td>555-0000</td>
              <td>Mensual</td>
              <td>Yoga</td>
              <td>2025-10-22</td>
              <td>
                <button class="btn btn-primary btn-sm btn-crud" onclick="editarFila(this)">Editar</button>
                <button class="btn btn-danger btn-sm btn-crud" onclick="eliminarFila(this)">Eliminar</button>
              </td>`;
                            }

                            function editarFila(btn) {
                                const fila = btn.closest('tr');
                                for (let i = 0; i < fila.cells.length - 1; i++) {
                                    let valor = fila.cells[i].innerText;
                                    let input = prompt("Editar valor:", valor);
                                    if (input !== null)
                                        fila.cells[i].innerText = input;
                                }
                            }

                            function eliminarFila(btn) {
                                if (confirm("¿Eliminar este registro?")) {
                                    const fila = btn.closest('tr');
                                    fila.remove();
                                }
                            }

                            function agregarClase() {
                                const container = document.getElementById('clases-container');
                                const div = document.createElement('div');
                                div.className = "col-md-6 class-card";
                                div.innerHTML = `
              <h5>Nueva Clase</h5>
              <p>Cupo: 20 personas</p>
              <p>Ocupación: 0 personas</p>
              <div class="progress">
                <div class="progress-bar progress-bar-yoga" style="width:0%;">0%</div>
              </div>`;
                                container.appendChild(div);
                                $(div).find('.progress-bar').animate({width: '0%'}, 0).animate({width: '0%'}, 1200);
                            }
        </script>

        <script src="${pageContext.request.contextPath}/assets/js/jquery-2.1.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/popper.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

    </body>
</html>
