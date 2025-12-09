<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Cliente"%>
<%
    // Seguridad: Si no hay cliente, fuera
    HttpSession ses = request.getSession(false);
    Cliente c = (ses != null) ? (Cliente) ses.getAttribute("clienteLogueado") : null;
    if (c == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mi Perfil - Get It Gym</title>
    
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/font-awesome.css">
    <link rel="stylesheet" href="assets/css/panelAdmin.css"> 
</head>
<body>

    <div class="overlay" onclick="toggleMenu()"></div>

    <div class="sidebar" id="sidebar">
        <div class="logo-box">
            <h3>GET IT <span>GYM</span></h3>
            <p style="margin:0; font-size: 0.8rem; color: #777;">Portal de Socios</p>
        </div>
        
        <div class="sidebar-menu">
            <a href="#" class="active">
                <i class="fa fa-user"></i> Mi Perfil
            </a>
            <a href="index.html#schedule">
                <i class="fa fa-calendar"></i> Ver Horarios
            </a>
            <a href="index.html#contact-us">
                <i class="fa fa-envelope"></i> Contacto
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

        <div class="content-section active">
            <h2>Bienvenido, <span style="color: #fb030a;"><%= c.getNombre() %></span></h2>
            <p style="color: #aaa; margin-bottom: 30px;">Aquí tienes el estado actual de tu membresía.</p>

            <div class="row mb-4">
                <div class="col-md-4 mb-3">
                    <div class="stat-card">
                        <i class="fa fa-info-circle fa-3x" style="color: #fb030a; margin-bottom: 15px;"></i>
                        <div class="stat-label">Plan Actual</div>
                        <div class="stat-number" style="font-size: 1.5rem;">
                            <%= c.getPlazo() != null ? c.getPlazo().toUpperCase() : "SIN PLAN" %>
                        </div>
                    </div>
                </div>

                <div class="col-md-4 mb-3">
                    <div class="stat-card">
                        <i class="fa fa-trophy fa-3x" style="color: #fb030a; margin-bottom: 15px;"></i>
                        <div class="stat-label">Clase Inscrita</div>
                        <div class="stat-number" style="font-size: 1.5rem;">
                            <%= c.getClase() != null ? c.getClase() : "Ninguna" %>
                        </div>
                    </div>
                </div>

                <div class="col-md-4 mb-3">
                    <div class="stat-card">
                        <i class="fa fa-calendar fa-3x" style="color: #fb030a; margin-bottom: 15px;"></i>
                        <div class="stat-label">Vencimiento</div>
                        <div class="stat-number" style="font-size: 1.5rem; color: #fff;">
                            <%= c.getFechaFin() != null ? c.getFechaFin() : "N/A" %>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card-dark">
                <div class="card-header-flex">
                    <h2 style="margin:0; border:none;"><i class="fa fa-user"></i> Mis Datos</h2>
                </div>
                
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label style="color: #fb030a; font-size: 0.85rem; text-transform: uppercase;">Correo Electrónico</label>
                        <div style="font-size: 1.1rem; border-bottom: 1px solid #333; padding-bottom: 5px;">
                            <%= c.getEmail() %>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label style="color: #fb030a; font-size: 0.85rem; text-transform: uppercase;">Teléfono</label>
                        <div style="font-size: 1.1rem; border-bottom: 1px solid #333; padding-bottom: 5px;">
                            <%= c.getTelefono() %>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label style="color: #fb030a; font-size: 0.85rem; text-transform: uppercase;">Edad</label>
                        <div style="font-size: 1.1rem; border-bottom: 1px solid #333; padding-bottom: 5px;">
                            <%= c.getEdad() %> años
                        </div>
                    </div>
                    <div class="col-md-12 mb-3">
                        <label style="color: #fb030a; font-size: 0.85rem; text-transform: uppercase;">Objetivo Principal</label>
                        <div style="font-size: 1.1rem; border-bottom: 1px solid #333; padding-bottom: 5px; font-style: italic;">
                            "<%= c.getObjetivos() %>"
                        </div>
                    </div>
                </div>
            </div>
            
        </div>
    </div>

    <script src="assets/js/jquery-2.1.0.min.js"></script>
    <script src="assets/js/popper.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>

    <script>
        // Función para menú móvil (reutilizada del admin)
        function toggleMenu() {
            document.getElementById('sidebar').classList.toggle('active');
            document.querySelector('.overlay').classList.toggle('active');
        }
    </script>
</body>
</html>