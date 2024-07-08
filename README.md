# Godot Ray Tracer

Ein einfacher Ray-Tracer in der Godot Engine der das Rendern von Kugeln und Ebenen mit lambartischen, metallischen und dielektrischen Materialien unterstützt.

## Anleitung

Die Einstellungen zur Bildqualität und Kamera können über die entsprechenden Variablen in `Scripts\Singletons\settings.gd` geändert werden. Dies umfasst die folgenden Einstellungsmöglichkeiten:

| Parameter           | Beschreibung                                                 |
| ------------------- | ------------------------------------------------------------ |
| `image_width`       | Breite des Bilds in Pixeln                                   |
| `image_height`      | Höhe des Bilds in Pixeln                                     |
| `samples_per_pixel` | Anzahl der Samples die pro Pixel gemacht werden              |
| `max_ray_bounces`   | Anzahl der maximalen Reflektierungen die ein Ray haben darf  |
| `thread_count`      | Anzahl der Threads auf die der Rendervorgang aufgeteilt wird |
| `vfov`              | Field of View der Kamera als horizontalen Öffnungswinkel     |
| `look_from`         | Position der Kamera in der Szene                             |
| `look_at`           | Punkt in der Szene auf den die Kamera gerichtet ist          |
| `vup`               | Ausrichtung der Kamera                                       |
| `defocus_angle`     | Winkel um den das Bild nicht fokussiert ist                  |
| `focus_dist`        | Distanz zwischen der Kamera und dem fokussierten Punkt       |

Die Objekte und Materialien in der Szene könne in der `get_world()` Methode in `Scripts\Singletons\world.gd` angepasst werden:

| Objekt                | Konstruktor                                 |
| --------------------- | ------------------------------------------- |
| Kugel                 | `Sphere.new(Position, Radius, Material)`    |
| Ebene                 | `MyPlane.new(Position, Normale, Material)`  |
| Lambartian-Material   | `LambertianMaterial.new(Farbe)`             |
| Metall-Material       | `MetalMaterial.new(Farbe, Reflektionsgrad)` |
| Dielektrikum-Material | `DielectricMaterial.new(Refraktionsgrad)`   |

Alle Objekte müssen dabei in einer Liste vom Typ `HittableList` gespeichert werden.

Zum Starten des Rendervorgangs dann einfach Run Project oder F5 drücken.

## Einstellungen für das erstellte Bild

| Parameter           | Wert |
| ------------------- | ---- |
| `image_width`       | 3000 |
| `image_height`      | 2000 |
| `samples_per_pixel` | 4    |
| `max_ray_bounces`   | 5    |
| `thread_count`      | 4    |

Die Qualität kann stark verbessert werden, indem die Samples und Bounces auf wesentlich höhere Werte gesetzt werden, z.B. Samples auf 1000 und Bounces auf 500. Aber da der Vorgang mit den verwendeten Einstellungen bereits 2 Stunden gedauert habe ich es mir gespart das zu versuchen.

## Quellen

- [Ray Tracing In One Weekend](https://raytracing.github.io/books/RayTracingInOneWeekend.html)

- [A Minimal Ray-Tracer](https://www.scratchapixel.com/lessons/3d-basic-rendering/minimal-ray-tracer-rendering-simple-shapes/parametric-and-implicit-surfaces.html)

- [Image Synthesis](https://www.uni-marburg.de/en/fb12/research-groups/grafikmultimedia/lectures/graphics2)


