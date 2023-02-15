# -*- coding: utf-8 -*-
def refill(K, stations):   
    """
    Soluciona el problema de repostatge de vehicles.
    
    Params
    ======
    :K: quilòmetres que pot fer el cotxe amb el dipòsit ple.
    :stations: Punt quilomètric on es troba cada benzinera. L'últim element d'aquesta llista és el destí del trajecte.
    
    Returns
    =======
    :exists_solution: Si existeix o no solució al problema (True/False)
    :num_stops: Nombre de parades que hem de fer.
    :stops: Parades on ens aturarem (punt quilomètric).    
    """
    
    car = 0            # Posició actual del cotxe
    petrol = K         # Combustible restant 
    total_distance = 0 # Distància que hem recorregut fins al moment
    stops = []         # Benzineres on anirem repostant
    
    # Comprovem si encara no hem arribat al final
    while (car < len(stations)):
        
        # Modifiquem la benzina que ens queda i comprovem si ens hem quedat sense. En aquest cas, l'algorisme acaba
        petrol-=(stations[car]-total_distance)               
        if petrol < 0:
            return False, len(stops), stops
        
        # Actualitzem la distància recorreguda. 
        total_distance=stations[car]
        
        # Comprovem si encara estem en una benzinera.
        # Si no podem arribar a la propera benzinera amb la benzina que ens queda, repostem.
        if (car < len(stations)-1) and (petrol < (stations[car+1]-stations[car])):
            petrol = K
            stops.append(stations[car])
    
        # Movem el cotxe a la benzinera següent.
        car+=1
        
    return True, len(stops), stops
