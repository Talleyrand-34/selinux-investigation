#import "@preview/mcm-scaffold:0.1.0": *
#import "@preview/mitex:0.2.2": *
#import "@preview/sourcerer:0.2.1": code
#import "@preview/glossarium:0.5.1": make-glossary, register-glossary, print-glossary, gls, glspl
#show: make-glossary
// TODO Anadir descripciones
#let entry-list = (
  (key: "SEL", short: "SElinux", long: "Security Enhanced Linux"), (
    key: "CIL", short: "CIL", long: "Common Intermediate Language", //description: "",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
  ), (
    key: "DAC", short: "DAC", long: "Discretionary Access Control", //description: "A university in Belgium.",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
  ), (
    key: "MAC", short: "MAC", long: "Mandatory Access Control", //description: "A university in Belgium.",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
  ), (
    key: "LSM", short: "LSM", long: "Linux Security Modules", description: "Es un marco que proporciona ganchos dentro del kernel de Linux en varios lugares, incluyendo los puntos de entrada de llamadas al sistema. Cuando estos \"hooks\" se activan, las implementaciones de seguridad registradas, como SELinux, ejecutan sus funciones automáticamente.",
  ), (
    key: "Label", short: "Label", long: "Label o etiqueta", plural: "Etiquetas", //description: "A university in Belgium.",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
  ), (
    key: "MLS", short: "MLS", long: "Multi-Level Security", description: "Tambien conocido pero desactualizado MCS o Multilevel Category Security",
  ), (
    key: "event", short: "evento", description: "Accion en el sistema que accede o modifica un recurso o archivo (en linux todo es un archivo)",
  ), (
    key: "domain", short: "dominio", long: "Dominio o tipo", //description: "",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
  ), (
    key: "UBAC", short: "UBAC", long: "user-based access control", //description: "",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
  ),
  // Add more terms
)
#register-glossary(entry-list)

#show: mcm.with(
  title: "SELinux Introduction", problem-chosen: "SSI", team-control-number: "3.1", year: "2024", summary: [
    Investigacion de SELinux
    #lorem(100)

  ], keywords: [Cibersecurity; Linux; Selinux], magic-leading: 0.65em,
)

///////////////////////Body////////////////

= Introduccion
En los sistemas Unix tradicionales, el control de accesos se realiza de forma
discrecional @DAC@G-DAC, lo que permite a usuarios y administradores gestionar
los permisos sobre archivos y procesos basándose en los identificadores de
usuario (UID), de grupo (GID) y otros atributos. Este enfoque flexible puede
generar problemas de seguridad, ya que permite a los usuarios manejar los
permisos sobre los archivos y recursos que poseen. Por ejemplo, un usuario
podría otorgar permisos demasiado amplios a otros usuarios o grupos, lo cual
podría permitir el acceso a personas no autorizadas. Adicionalmente podria darse
el caso de que se creasen archivos que deberian tener permisos incompatibles
debido a quien debe acceder a esos archivos. Para abordar todo esto existe el
conceto de @MLS@G-MLS

@SEL@Selinux-wikipedia se desarrolló para resolver esta problemática mediante la
implementación de @MAC@G-MAC, donde las políticas de seguridad son definidas
exclusivamente por los administradores del sistema y no pueden ser modificadas
ni ignoradas por los usuarios regulares. Además, @SEL sigue una política de
“denegación por defecto”, lo que significa que, en ausencia de una regla
explícita para una acción, esta será denegada por defecto. Esto contrasta con el
modelo @DAC, donde un acceso puede ser permitido si no se especifica lo
contrario. Cabe recalcar que @SEL no sobreescribe los permisos del @DAC si no
que los extiende.

//= Historia

== Que es Selinux
SELinux es código que se ejecuta en el espacio de usuario, aprovechando el
código de kernel @LSM@G-LSM para proporcionar @MAC a través de los recursos del
sistema. Los procesos se limitan a dominios, que se pueden considerar como
recintos de pruebas. El acceso a objetos del sistema y prestaciones como
archivos, colas de mensajes, semáforos, redes, se controla por dominio siguiendo
el principio de menor privilegio.

Los directorios y archivos en SELinux se etiquetan con un tipo de dato
persistente conocido como @Label que es independiente de los UNIX @DAC
habituales. Esta capa adicional permite un control más estricto sobre el acceso
a los objetos: si un intruso obtiene el control de un proceso propiedad de un
usuario, el acceso a todos los archivos propiedad de ese usuario no se otorga
automáticamente. El tipo de acceso (lectura, escritura, creación) también puede
ser controlado por @SEL. Para una descripcion mas grafica y simple se puede
referencias a @Selinux-for-kids.

// TODO Hablar del modelo del minimo privilegio

//== Beneficios de Selinux

== Caracteristicas de Selinux
- El acceso solo está permitido si existe una regla de política SELinux que lo
  permita específicamente.
- La política de SELinux está definida administrativamente y se aplica en todo el
  sistema por SELinux.
- Las decisiones de acceso de SELinux se basan en toda la información disponible,
  como un usuario de SELinux, rol, tipo y, opcionalmente, un nivelodo el sistema.//TOCHECK
- Mejora de la mitigación para ataques de escalada de privilegios. Los procesos se
  ejecutan en dominios y, por lo tanto, están separados entre sí. Las reglas de
  política de SELinux definen cómo los procesos acceden a los archivos y otros
  procesos.
- SELinux se puede utilizar para hacer cumplir la confidencialidad e integridad de
  los datos, así como para proteger los procesos de entradas no confiables
- SELinux se ejecuta a nivel de kernel
- SELinux como tal se integra a nivel de kernel a través del framework LSM (Linux
  Security Modules)
- La aplicacion de politicas de Selinux es veloz porque todo, ya este definido por
  archivos de texto o comandos, transpila a @CIL@CIL-main-ref

= Bases de SELinux
@SEL tiene tres modos de operacion [Disabled,Permissive,Enforcing]
- Disabled
  - @SEL no interactua con el sistema
- Permissive
  - @SEL no bloque nada, en cambio solo notifica cuando un @event transgrede una
    regla
- Enforcing
  - @SEL bloquea todas las acciones que no tengan politicas asociadas

La existencia de estos tres modos se explica en el sentido de que cada uno
existe para uno de tres escenarios.
- Disabled: Cuando se quiere desactivar @SEL por completo.
- Permissive: Cuando se quiere permitir el funcionamiento del sistema sin
  bloquearlo para:
  - Aprender el funcionamiento del sistema y refinar politicas
  - Razones adicionales
- Enforcing: Cuando las politicas estan listas para ser desplegadas
== Herramientas de terminal auxiliares
En una instalacion basica no vienen todos los paquetes necesarios para
adminismtrar el sistema de forma comoda, por eso se recomienda

#code(
  lang: "bash", ```bash
                                                                                                                                                dnf install setools-console setools sepolicy_analysis policycoreutils python3-policycoreutils
                                                                                                                                                ```,
)
=== Selinux Contexts
El contexto en @SEL es una etiqueta que se asocia a cada archivo, proceso y
recurso del sistema para definir sus permisos y roles de seguridad. Un contexto
típico en SELinux se compone de tres elementos principales:
- User (usuario): Define el usuario de seguridad de SELinux.
- Role (rol): Define el rol de seguridad de SELinux.
- Type (@domain): Define el tipo de seguridad de SELinux, que es el más importante
  para la política de acceso.
- Sensivity level (Nivel de sensibilidad):

Cada atributo puede identificar porque su etiqueta termina en:
- \_u: usuario
- \_r: rol
- \_t: @domain

De todos estos el mas importante es el tercero, el @domain, porque la mayoria de
las politicas trabajan sobre este valor.

Todos los comandos basicos de visualizacion de atributos se pueden ver en
@visualizacion-commandos

Se puede acceder a los valoers de Selinux asociados a un proceso en
/proc/\$PID/attr. Esta carpeta define los atributos asociados a un proceso.

#image("figures/sshd.png")

El significado de los archivos es el siguiente:
- El archivo current muestra el contexto SELinux actual del proceso.
- El archivo exec muestra el contexto SELinux que será asignado por la próxima
  ejecución de la aplicación realizada a través de esta aplicación. Normalmente
  está vacío.
- El archivo fscreate muestra el contexto SELinux que será asignado al siguiente
  archivo escrito por la aplicación.
- El archivo keycreate muestra el contexto SELinux que será asignado a las claves
  almacenadas en caché en el kernel por esta aplicación. Normalmente está vacío.
- El archivo prev muestra el contexto SELinux previo para este proceso en
  particular. Este normalmente es el contexto de su aplicación padre.
- El fichero sockcreate muestra el contexto SELinux que será asignado al siguiente
  socket creado por la aplicación. Normalmente está vacío.

== Selinux Labels
En SELinux, todos los objetos y procesos están etiquetados con un @Label, este
representa el contexto y define detalladamente cómo pueden interactuar entre sí.
Finalmente, @SEL también aísla los procesos en dominios, lo que impide que un
proceso comprometido, como un servidor web, acceda a recursos fuera de su
dominio designado. Por lo tanto, @SEL es capaz de mitigar la escalada de
privilegios y reducir los riesgos en el sistema, al restringir las acciones que
un atacante podría llevar a cabo, limitando su acceso a recursos y otras
operaciones que podrían ser posibles en un sistema Unix estándar con @DAC en
lugar del @MAC de @SEL.// Reescribir parcialmente, buena idea pero muchas vueltas

Aqui estan listadas las #glspl("Label") mas comunes:
#table(
  columns: (auto, auto, 2fr), inset: 10pt, align: horizon, table.header([*Tipo de etiqueta*], [*Ruta*], [*Descripción*]), [unconfined_t], [/example], [Carpeta sin restricciones de SELinux], [user_home_t], [/home/user], [Carpeta home de usuario], [default_t], [common], [Carpeta por defecto], [bin_t], [bin], [Carpeta de binarios], [boot_t], [boot], [Carpeta de boot], [device_t], [dev], [Carpeta de dispositivos], [etc_t], [etc], [Carpeta de configuración], [home_root_t], [home], [Carpeta raíz de home], [lib_t], [lib], [Carpeta de librerías], [lost_found_t], [lost+found], [Carpeta de archivos eliminados], [mnt_t], [mnt], [Carpeta montada], [proc_t], [proc], [Carpeta de procesos], [admin_home_t], [root], [Carpeta de home del usuario root], [var_run_t], [run], [Carpeta de archivos de ejecución], [sysfs_t], [sys], [Carpeta de información kernel y dispositivos], [tmp_t], [tmp], [Carpeta de archivos temporales], [usr_t], [usr], [Carpeta de archivos de binarios y similares de solo lectura], [var_t], [var], [Carpeta de archivos de datos variables],
)

- Diferencia entre contexto y @Label
  - Contexto es el conjunto de politicas asociadas a un nombre (@Label)
  - @Label es el identificador por el cual el archivo va a ser juzgado a la hora de
    aplicar politicas

=== Selinux Roles
La principal forma de control en @SEL son las #glspl("Label"), pero existe otra
que es a traves de roles. Por convención, los roles SELinux se definen con un
sufijo \_r. El acceso por roles es las base del @UBAC

En la mayoría de los sistemas SELinux, el administrador puede asignar los
siguientes roles SELinux a los usuarios estos son los roles mas destacados:
- El rol user\_r es para usuarios restringidos. A este rol sólo se le permite
  tener procesos con tipos específicos para aplicaciones de usuario final. Los
  tipos privilegiados, incluyendo aquellos utilizados para cambiar a otro usuario
  Linux, no están permitidos para este rol.
- El rol staff\_r está pensado para operaciones no críticas. Este rol está
  generalmente restringido a las mismas aplicaciones que el usuario restringido,
  pero tiene la capacidad de cambiar de rol. Es el rol por defecto de los
  operadores (para mantener a los usuarios en su rol menos privilegiado el mayor
  tiempo posible). su rol menos privilegiado el mayor tiempo posible).
- El rol sysadm\_r está destinado a los administradores del sistema. Este rol es
  muy privilegiado, permitiendo varias tareas de administración del sistema. Sin
  embargo, ciertas aplicaciones de usuario final usuario final (especialmente si
  esos tipos se utilizan para software potencialmente vulnerable o no fiable) para
  mantener el sistema libre de infecciones.
- El rol secadm\_r está pensado para administradores de seguridad. Este rol
  permite cambiar la política SELinux y manipular los controles SELinux.
  Generalmente se utiliza cuando se necesita una separación de funciones entre los
  administradores del sistema y la gestión de las políticas del sistema. del
  sistema.
- El rol system\_r está pensado para demonios y procesos en segundo plano. Este
  rol es bastante privilegiado, ya que admite varios tipos de procesos de demonio
  y de sistema. Sin embargo, los tipos de aplicaciones de usuario final y otros
  tipos administrativos no están permitidos en este rol.
- El rol unconfined\_r está pensado para usuarios finales. Este rol permite un
  número limitado de tipos, pero esos tipos son muy privilegiados ya que permiten
  ejecutar cualquier aplicación lanzada por un usuario (u otro proceso no
  confinado) de una manera más o menos no confinada (no restringida por SELinux).
  (no restringida por las reglas de SELinux). Este rol, como tal, sólo está
  disponible si el administrador del sistema quiere proteger ciertos procesos (la
  mayoría demonios) mientras mientras mantiene el resto de las operaciones del
  sistema casi intactas por SELinux.
#table(
  columns: (auto, auto, auto, auto), inset: 10pt, align: horizon, table.header(repeat: true, [*SELinux Roles*]), [auditadm_r], [container_user_r], [dbadm_r], [guest_r], [logadm_r], [nx_server_r], [object_r], [secadm_r], [staff_r], [sysadm_r], [system_r], [unconfined_r], [user_r], [webadm_r], [xguest_r], [],
)
=== Selinux sensivity

== Selinux Policies
Las politicas se guardan en XML en el directorio
/var/lib/setroubleshoot/setroubleshoot.xml

= Casos especiales
== Contenedores

= Escenarios
== Escenario 1
== Escenario 2

= Referencias
== Referencia archivos
== Referencia archivos de configuracion
- /etc/selinux/config
  - Controla la configuracion de SELinux en el sistema.
    - grep ^SELINUX= /etc/selinux/config => Permissive||Enforcing
- /sys/fs/selinux/enforce
  - Archivo que indica el estado de selinux
  - cat /sys/fs/selinux/enforce => 0/1
- /sys/fs/selinux
  - Directorio con toda la configuracion de selinux
- /etc/default/grub
  - In grub (/etc/default/grub) GRUB_CMDLINE_LINUX="selinux=0" to disable
== Referencia archivos de errores
- /var/log/audit/\*

== Referencias comandos
//=== Indispensable antes de empezar
=== Desactivar acciones silenciosas
#code(lang: "bash", ```bash
# -D desactiva mecanismos "don't audit"
semodule -DB
# Para volver a activar sirve con recontruir las politicas
semodule -B
```)
=== Retiquetar el sistema de archivos
==== Grano Grueso
#code(
  lang: "bash", ```bash
                                                                                                                                                                                                                    # al reiniciar el sistema reetiqueta el sistema de archivos si selinux detecta este archivo
                                                                                                                                                                                                                    touch /.autorelabel
                                                                                                                                                                                                                    ```,
)

#code(
  lang: "bash", ```bash
                                                                                                                                                                                                                    # Verifica los contextos de seguridad de los archivos sin realizar cambios.
                                                                                                                                                                                                                    fixfiles check

                                                                                                                                                                                                                    # Restaura el contexto de seguridad de los archivos a sus valores predeterminados.
                                                                                                                                                                                                                    fixfiles restore

                                                                                                                                                                                                                    # Pregunta por la eliminacion de /tmp y reetiqueta todos los archivos del sistema de archivos.
                                                                                                                                                                                                                    fixfiles relabel

                                                                                                                                                                                                                    # Verifica que todos los archivos tengan el contexto de seguridad correcto.
                                                                                                                                                                                                                    fixfiles verify

                                                                                                                                                                                                                    # Reetiqueta todo el sistema
                                                                                                                                                                                                                    fixfiles -F onboot

                                                                                                                                                                                                                    # Estos comandos pueden tener como ultimo parametro la carpeta padre o archivo a reetiquetar
                                                                                                                                                                                                                    fixfiles check [folder|file]
                                                                                                                                                                                                                    ```,
)
==== Grano Fino

#code(lang: "bash", ```bash
# Cambia el contexto de seguridad de un archivo o directorio.
chcon
```)
#code(
  lang: "bash", ```bash
                                                                                                                                                                                                                    # Verifica el contexto de seguridad de un archivo utilizando las reglas de política de SELinux.
                                                                                                                                                                                                                    matchpathcon
                                                                                                                                                                                                                    ```,
)
#code(
  lang: "bash", ```bash
                                                                                                                                                                                                                    # Restaura el contexto de seguridad predeterminado de un archivo o directorio.
                                                                                                                                                                                                                    restorecon
                                                                                                                                                                                                                    ```,
)
=== Monitorizacion Basica SELinux
#code(
  lang: "bash", ```bash
                                                                                                                                                                                                                    # Obtiene el estado actual de cumplimiento de politicas de selinux en el sistema
                                                                                                                                                                                                                    getenforce
                                                                                                                                                                                                                    # Ouput: Enforcing|Permissive
                                                                                                                                                                                                                    ```,
)
#code(lang: "bash", ```bash
# Obtiene el estado basico de Selinux en el sistema
sestatus
# Output:
# SELinux status:                 enabled
# SELinuxfs mount:                /sys/fs/selinux
# SELinux root directory:         /etc/selinux
# Loaded policy name:             targeted
# Current mode:                   enforcing
# Mode from config file:          enforcing
# Policy MLS status:              enabled
# Policy deny_unknown status:     allowed
# Memory protection checking:     actual (secure)
# Max kernel policy version:      33
```)
#code(
  lang: "bash", ```bash
                                                                                                                                                                                                                    # Obtiene el estado basico de los componenetes de las politicas de Selinux en el sistema
                                                                                                                                                                                                                    seinfo
                                                                                                                                                                                                                    # Ouput:
                                                                                                                                                                                                                    # Statistics for policy file: /sys/fs/selinux/policy
                                                                                                                                                                                                                    # Policy Version:             33 (MLS enabled)
                                                                                                                                                                                                                    # Target Policy:              selinux
                                                                                                                                                                                                                    # Handle unknown classes:     allow
                                                                                                                                                                                                                    #   Classes:             134    Permissions:         460
                                                                                                                                                                                                                    #   Sensitivities:         1    Categories:         1024
                                                                                                                                                                                                                    #   Types:              5266    Attributes:          264
                                                                                                                                                                                                                    #   Users:                 8    Roles:                15
                                                                                                                                                                                                                    #   Booleans:            365    Cond. Expr.:         398
                                                                                                                                                                                                                    #   Allow:             68070    Neverallow:            0
                                                                                                                                                                                                                    #   Auditallow:          181    Dontaudit:          8830
                                                                                                                                                                                                                    #   Type_trans:       284397    Type_change:          94
                                                                                                                                                                                                                    #   Type_member:          37    Range_trans:        6164
                                                                                                                                                                                                                    #   Role allow:           40    Role_trans:          419
                                                                                                                                                                                                                    #   Constraints:          70    Validatetrans:         0
                                                                                                                                                                                                                    #   MLS Constrain:        72    MLS Val. Tran:         0
                                                                                                                                                                                                                    #   Permissives:           9    Polcap:                6
                                                                                                                                                                                                                    #   Defaults:              7    Typebounds:            0
                                                                                                                                                                                                                    #   Allowxperm:            0    Neverallowxperm:       0
                                                                                                                                                                                                                    #   Auditallowxperm:       0    Dontauditxperm:        0
                                                                                                                                                                                                                    #   Ibendportcon:          0    Ibpkeycon:             0
                                                                                                                                                                                                                    #   Initial SIDs:         27    Fs_use:               35
                                                                                                                                                                                                                    #   Genfscon:            110    Portcon:             665
                                                                                                                                                                                                                    #   Netifcon:              0    Nodecon:               0
                                                                                                                                                                                                                    ```,
)
=== Obtencion de logs de SELinux
@SEL
setroubleshootd es el proceso que se encarga de gestionar los errores y
recomendaciones al usuario de selinux @Man-setroubleshootd
#code(
  lang: "bash", ```bash
                                                                                                                                                                                                                    # Obtiene los logs relacionados con intentos de accesos no autorizados de recursos
                                                                                                                                                                                                                    journalctl -e -u setroubleshootd
                                                                                                                                                                                                                    ```,
)
#code(
  lang: "bash", ```bash
                                                                                                                                                                                                                    # Obtiene los logs relacionados con intentos de accesos no autorizados de recursos sis usar comando de systemd
                                                                                                                                                                                                                    cat /var/log/audit/audit.log
                                                                                                                                                                                                                    ```,
)
#code(
  lang: "bash", ```bash
                                                                                                                                                                                                                    # Obtiene los ultimos errores lanzados por selinux
                                                                                                                                                                                                                    ausearch -m avc
                                                                                                                                                                                                                    # En concreto maneja la salida de proceso de auditoria que es la categoria en la que esta SELinux
                                                                                                                                                                                                                    ```,
)
=== Lectura de #glspl("Label") <visualizacion-commandos>
#code(lang: "bash", ```bash
# Obtiene las etiquetas del usuario
id -Z
# Ouput:
# unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
```)
#code(
  lang: "bash", ```bash
                                                                                                                                                                                                                    # Obtiene las etiquetas de los archivos
                                                                                                                                                                                                                    ls -Z
                                                                                                                                                                                                                    # Output:
                                                                                                                                                                                                                    # unconfined_u:object_r:admin_home_t:s0 disk  unconfined_u:object_r:admin_home_t:s0 podman    unconfined_u:object_r:admin_home_t:s0 test-secret.asc
                                                                                                                                                                                                                    # unconfined_u:object_r:admin_home_t:s0 mnt   unconfined_u:object_r:admin_home_t:s0 test.asc
                                                                                                                                                                                                                    ls -lZ
                                                                                                                                                                                                                    # Output:
                                                                                                                                                                                                                    # total 8
                                                                                                                                                                                                                    # drwxr-xr-x. 3 root root unconfined_u:object_r:admin_home_t:s0   89 Nov 17 21:38 disk
                                                                                                                                                                                                                    # drwxr-xr-x. 2 root root unconfined_u:object_r:admin_home_t:s0    6 Nov 24 02:25 mnt
                                                                                                                                                                                                                    # drwxr-xr-x. 3 root root unconfined_u:object_r:admin_home_t:s0   19 Nov 17 21:40 podman
                                                                                                                                                                                                                    # -rw-r--r--. 1 root root unconfined_u:object_r:admin_home_t:s0 1745 Nov 23 17:54 test.asc
                                                                                                                                                                                                                    # -rw-r--r--. 1 root root unconfined_u:object_r:admin_home_t:s0 3779 Nov 23 17:54 test-secret.asc

                                                                                                                                                                                                                    ```,
)
#code(
  lang: "bash", ```bash
                                                                                                                                                                                                                    # Lista los atributos de un proceso
                                                                                                                                                                                                                    ls /proc/$PID/attr
                                                                                                                                                                                                                    # Ouput:
                                                                                                                                                                                                                    # current  exec  fscreate  keycreate  prev  sockcreate

                                                                                                                                                                                                                    # Obtiene las etiquetas de procesos
                                                                                                                                                                                                                    ps -Z
                                                                                                                                                                                                                    # Ouput:
                                                                                                                                                                                                                    # LABEL                               PID TTY          TIME CMD
                                                                                                                                                                                                                    # unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 5937 pts/1 00:00:00 bash
                                                                                                                                                                                                                    # unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 6099 pts/1 00:00:00 ps
                                                                                                                                                                                                                    ```,
)

== Herramientas complementarias
=== Cockpit
Cockpit @Tools-cockpit es una interfaz grafica para servidores, en ella podemos
ver diferentes aspectos de un servidor, en este caso las politicas de @SEL que
aplica junto a un yaml de ansible para ejecutar esas mismas politicas que han
sido modificadas de la base en otros equipos
#image("figures/cockpit-general.png")
#image("figures/cockpit-general-light.png")
Cockpit adicionalmente nos muestra de forma sencilla los fallos de acceso y sus
formas de permitir ademas de un boton para implementarlas con un solo click
#image("figures/cockpit-solutions.png")
#image("figures/cockpit-solutions-light.png")
=== Udica

#pagebreak()
= Glosario
#print-glossary(entry-list)
#bibliography("references.yml", full: true)
