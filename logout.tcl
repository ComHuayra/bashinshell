#!/usr/bin/wish

package require Tk

# TODO: Completar aquí otros WM's
# Notas:
# * Fluxbox 
#	Activar: session.screen0.allowRemoteActions: true
array set SESSIONES { XFCE	   {xfce4-session-logout}
					  OpenBox  {openbox --exit}
					  i3	   {i3-msg exit}
					  PekWM	   {killall -9 pekwm}
					  JWM	   {jwm -exit}
					  FluxBox  {fluxbox-remote \"Exit\"} }
							

array set ACCIONES { Apagar	   {systemctl poweroff &>/dev/null} 
					 Reiniciar {systemctl reboot &>/dev/null} 
					 Hibernar  {systemctl hibernate &>/dev/null} 
					 Suspender {systemctl suspend &>/dev/null} 
					 Sesión	   {CerrarSesion} }


set SHELL "/bin/bash"

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Modificar aquí la accion y sesión por defecto.
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

set accion Apagar	;# Accion por defecto

set sesion JWM 		;# Sesión por defecto

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


proc Ejecutar { } {
	global SHELL ACCIONES accion

	switch -- $accion {
		Sesión { eval $ACCIONES($accion) }
		default { exec $SHELL "-c" $ACCIONES($accion) }
	}

	exit
}



proc CerrarSesion { } {
	global SHELL SESSIONES sesion
	
	exec $SHELL "-c" $SESSIONES($sesion)
}



proc MakeWidgets  { parent } { 
	global SESSIONES ACCIONES COLORES sesion accion
	global f

	set f [ frame $parent.choices -borderwidth 5 ]
	set b 0
	foreach item [ array names ACCIONES ] {
		
		if { [ string equal -nocase $item Sesión ] } {
			# Para que siempre este último en la lista
			continue
		} else {
			ttk::radiobutton $f.$b  -variable accion -text $item -value $item -width 40 -command { $f.combo state disabled }
		}

		pack $f.$b -side top 
		incr b
	}

	# Siempre último en la lista
	ttk::radiobutton $f.sesion  -variable accion -text Sesión -value Sesión  -width 40 -command { $f.combo state !disabled }
	
	pack $f.sesion -side top 

	ttk::combobox $f.combo -values [ array names SESSIONES ] -textvariable sesion	
	$f.combo state { disabled readonly }

	pack $f.combo
	pack $f -side top 
}



proc main { } {
	global ACCIONES
	
	wm title . "Logout"
	wm maxsize . 180 175
	wm minsize . 180 175

	ttk::style theme use alt

	# Main frame
	ttk::frame .main -borderwidth 1

	MakeWidgets .main

	# Botones 
	set fbotones [ frame .main.botones -width 40 ]
	ttk::button $fbotones.aceptar -text "Aceptar" -width 10 -command { Ejecutar }
	ttk::button $fbotones.salir -text "Cancelar" -width 10 -command { exit }

	# Pack's
	pack [ ttk::separator $fbotones.s -orient horizontal ] -fill x -pady 3 
	pack $fbotones.aceptar -side left -padx 2
	pack $fbotones.salir -side right  -padx 2
	pack .main $fbotones
}; main

# vim: set ts=4 sw=4 tw=0 noet :
