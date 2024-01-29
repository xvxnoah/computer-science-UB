[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/iVhjdzUt)
[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-718a45dd9cf7e7f842a935f5ebbe5719a5e09af4491e668f4dbf3b35d5cca122.svg)](https://classroom.github.com/online_ide?assignment_repo_id=10840711&assignment_repo_type=AssignmentRepo)
---
- Noah Márquez Vara,  Alejandro Guzman Requena
- Maig 2023
---

# Pràctica 2 - FastAPI and Vue application

## Introducció

Aquesta pràctica presenta una implementació completa d'una aplicació web destinada a la visualització i reserva d'entrades per a esdeveniments esportius. La construcció d'aquesta aplicació s'ha realitzat amb una orientació a serveis, utilitzant el patró arquitectònic de REST-API i un front-end interactiu.

Per al desenvolupament del back-end de l'aplicació, s'ha fet ús del framework FastAPI, el qual ofereix una alta eficiència i facilita la creació d'APIs amb Python 3.6+. Aquest framework proporciona una gran varietat de característiques com validació automàtica de requests i responses, serialització, autenticació basada en tokens, entre altres.

El front-end de l'aplicació s'ha desenvolupat utilitzant Vue.js, una plataforma de JavaScript per a la construcció d'interfícies d'usuari. Vue és una eina progressiva, el que significa que es pot adoptar de manera incremental segons les necessitats del projecte.

A més, aquesta pràctica incorpora conceptes de programació distribuïda i testeig del software. En concret, s'han implementat i provat funcionalitats de gestió de dades com l'addició, eliminació i modificació d'entrades esportives.

Finalment, s'ha portat a terme una sessió de test exhaustiva per detectar possibles errors i millores a implementar en la nostra aplicació. Els resultats obtinguts d'aquesta sessió ens han permès depurar la nostra aplicació i millorar l'experiència d'usuari, afegint funcionalitats de notificació d'accions d'usuari, millora de la protecció d'endpoints, entre altres.

Amb tot això, aquesta pràctica aprofundeix en l'ús d'eines modernes de desenvolupament web, en l'aplicació de bones pràctiques de programació i en l'ús de mètodes de testeig i validació del software.

## Execució 



## Afegir dades a la base de dades

Per tal d'afegir les dades (teams, competitions i matches) a la nostra base de dades de PostgresSQL feiem servir Postman.

Per tal d'afegir un **Team** fem un POST a path/teams, amb el següent format de JSON:

```json
{
    "name": "The Lakers",
    "country": "United States",
    "description": "A professional basketball team based in Los Angeles"
}
```


Per tal d'afegir una **Competition** fem un POST a path/competitions, amb el següent format de JSON:

```json
{
    "name": "Basketball Championship",
    "category": "Professional",
    "sport": "Basketball",
    "teams": [
        {
            "id": 13,
            "name": "The Lakers",
            "country": "United States"
        },
        {
            "id": 14,
            "name": "The Raptors",
            "country": "Canada"
        },
        {
            "id": 15,
            "name": "The Spurs",
            "country": "United States"
        },
        {
            "id": 16,
            "name": "The Breakers",
            "country": "New Zealand"
        }
    ]
}
```


Per tal d'afegir un **Match** fem un POST a path/matches, amb el següent format de JSON:
```json
{
    "date": "2023-06-02T19:00:00Z",
    "price": 70.00,
    "total_available_tickets": 300,
    "local": {
        "id": 13,
        "name": "The Lakers",
        "country": "United States"
    },
    "visitor": {
        "id": 14,
        "name": "The Raptors",
        "country": "Canada"
    },
    "competition": {
        "id": 6,
        "name": "Basketball Championship",
        "category": "Professional",
        "sport": "Basketball"
    }
}
```

## Testing

Per tal de fer els tests d'aquesta pràctica, hem creat una classe *main_test* que comprova el correcte funcionament dels endpoints implementats a la classe *main.py*. La classe *main_test.py* no es troba actualment a la branca principal del repositori degut a que ho vam deixar d'utilitzar a la sessió 3.

Els tests de la classe citada ens van ser útils fins la sessió 3, però després de la creació del frontend, vam estar provant els endpoints amb el frontend i amb la documentació oferida per l'API, així que no vam tornar a actualitzar *main_test* per a altres canvis com per exemple la protecció d'endpoints realitzada a la sessió 5. Un dels motius va ser la falta de temps. 

## Proves realitzades a la sessió de test

A la sessió de test vam aprofitar sobretot per testejar la nostra implementació del web, així com la correcte connexió i communicació entre el frontend i el backend. La sessió de test ens va ajudar molt a trobar errors que d'altre forma molt segurament no haguéssim detectat, ja que si bé és cert que nosaltres al utilitzar el web no detectàvem errors, amb el simple fet d'usar-lo com a persona alièna al desenvolupament del mateix, augmenta les probabilitats de trobar errors, degut a que depén de l'usuari intenta trobar qualsevol forat que sigui font de bugs.

## Errors detectats a la sessió de test

A la sessió de test vam trobar diversos errors que afectaven al correcte funcionament del web, gràcies a l'ajuda dels nostres companys vam trobar alguns que nosaltres no ens hauríem assabentat de la seva existència.

A continuació es detallen els errors trobats, a part de la solució que hem trobat.

* El botó de finalitzar compra no funciona. $\to$ Es retorna abans de buidar la cistella, obtenint l'usuari i els partits, per tant no es produïa cap canvi en aquests dos. La solució és primer buidar la cistella, aplicar els canvis i després retornar els partits i l'usuari actualitzats.
* La cistella no es buida quan es finalitza una comanda. $\to$ Problema derivat del primer error, solucionat el que hem comentat també es realitza correctament el buidatge de la cistella.
* Un usuari pot accedir a la informació d'un altre usuari. $\to$ Degut a que no es trobava correctament implementat la protecció de l'endpoint. La solució trobada ha sigut enviar com a header el token d'inici de sessió d'un altre manera per tal que funcioni correctament el mètode implementat en la classe dependencies.py del backend. L'endpoint ara el cridem des del frontend de la següent forma:

```python
axios.get(path, {
  headers: { 'Authorization': 'Bearer ' + this.token },
  params: { 'username': this.username }
})
```
* L'usuari podía afegir a la cistella estant loggejat, això era una font de problemes degut a que s'estaba sobreescrivint les variables del frontend per després no poder traspassar els valors al backend, degut a que no es té cap endpoint al qual anar (no hi ha usuari). $\to$ Cambiar la funció del botó d'afegir a la cistella per redirigir a l'usuari a la pestaña del login en cas de no estar loggejat/registrat.

## Millores detectades a la sessió de test

A la sessió de test vam trobar diverses millores que podíem implementar al nostre web per tal de millorar la funcionalitat i usabilitat de la mateixa. La usabilitat, en canvi, es refereix a com de fàcil és per a un usuari realitzar aquestes tasques o accions. Un lloc web pot tenir una gran quantitat de funcionalitat, però si els usuaris no poden comprendre com utilitzar-la, la pàgina no serà útil. La usabilitat es tracta de dissenyar la interfície d'usuari de manera que sigui intuïtiva i fàcil d'utilitzar. Això implica consideracions 

Recordem que la funcionalitat es refereix a les tasques o accions que un usuari pot realitzar en un lloc web. La usabilitat, en canvi, es refereix a com de fàcil és per a un usuari realitzar aquestes tasques o accions. Un lloc web pot tenir una gran quantitat de funcionalitat, però si els usuaris no poden comprendre com utilitzar-la, la pàgina no serà útil. La usabilitat es tracta de dissenyar la interfície d'usuari de manera que sigui intuïtiva i fàcil d'utilitzar. Això implica consideracions com les que hem trobat durant aquesta sessió i que hem implementat per tal de millorar l'experiència dels usuaris.

A continuació es mostren les millores que hem volgut implementat i que van sorgir de la sessió de testing amb opinions i problemes que teníen els usuaris del web, amb la seva respectiva implementació dintre del nostre programa.

* Mostrar missatge de compra realitzada per tal de que l'usuari sàpiga que ha pogut comprar els tickets amb èxit en cas afirmatiu. $\to$ Implementat amb una transition i una variable successfulMessage afegits al frontend.
* Mostrar missatge conforme l'usuari s'ha loggejat o registrat correctament al web. $\to$ Implementat amb una transition i una variable successfulMessage afegits al frontend.
* Mostrar missatge d'error per tal d'indicar a l'usuari que la contrassenya que vol introduïr per registrar-se no compleix amb els requeriments establerts. $\to$ Implementat amb una transition i una variable successfulMessage afegits al frontend.
* Mostrar missatge d'error per tal d'indicar a l'usuari que el login no s'ha pogut realitzar correctament. $\to$ Implementat amb una transition i una variable successfulMessage afegits al frontend.
* Capturar l'error que indica que no es pot completar una comanda perquè l'usuari no té suficients diners. $\to$ Implementat amb una notification i transition afegides al frontend.

## Diagrama d'execució
