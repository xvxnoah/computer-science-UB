package prog2.vista;

import java.util.*;
import prog2.model.ClubUB;

public class VistaClubUB {

    /* Atributos */
    private ClubUB clubUB;

    /* Constructor de la Vista */
    public VistaClubUB() {
        clubUB = new ClubUB();
    }

    /* Métodos */
    public void gestioClubUB() {
        // Creación de un objeto para leer el input desde el teclado
        Scanner sc = new Scanner(System.in);
        // Llamar a la funcion que gestiona el menu
        gestioMenu(sc);
    }

    /* ******************************************** */
 /* Gestion, Opciones y Descripcion del Menu (M) */
 /* ******************************************** */
    private static enum OpcionesMenu {
        M_Opcion_1_AltaSocio,
        M_Opcion_2_ListaSocios,
        M_Opcion_3_EliminarSocios,
        M_Opcion_4_MostrarFactura,
        M_Opcion_5_ModificarNombreSocio,
        M_Opcion_6_ModificarSeguro,
        M_Opcion_7_GuardarLista,
        M_Opcion_8_RecuperarLista,
        M_Opcion_9_Salir
    }

    private static enum OpcionesSubMenu {
        M_Opcion_1_AltaSocioFederado,
        M_Opcion_2_AltaSocioEstandard,
        M_Opcion_3_AltaSocioJunior,
        M_Opcion_4_MenuAnterior
    }

    //Descripción de las opciones del menú principal
    private static final String[] descMenu = {
        "Donar d'alta un nou soci", //Opción 1
        "Mostrar la llista de socis", //Opción 2
        "Eliminar soci", //Opción 3
        "Mostrar factura", //Opción 4
        "Modificar nom soci", //Opción 5
        "Modificar tipus assegurança soci", //Opción 6
        "Guardar llista", //Opción 7
        "Recuperar llista", //Opción 8
        "Sortir", //Opción 9
    };

    //Descripción de las opciones del menú secundario
    private static final String[] descMenu2 = {
        "Afegir soci federat", //Opción 1
        "Afegir soci estàndard", //Opción 2
        "Afegir soci junior", //Opción 3
        "Menú anterior", //Opción 4
    };

    // Funcion que gestiona el menu principal de la aplicacion
    // Tiene 3 pasos principales:
    //   1. Crear el objeto que representa (contiene) el menu
    //   2. Asignar las descripciones del menu
    //   3. Bucle donde se trata la opcion seleccionada por el usuario
    /**
     *
     * @param sc, Scanner
     */
    public void gestioMenu(Scanner sc) {
        // Creación del objeto que representa el menu. El primer argumento del contructor es el nombre del menu
        Menu<OpcionesMenu> menuClub = new Menu<>("Menu CLUBUB", OpcionesMenu.values());
        Menu<OpcionesSubMenu> subMenu = new Menu<>("ALTA SOCI CLUBUB", OpcionesSubMenu.values());

        // Assignar una descripción a cada una de las opciones
        menuClub.setDescripcions(descMenu);
        subMenu.setDescripcions(descMenu2);

        // Variable (de tipo enumerado igual a las opciones del menu) que contiene la opcion escogida
        OpcionesMenu opcionMenu;
        OpcionesSubMenu opcionSubMenu;

        // Lançar el bucle principal de la aplicación
        do {
            menuClub.mostrarMenu();
            opcionMenu = menuClub.getOpcio(sc);

            switch (opcionMenu) {
                case M_Opcion_1_AltaSocio:
                    subMenu.mostrarMenu();
                    opcionSubMenu = subMenu.getOpcio(sc);

                    switch (opcionSubMenu) {
                        case M_Opcion_1_AltaSocioFederado:
                            afegirSociFederat(sc);
                            break;
                        case M_Opcion_2_AltaSocioEstandard:
                            afegirSociEstandard(sc);
                            break;
                        case M_Opcion_3_AltaSocioJunior:
                            afegirSociJunior(sc);
                            break;
                        case M_Opcion_4_MenuAnterior:
                            break;
                    }
                    break;
                case M_Opcion_2_ListaSocios:
                    llistarSocis();
                    break;
                case M_Opcion_3_EliminarSocios:
                    eliminaSoci(sc);
                    break;
                case M_Opcion_4_MostrarFactura:
                    mostraFactura(sc);
                    break;
                case M_Opcion_5_ModificarNombreSocio:
                    modificaNom(sc);
                    break;
                case M_Opcion_6_ModificarSeguro:
                    modificaSeguro(sc);
                    break;
                case M_Opcion_7_GuardarLista:
                    guardarLlista(sc);
                    break;
                case M_Opcion_8_RecuperarLista:
                    recuperarLlista(sc);
                    break;
            }

        } while (opcionMenu != OpcionesMenu.M_Opcion_9_Salir);
    }

    /**
     * Demana les dades necessàries per un afegir nou soci federat. Abans
     * de demanar les dades comprova si la llista està plena.
     *
     * @param sc
     */
    void afegirSociFederat(Scanner sc) {
        if (!clubUB.llistaPlena()) {
            String nom, dni, nomFederacio;
            float preu;

            System.out.println("Introdueix el nom del Soci Federat: ");
            nom = sc.nextLine();

            System.out.println("Introdueix el DNI del Soci Federat: ");
            dni = sc.nextLine();

            System.out.println("Introdueix el nom de la Federació: ");
            nomFederacio = sc.nextLine();

            System.out.println("Introdueix el preu de la Federació: ");
            preu = sc.nextFloat();

            try {
                clubUB.afegirSociFederat(nom, dni, nomFederacio, preu);
            } catch (Exception e) {
                System.out.println(e);
            }
        } else {
            System.out.println("La llista està plena!");
        }
    }

    /**
     * Demana les dades necessàries per afegir un nou soci estàndard. Abans
     * de demanar les dades comprova si la llista està plena.
     *
     * @param sc
     */
    void afegirSociEstandard(Scanner sc) {
        if (!clubUB.llistaPlena()) {
            String nom, dni, tipusAsse;
            float preu;

            System.out.println("Introdueix el nom del Soci Estàndard: ");
            nom = sc.nextLine();

            System.out.println("Introdueix el DNI del Soci Estàndard: ");
            dni = sc.nextLine();

            System.out.println("Introdueix el tipus d'Assegurança (Bàsica o Completa): ");
            tipusAsse = sc.nextLine();

            System.out.println("Introdueix el preu de l'Assegurança: ");
            preu = sc.nextFloat();

            try {
                clubUB.afegirSociEstandard(nom, dni, tipusAsse, preu);
            } catch (Exception e) {
                System.out.println(e);
            }
        } else {
            System.out.println("La llista està plena!");
        }
    }

    /**
     * Demana les dades necessàries per afegir un nou soci junior. Abans
     * de demanar les dades comprova si la llista està plena.
     *
     * @param sc
     */
    void afegirSociJunior(Scanner sc) {
        if (!clubUB.llistaPlena()) {
            String nom, dni;

            System.out.println("Introdueix el nom del Soci Junior: ");
            nom = sc.nextLine();

            System.out.println("Introdueix el DNI del Soci Junior: ");
            dni = sc.nextLine();

            try {
                clubUB.afegirSociJunior(nom, dni);
            } catch (Exception e) {
                System.out.println(e);
            }
        } else {
            System.out.println("La llista està plena!");
        }
    }

    /**
     * Mostra el contingut de la llista de socis del ClubUB.
     */
    void llistarSocis() {
        String str = clubUB.getLlistaSocis();
        System.out.print(str);
    }

    /**
     * Elimina un soci de la llista indicant la seva posició a la llista. Abans
     * de demanar les dades comprova si la llista està buida.
     *
     * @param sc
     */
    void eliminaSoci(Scanner sc) {
        if (clubUB.llistaBuida()) {
            System.out.println("La llista está buida.");
        } else {
            int posicio;

            System.out.println("Introdueix la posició del soci a eliminar: ");
            posicio = sc.nextInt();

            try {
                clubUB.removeSoci(posicio);
            } catch (Exception e) {
                System.out.println(e);
            }
        }

    }

    /**
     * Mostra el total que ha de pagar un soci determinat en la factura d'un
     * mes, indicant el seu DNI i el número d'excursions que ha fet aquell
     * mateix mes. Abans de demanar les dades comprova si la llista està buida.
     *
     * @param sc
     */
    void mostraFactura(Scanner sc) {
        if (clubUB.llistaBuida()) {
            System.out.println("La llista está buida.");
        } else {
            String dni;
            int nombreExcursions;
            float importTotal;

            System.out.println("Introdueix el DNI del Soci per mostrar la seva factura: ");
            dni = sc.nextLine();

            System.out.println("Introdueix el nombre d'excursions realitzades pel soci: ");
            nombreExcursions = sc.nextInt();

            try {
                importTotal = clubUB.calcularFactura(dni, nombreExcursions);
                System.out.println("L'import total de la factura del Soci amb DNI " + dni + " és: " + importTotal + "€.");
            } catch (Exception e) {
                System.out.println(e);
            }
        }
    }

    /**
     * Permet canviar el nom d'un soci per un altre. Abans de demanar les dades
     * comprova si la llista està buida.
     *
     * @param sc
     */
    void modificaNom(Scanner sc) {
        if (clubUB.llistaBuida()) {
            System.out.println("La llista está buida.");
        } else {
            String dni, nouNom;

            System.out.println("Introdueix el DNI del Soci a canviar el nom: ");
            dni = sc.nextLine();

            System.out.println("Introdueix el nou nom del Soci: ");
            nouNom = sc.nextLine();

            try {
                clubUB.modificaNom(dni, nouNom);
            } catch (Exception e) {
                System.out.println(e);
            }
        }
    }

    /**
     * Permet canviar el tipus d'assegurança d'un soci indicant el seu DNI i el
     * nou tipus d'assegurança ("Bàsica" o "Completa"). Abans de demanar les
     * dades comprova si la llista està buida.
     *
     * @param sc
     */
    void modificaSeguro(Scanner sc) {
        if (clubUB.llistaBuida()) {
            System.out.println("La llista está buida.");
        } else {
            String dni, nouTipus;

            System.out.println("Introduiex el DNI del soci per canviar el tipus d'Assegurança: ");
            dni = sc.nextLine();

            System.out.println("Introdueix el nou tipus d'Assegurança (Bàsica o Completa): ");
            nouTipus = sc.nextLine();

            while (!nouTipus.equals("Bàsica") && !nouTipus.equals("Completa")) {
                System.out.println("El tipus d'Assegurança ha de ser 'Bàsica' o 'Completa': ");
                nouTipus = sc.nextLine();
            }

            try {
                clubUB.modificaAsseguranca(dni, nouTipus);
            } catch (Exception e) {
                System.out.println(e);
            }
        }
    }

    /**
     * Guarda el contingut de la llista en un fitxer.
     *
     * @param sc
     */
    void guardarLlista(Scanner sc) {
        String ruta;

        System.out.println("Introdueix la ruta on guardar el fitxer: ");
        ruta = sc.nextLine();

        try {
            clubUB.save(ruta);
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    /**
     * Carrega una llista prèviament guardada d'un fitxer.
     *
     * @param sc
     */
    void recuperarLlista(Scanner sc) {
        String ruta;

        System.out.println("Introdueix la ruta al fitxer: ");
        ruta = sc.nextLine();

        try {
            clubUB = ClubUB.load(ruta);
        } catch (Exception e) {
            System.out.println(e);
        }
    }
}
