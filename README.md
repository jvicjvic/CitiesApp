# CitiesApp

Esta aplicación lee una lista de ciudades y permite al usuario buscar y ver detalles. También es posible marcar una ciudad como favorita y buscar entre las favoritas.

## Notas sobre la implementación:
* La app está implementada con SwiftUI, Observation, Async/Await.
* Arquitectura MVVM.
* El proyecto está organizado por funcionalidades, donde cada funcionalidad tiene una subcarpeta 'UI' y 'Data' según sea necesario.
* El proyecto incluye algunas pruebas unitarias.

## Sobre la búsqueda
Para optimizar la búsqueda, al cargarse por primera vez se crea una tabla hash de índices, donde las ciudades se agrupan por la primera letra de la palabra. Por ejemplo, "Alabama" y "Albuquerque" se insertan en la clave "A". De este modo, al buscar, por ejemplo, "Alb", podemos ir directamente a la lista de ciudades que comienzan con la letra A y realizar la búsqueda ahí. Además, cada una de las listas de ciudades se almacena previamente en orden alfabético.

Sin duda, sería posible implementar una solución más robusta, pero esta es una implementación simple y eficiente para esta situación específica.

# Screenshots

![Simulator Screenshot - iPhone 16 Pro Max - 2025-01-07 at 20 53 17](https://github.com/user-attachments/assets/5325db2d-cb0e-4e22-a534-158c82fbbda7)

![Simulator Screenshot - iPhone 16 Pro Max - 2025-01-07 at 20 52 03](https://github.com/user-attachments/assets/8265bd09-2418-4e5c-aece-cf1eaac98dba)

![Simulator Screenshot - iPhone 16 Pro Max - 2025-01-07 at 20 51 57](https://github.com/user-attachments/assets/62139c5f-91f6-4597-ab04-ed60df58bf48)


![Simulator Screenshot - iPhone 16 Pro Max - 2025-01-07 at 20 53 29](https://github.com/user-attachments/assets/acf0de77-4769-4ca0-9a6a-d326b64b29e6)

![Simulator Screenshot - iPhone 16 Pro Max - 2025-01-07 at 20 53 56](https://github.com/user-attachments/assets/095ba120-d977-4bed-9a11-b59d6c3e7db7)
