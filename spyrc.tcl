#!/usr/bin/tclsh
#   
#   - SpyRC - 
#
#   - Informa lo siguiente:
#       0 - fecha y hora del servidor.
#       1 - si existen temas nuevos a la fecha.
#       2 - si existen temas posteriores a un día de diferencia.
#       3 - número de usuarios conectados, registrados, ocultos e invitados.
#
#   - Tcl 8.6
#
#   - Autor: daltomi
#
#   - Nota: sólo para elrincondelc.com
#

package require http

proc procesar { htm } {
    
    set exp_tiempo {([0-9]{2})/([0-9]{2})/([0-9]{4}) ([0-9]{1,2}):([0-9]{1,2}) ([a|p]m)}
    set exp_tema {forumlink\">(C/C+\+.*|¿\w{2,}.*|\w{2,}.*)</a>}
    set exp_usuario {(sid=.*|&amp;u=.*)\">(\w{1,}|\w{1,}.\w{1,})</a>}
    set exp_conectados {En total hay <b>([0-9]*)</b>.*:: ([0-9]*).*, ([0-9]*).*y ([0-9]*).*}
    set b_serv 0
    set lista_nuevos { }
    set lista_anteriores { }

    foreach linea $htm {

        if { [regexp $exp_tema $linea /1 tema /2] == 0 } {
            
            regexp $exp_conectados $linea /1 conectados registrados ocultos invitados
        }

        if { [regexp $exp_tiempo $linea tiempo] > 0 } {

           if { $b_serv == 0 } {

               set b_serv 1
               lassign $tiempo fecha hora am_pm
               set lista_serv [ list $fecha $hora $am_pm ]
               continue
           }

           lassign $tiempo fecha hora am_pm
               
           regexp $exp_usuario $linea /1 /2 usuario  

           if { [string compare $fecha [lindex $lista_serv 0] ] == 0 } {
  
               lappend lista_nuevos [concat \"$tema\"\t$fecha $hora $am_pm\t <-- $usuario]

           } elseif {  [ es_anterior $fecha [lindex $lista_serv 0] ] == 1 } {
               
               lappend lista_anteriores [concat \"$tema\"\t$fecha $hora $am_pm\t <-- $usuario]
           }
        }
    }
    
    puts "* Fecha y hora actual del servidor: [lrange $lista_serv 0 3]\n"
    puts "* Conectados: $conectados, Registrados: $registrados, Ocultos: $ocultos, Invitados: $invitados\n"


    if { [llength $lista_nuevos] == 0 } {
        puts "* !! No existen temas nuevos.\n"
    } else {

        puts "* Temas del dia de hoy >>>\n"
        imprimir_lista lista_nuevos 
        puts "\n* Fin de Temas de hoy <<<\n"
    }

    if { [llength $lista_anteriores] != 0 } {
        puts "* Temas del dia de ayer >>>\n"
        imprimir_lista lista_anteriores
        puts "\n* Fin de Temas de ayer <<<\n"
    }
}


proc imprimir_lista { a } {

    upvar $a lista

    foreach item $lista {

        puts "\t$item"
    }
}


proc es_anterior { fecha fecha_serv } { 

    scan [string range $fecha_serv 6 9] %d anio_serv
    scan [string range $fecha 6 9] %d anio

    if { $anio_serv < $anio } {
        return 0
    } 

    scan [string range $fecha_serv 3 4] %d mes_serv
    scan [string range $fecha 3 4] %d mes
    scan [string range $fecha_serv 0 1] %d dia_serv
    scan [string range $fecha 0 1] %d dia

    if { $anio_serv == $anio } {

        if { $mes_serv == $mes } {

            if { $dia_serv == [expr $dia + 1] } {
                return 1
            }
        } elseif { $mes_serv == [expr $mes + 1] } {
        
            if { $dia_serv == 1 } {
                if { [expr $dia == 30] || [expr $dia == 31]  } {
                    return 1
                }
            }
        }
    } else {

        if { [expr $mes_serv == 1] && [expr $mes == 12] } {
            
            if {  [expr $dia_serv == 1] && [expr $dia == 31] } {
                return 1
            }

        }
    }

    return 0
}

  
proc actualizar { } {
        
    puts "\n* Conectando ...\n"

    set URL "http://www.elrincondelc.com/nuevorincon/foros/"

    if { [catch { set htm [http::geturl $URL -timeout 50000 ] } error] } {

        puts "\n*!! Error: URL no valida: $URL\n"
        exit

    } else {
        
        if { [ http::status $htm ] == "ok" } {
            
                procesar [split [http::data $htm] "\n"]

           } elseif { [ http::status $htm ] == "timeout" } {

                puts "\n*!! Error: ping timeout"
           }
            
       http::cleanup $htm
   }
}

actualizar


