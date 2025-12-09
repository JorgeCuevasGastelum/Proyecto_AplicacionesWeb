<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Modelo.ClaseGym"%>
<%@page import="Controlador.CatalogosDAO"%>

<%
    // Carga de clases para el select
    CatalogosDAO catDao = new CatalogosDAO();
    List<ClaseGym> listaClases = catDao.obtenerClases();
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Registro - Get It Gym</title>
        
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/font-awesome.css">
        <link rel="stylesheet" href="assets/css/loginCSS.css"> 
    </head>
    
    <body>

        <header class="header-area">
            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <nav class="main-nav">
                            <a href="index.html" class="logo">GET IT<em> GYM</em></a>
                            
                            <ul class="nav">
                                <li><a href="index.html#top">Inicio</a></li>
                                <li><a href="index.html#features">Nosotros</a></li>
                                <li><a href="index.html#our-classes">Clases</a></li>
                                <li><a href="index.html#schedule">Horarios</a></li>
                                <li><a href="index.html#contact-us">Contacto</a></li>
                                <li class="nav-btn"><a href="login.jsp">Iniciar Sesión</a></li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </header>

        <div class="auth-container">
            <div class="glass-box box-register">
                
                <div class="text-center">
                    <h2>Únete al Equipo</h2>
                    <p>Crea tu cuenta y empieza tu transformación hoy.</p>
                </div>

                <div id="alertas">
                    <% if (request.getParameter("duplicado") != null) { %>
                        <div class="alert alert-warning text-center">⚠ Este correo ya está registrado.</div>
                    <% } %>
                    <% if (request.getParameter("error") != null) { %>
                        <div class="alert alert-danger text-center">⚠ Ocurrió un error en el servidor.</div>
                    <% } %>
                </div>

                <form action="registrarCliente" method="post">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Nombre Completo</label>
                                <input name="nombre" type="text" class="form-control" placeholder="Ej: Ana López" required>
                            </div>
                            <div class="form-group">
                                <label>Correo Electrónico</label>
                                <input name="email" type="email" class="form-control" placeholder="correo@ejemplo.com" required>
                            </div>
                            <div class="form-group">
                                <label>Contraseña</label>
                                <input name="password" type="password" class="form-control" placeholder="••••••••" required>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Teléfono</label>
                                <input name="telefono" type="text" class="form-control" placeholder="555-0000" required>
                            </div>
                            <div class="form-group">
                                <label>Edad</label>
                                <input name="edad" type="number" class="form-control" placeholder="Ej: 25" required>
                            </div>
                            <div class="form-group">
                                <label>Clase de Interés (Opcional)</label>
                                <select name="clase" class="form-control">
                                    <option value="sin-clase">-- Seleccionar --</option>
                                    <% for(ClaseGym c : listaClases) { %>
                                        <option value="<%= c.getNombre() %>"><%= c.getNombre() %></option>
                                    <% } %>
                                </select>
                            </div>
                        </div>

                        <div class="col-12">
                            <div class="form-group">
                                <label>Objetivo Principal</label>
                                <textarea name="objetivos" rows="2" class="form-control" placeholder="Ej: Bajar peso, tonificar..."></textarea>
                            </div>
                        </div>

                        <div class="col-12 text-center">
                            <button type="submit" class="btn-main">Registrarme</button>
                        </div>
                        
                        <div class="col-12 text-center mt-3">
                            <a href="login.jsp" style="color: #bbb; font-size: 0.9rem; text-decoration: none;">
                                ¿Ya tienes cuenta? <span style="color: #fb030a; font-weight: 600;">Inicia sesión aquí</span>
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <footer>
            <div class="container">
                <p>© 2025 Get It Gym - Tu mejor versión.</p>
            </div>
        </footer>

        <script src="assets/js/jquery-2.1.0.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
    </body>
</html>