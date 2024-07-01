import 'dart:ui';

import 'package:cyber_map/core/domain/models/fill_paint/fill_paint.dart';
import 'package:cyber_map/core/domain/models/map_theme_property/factory/map_theme_property_factory.dart';
import 'package:cyber_map/core/domain/models/map_theme_property/map_theme_property.dart';
import 'package:cyber_map/core/domain/models/symbol_paint/symbol_paint.dart';
import 'package:cyber_map/core/utils/extensions/color/to_map_color_string.dart';

Color cyan = const Color(0xFF00FFFF);
Color green = const Color(0xFF00FF00);
Color red = const Color(0xFFFF0000);
Color blue = const Color(0xFF0000FF);
Color yellow = const Color(0xFFFFFF00);
Color magenta = const Color(0xFFFF00FF);

Color white = const Color(0xFFFFFFFF);
Color black = const Color(0xFF000000);

bool roadsVisible = true;
bool buildingsVisible = true;
bool waterVisible = true;
bool landuseVisible = true;
bool landcoverVisible = true;
bool poiVisible = true;
bool boundariesVisible = true;
bool aerowayVisible = true;
bool transportationVisible = true;
bool pathsVisible = true;
bool railwayVisible = true;
bool labelsVisible = true;

FillPaint buildingPaint = FillPaint(
  fillColor: MapThemeProperty<Color>(
    value: magenta,
  ),
  fillOpacity: MapThemePropertyFactory.createMapThemeProperty(0.5),
);

SymbolPaint waterLabelPaint = SymbolPaint(
  textColor: blue,
  textSize: 14,
  textHaloColor: black,
  textHaloWidth: 1,
);

SymbolPaint roadLabelPaint = SymbolPaint(
  textColor: green,
  textSize: 14,
  textHaloColor: black,
  textHaloWidth: 1,
);

SymbolPaint poiLabelPaint = SymbolPaint(
  textColor: yellow,
  textSize: 14,
  textHaloColor: black,
  textHaloWidth: 1,
);
SymbolPaint placeLabelPaint = SymbolPaint(
  textColor: cyan,
  textSize: 14,
  textHaloColor: black,
  textHaloWidth: 1,
);

Map<String, dynamic> defaultThemeData = {
  "version": 8,
  "name": "Bright",
  "metadata": {
    "openmaptiles:mapbox:owner": "openmaptiles",
    "openmaptiles:version": "3.x",
  },
  "sources": {
    "openmaptiles": {
      "type": "vector",
      "url": "http://localhost:8080/spec.json",
    },
  },
  "sprite": "https://github.com/maputnik/osm-liberty/tree/gh-pages/sprites",
  "glyphs":
      "https://raw.githubusercontent.com/baconjuggling/map_fonts/master/{fontstack}/{range}.pbf",
  "layers": [
    {
      "id": "background",
      "type": "background",
      "paint": {"background-color": black.toMapColorString()},
    },

    {
      "id": "landcover-glacier",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "landcover",
      "filter": ["==", "subclass", "glacier"],
      "layout": {"visibility": landcoverVisible ? "visible" : "none"},
      "paint": {
        "fill-color": "#fff",
        "fill-opacity": {
          "base": 1,
          "stops": [
            [0, 0.9],
            [10, 0.3],
          ],
        },
      },
    },
    {
      "id": "landuse-residential",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "landuse",
      "filter": [
        "all",
        ["in", "class", "residential", "suburb", "neighbourhood"],
      ],
      "layout": {"visibility": landuseVisible ? "visible" : "none"},
      "paint": {
        "fill-color": magenta.toMapColorString(),
        "fill-opacity": 0.2,
      },
    },
    //agriculture
    {
      "id": "landuse-farmland",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "landuse",
      "filter": ["==", "class", "farmland"],
      "layout": {"visibility": landuseVisible ? "visible" : "none"},
      "paint": {"fill-color": yellow.toMapColorString(), "fill-opacity": 0.3},
    },
    {
      "id": "landuse-commercial",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "landuse",
      "filter": [
        "all",
        ["==", "\$type", "Polygon"],
        ["==", "class", "commercial"],
      ],
      "layout": {"visibility": landuseVisible ? "visible" : "none"},
      "paint": {"fill-color": blue.toMapColorString(), "fill-opacity": 0.2},
    },
    {
      "id": "landuse-industrial",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "landuse",
      "filter": [
        "all",
        ["==", "\$type", "Polygon"],
        ["in", "class", "industrial", "garages", "dam"],
      ],
      "layout": {"visibility": landuseVisible ? "visible" : "none"},
      "paint": {"fill-color": yellow.toMapColorString(), "fill-opacity": 0.2},
    },
    {
      "id": "landuse-cemetery",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "landuse",
      "filter": ["==", "class", "cemetery"],
      "layout": {"visibility": landuseVisible ? "visible" : "none"},
      "paint": {"fill-color": "#e0e4dd"},
    },
    {
      "id": "landuse-hospital",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "landuse",
      "filter": ["==", "class", "hospital"],
      "layout": {"visibility": landuseVisible ? "visible" : "none"},
      "paint": {"fill-color": "#fde"},
    },
    {
      "id": "landuse-school",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "landuse",
      "layout": {"visibility": landuseVisible ? "visible" : "none"},
      "filter": ["==", "class", "school"],
      "paint": {"fill-color": magenta.toMapColorString(), "fill-opacity": 0.2},
    },
    {
      "id": "landuse-railway",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "landuse",
      "filter": ["==", "class", "railway"],
      "layout": {"visibility": "visible"},
      "paint": {"fill-color": "hsla(30, 19%, 90%, 0.4)"},
    },
    {
      "id": "landuse-military",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "landuse",
      "filter": ["==", "class", "military"],
      "layout": {"visibility": landuseVisible ? "visible" : "none"},
      "paint": {
        "fill-color": red.toMapColorString(),
        "fill-opacity": 0.6,
      },
    },

    {
      "id": "landcover-wood",
      "type": "fill",
      "source": "openmaptiles",
      "layout": {"visibility": landcoverVisible ? "visible" : "none"},
      "source-layer": "landcover",
      "filter": ["==", "class", "wood"],
      "paint": {
        "fill-color": green.toMapColorString(),
        "fill-opacity": 0.6,
      },
    },
    {
      "id": "landcover-grass",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "landcover",
      "layout": {"visibility": landcoverVisible ? "visible" : "none"},
      "filter": ["==", "class", "grass"],
      "paint": {"fill-color": green.toMapColorString(), "fill-opacity": 0.4},
    },
    {
      "id": "landcover-grass-park",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "park",
      "filter": ["==", "class", "public_park"],
      "layout": {"visibility": landcoverVisible ? "visible" : "none"},
      "paint": {"fill-color": green.toMapColorString(), "fill-opacity": 0.4},
    },
    {
      "id": "waterway_tunnel",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "waterway",
      "minzoom": 12,
      "filter": [
        "all",
        ["in", "class", "river", "stream", "canal"],
        ["==", "brunnel", "tunnel"],
      ],
      "layout": {
        "line-cap": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-opacity": .5,
        "line-color": "#a0c8f0",
        "line-dasharray": [2, 4],
        "line-width": {
          "base": 1.3,
          "stops": [
            [13, 0.5],
            [20, 6],
          ],
        },
      },
    },
    {
      "id": "waterway-other",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "waterway",
      "filter": [
        "all",
        ["!in", "class", "canal", "river", "stream"],
        ["==", "intermittent", 0],
      ],
      "layout": {
        "line-cap": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#a0c8f0",
        "line-width": {
          "base": 1.3,
          "stops": [
            [13, 0.5],
            [20, 2],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "waterway-other-intermittent",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "waterway",
      "filter": [
        "all",
        ["!in", "class", "canal", "river", "stream"],
        ["==", "intermittent", 1],
      ],
      "layout": {
        "line-cap": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#a0c8f0",
        "line-dasharray": [4, 3],
        "line-width": {
          "base": 1.3,
          "stops": [
            [13, 0.5],
            [20, 2],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "waterway-stream-canal",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "waterway",
      "filter": [
        "all",
        ["in", "class", "canal", "stream"],
        ["!=", "brunnel", "tunnel"],
        ["==", "intermittent", 0],
      ],
      "layout": {
        "line-cap": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#a0c8f0",
        "line-width": {
          "base": 1.3,
          "stops": [
            [13, 0.5],
            [20, 6],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "waterway-stream-canal-intermittent",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "waterway",
      "filter": [
        "all",
        ["in", "class", "canal", "stream"],
        ["!=", "brunnel", "tunnel"],
        ["==", "intermittent", 1],
      ],
      "layout": {
        "line-cap": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#a0c8f0",
        "line-dasharray": [4, 3],
        "line-width": {
          "base": 1.3,
          "stops": [
            [13, 0.5],
            [20, 6],
          ],
          "line-opacity": .5,
        },
      },
    },
    {
      "id": "waterway-river",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "waterway",
      "filter": [
        "all",
        ["==", "class", "river"],
        ["!=", "brunnel", "tunnel"],
        ["==", "intermittent", 0],
      ],
      "layout": {
        "line-cap": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#a0c8f0",
        "line-width": {
          "base": 1.2,
          "stops": [
            [10, 0.8],
            [20, 6],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "waterway-river-intermittent",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "waterway",
      "filter": [
        "all",
        ["==", "class", "river"],
        ["!=", "brunnel", "tunnel"],
        ["==", "intermittent", 1],
      ],
      "layout": {
        "line-cap": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#a0c8f0",
        "line-dasharray": [3, 2.5],
        "line-width": {
          "base": 1.2,
          "stops": [
            [10, 0.8],
            [20, 6],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "water-offset",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "water",
      "maxzoom": 8,
      "filter": ["==", "\$type", "Polygon"],
      "layout": {"visibility": waterVisible ? "visible" : "none"},
      "paint": {
        "fill-color": "#a0c8f0",
        "fill-opacity": 1,
        "fill-translate": {
          "base": 1,
          "stops": [
            [
              6,
              [2, 0],
            ],
            [
              8,
              [0, 0],
            ]
          ],
        },
      },
    },
    {
      "id": "water",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "water",
      "filter": [
        "all",
        ["!=", "intermittent", 1],
        ["!=", "brunnel", "tunnel"],
      ],
      "layout": {"visibility": waterVisible ? "visible" : "none"},
      "paint": {"fill-color": blue.toMapColorString()},
    },

    {
      "id": "water-intermittent",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "water",
      "filter": [
        "all",
        ["==", "intermittent", 1],
      ],
      "layout": {"visibility": waterVisible ? "visible" : "none"},
      "paint": {"fill-color": blue.toMapColorString()},
    },
    {
      "id": "water-pattern",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "water",
      "filter": ["all"],
      "layout": {"visibility": waterVisible ? "visible" : "none"},
      "paint": FillPaint(
        fillColor: MapThemePropertyFactory.createMapThemeProperty(black),
        fillOpacity: MapThemePropertyFactory.createMapThemeProperty(1),
        fillPattern: MapThemePropertyFactory.createMapThemeProperty("wave"),
      ).toMap(),
    },
    {
      "id": "landcover-ice-shelf",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "landcover",
      "filter": ["==", "subclass", "ice_shelf"],
      "layout": {"visibility": landcoverVisible ? "visible" : "none"},
      "paint": {
        "fill-color": "#fff",
        "fill-opacity": {
          "base": 1,
          "stops": [
            [0, 0.9],
            [10, 0.3],
          ],
        },
      },
    },
    {
      "id": "landcover-sand",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "landcover",
      "filter": [
        "all",
        ["==", "class", "sand"],
      ],
      "layout": {"visibility": landcoverVisible ? "visible" : "none"},
      "paint": {"fill-color": "rgba(245, 238, 188, 1)", "fill-opacity": 1},
    },
    {
      "id": "building",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "building",
      "layout": {"visibility": buildingsVisible ? "visible" : "none"},
      "paint": buildingPaint.toMap(),
    },
    {
      "id": "building-top",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "building",
      "layout": {"visibility": buildingsVisible ? "visible" : "none"},
      "paint": buildingPaint.toMap(),
    },
    {
      "id": "tunnel-service-track-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "tunnel"],
        ["in", "class", "service", "track"],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#cfcdca",
        "line-dasharray": [0.5, 0.25],
        "line-width": {
          "base": 1.2,
          "stops": [
            [15, 1],
            [16, 4],
            [20, 11],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "tunnel-motorway-link-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "tunnel"],
        ["==", "class", "motorway"],
        ["==", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "rgba(200, 147, 102, 1)",
        "line-dasharray": [0.5, 0.25],
        "line-width": {
          "base": 1.2,
          "stops": [
            [12, 1],
            [13, 3],
            [14, 4],
            [20, 15],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "tunnel-minor-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "tunnel"],
        ["==", "class", "minor"],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#cfcdca",
        "line-width": {
          "base": 1.2,
          "stops": [
            [12, 0.5],
            [13, 1],
            [14, 4],
            [20, 15],
          ],
        },
        "line-dasharray": [0.5, 0.25],
        "line-opacity": .5,
      },
    },
    {
      "id": "tunnel-link-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "tunnel"],
        ["in", "class", "trunk", "primary", "secondary", "tertiary"],
        ["==", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#e9ac77",
        "line-opacity": 0.5,
        "line-width": {
          "base": 1.2,
          "stops": [
            [12, 1],
            [13, 3],
            [14, 4],
            [20, 15],
          ],
        },
        "line-dasharray": [0.5, 0.25],
      },
    },
    {
      "id": "tunnel-secondary-tertiary-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "tunnel"],
        ["in", "class", "secondary", "tertiary"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#e9ac77",
        "line-opacity": 0.5,
        "line-width": {
          "base": 1.2,
          "stops": [
            [8, 1.5],
            [20, 17],
          ],
        },
        "line-dasharray": [0.5, 0.25],
      },
    },
    {
      "id": "tunnel-trunk-primary-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "tunnel"],
        ["in", "class", "primary", "trunk"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#e9ac77",
        "line-width": {
          "base": 1.2,
          "stops": [
            [5, 0.4],
            [6, 0.6],
            [7, 1.5],
            [20, 22],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "tunnel-motorway-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "tunnel"],
        ["==", "class", "motorway"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#e9ac77",
        "line-dasharray": [0.5, 0.25],
        "line-width": {
          "base": 1.2,
          "stops": [
            [5, 0.4],
            [6, 0.6],
            [7, 1.5],
            [20, 22],
          ],
          "line-opacity": .5,
        },
      },
    },
    {
      "id": "tunnel-path",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["==", "brunnel", "tunnel"],
        ["==", "class", "path"],
      ],
      "layout": {
        "line-join": "round",
        "visibility": pathsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#cba",
        "line-dasharray": [1.5, 0.75],
        "line-width": {
          "base": 1.2,
          "stops": [
            [15, 1.2],
            [20, 4],
          ],
        },
      },
    },
    {
      "id": "tunnel-motorway-link",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "tunnel"],
        ["==", "class", "motorway"],
        ["==", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "rgba(244, 209, 158, 1)",
        "line-opacity": .5,
        "line-width": {
          "base": 1.2,
          "stops": [
            [12.5, 0],
            [13, 1.5],
            [14, 2.5],
            [20, 11.5],
          ],
        },
      },
    },
    {
      "id": "tunnel-service-track",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "tunnel"],
        ["in", "class", "service", "track"],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#fff",
        "line-width": {
          "base": 1.2,
          "stops": [
            [15.5, 0],
            [16, 2],
            [20, 7.5],
          ],
        },
      },
      "line-opacity": .5,
    },
    {
      "id": "tunnel-link",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "tunnel"],
        ["in", "class", "trunk", "primary", "secondary", "tertiary"],
        ["==", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#fff4c6",
        "line-width": {
          "base": 1.2,
          "stops": [
            [12.5, 0],
            [13, 1.5],
            [14, 2.5],
            [20, 11.5],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "tunnel-minor",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "tunnel"],
        ["==", "class", "minor_road"],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#fff",
        "line-opacity": 0.5,
        "line-width": {
          "base": 1.2,
          "stops": [
            [13.5, 0],
            [14, 2.5],
            [20, 11.5],
          ],
        },
        "line-opacit": .5,
      },
    },
    {
      "id": "tunnel-secondary-tertiary",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "tunnel"],
        ["in", "class", "secondary", "tertiary"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#fff4c6",
        "line-width": {
          "base": 1.2,
          "stops": [
            [6.5, 0],
            [7, 0.5],
            [20, 10],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "tunnel-trunk-primary",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "tunnel"],
        ["in", "class", "primary", "trunk"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#fff4c6",
        "line-width": {
          "base": 1.2,
          "stops": [
            [6.5, 0],
            [7, 0.5],
            [20, 18],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "tunnel-motorway",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "tunnel"],
        ["==", "class", "motorway"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#ffdaa6",
        "line-width": {
          "base": 1.2,
          "stops": [
            [6.5, 0],
            [7, 0.5],
            [20, 18],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "tunnel-railway",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "tunnel"],
        ["==", "class", "rail"],
      ],
      "layout": {"visibility": roadsVisible ? "visible" : "none"},
      "paint": {
        "line-color": "#bbb",
        "line-dasharray": [2, 2],
        "line-width": {
          "base": 1.4,
          "stops": [
            [14, 0.4],
            [15, 0.75],
            [20, 2],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "ferry",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["in", "class", "ferry"],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "rgba(108, 159, 182, 1)",
        "line-dasharray": [2, 2],
        "line-width": 1.1,
        "line-opacity": .5,
      },
    },
    {
      "id": "aeroway-taxiway-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "aeroway",
      "minzoom": 12,
      "filter": [
        "all",
        ["in", "class", "taxiway"],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": aerowayVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "rgba(153, 153, 153, 1)",
        "line-opacity": 0.5,
        "line-width": {
          "base": 1.5,
          "stops": [
            [11, 2],
            [17, 12],
          ],
        },
      },
    },
    {
      "id": "aeroway-runway-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "aeroway",
      "minzoom": 12,
      "filter": [
        "all",
        ["in", "class", "runway"],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": aerowayVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "rgba(153, 153, 153, 1)",
        "line-opacity": 0.5,
        "line-width": {
          "base": 1.5,
          "stops": [
            [11, 5],
            [17, 55],
          ],
        },
      },
    },
    {
      "id": "aeroway-area",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "aeroway",
      "minzoom": 4,
      "filter": [
        "all",
        ["==", "\$type", "Polygon"],
        ["in", "class", "runway", "taxiway"],
      ],
      "layout": {"visibility": aerowayVisible ? "visible" : "none"},
      "paint": {
        "fill-color": "rgba(255, 255, 255, 1)",
        "fill-opacity": {
          "base": 1,
          "stops": [
            [13, 0],
            [14, 1],
          ],
        },
      },
    },
    {
      "id": "aeroway-taxiway",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "aeroway",
      "minzoom": 4,
      "filter": [
        "all",
        ["in", "class", "taxiway"],
        ["==", "\$type", "LineString"],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": aerowayVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "rgba(255, 255, 255, 1)",
        "line-opacity": {
          "base": 1,
          "stops": [
            [11, 0],
            [12, 1],
          ],
        },
        "line-width": {
          "base": 1.5,
          "stops": [
            [11, 1],
            [17, 10],
          ],
        },
      },
    },
    {
      "id": "aeroway-runway",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "aeroway",
      "minzoom": 4,
      "filter": [
        "all",
        ["in", "class", "runway"],
        ["==", "\$type", "LineString"],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": aerowayVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "rgba(255, 255, 255, 1)",
        "line-opacity": {
          "base": 1,
          "stops": [
            [11, 0],
            [12, 1],
          ],
        },
        "line-width": {
          "base": 1.5,
          "stops": [
            [11, 4],
            [17, 50],
          ],
        },
      },
    },
    {
      "id": "road_area_pier",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "\$type", "Polygon"],
        ["==", "class", "pier"],
      ],
      "layout": {"visibility": roadsVisible ? "visible" : "none"},
      "paint": {
        "fill-antialias": true,
        "fill-color": "#f8f4f0",
        "line-opacity": .5,
      },
    },
    {
      "id": "road_pier",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["in", "class", "pier"],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#f8f4f0",
        "line-width": {
          "base": 1.2,
          "stops": [
            [15, 1],
            [17, 4],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "highway-area",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "\$type", "Polygon"],
        ["!in", "class", "pier"],
      ],
      "layout": {"visibility": roadsVisible ? "visible" : "none"},
      "paint": {
        "fill-antialias": false,
        "fill-color": red.toMapColorString(),
        "fill-opacity": 0.5,
        "fill-outline-color": "#cfcdca",
      },
    },
    {
      "id": "highway-motorway-link-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "minzoom": 12,
      "filter": [
        "all",
        ["!in", "brunnel", "bridge", "tunnel"],
        ["==", "class", "motorway"],
        ["==", "ramp", 1],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": cyan.toMapColorString(),
        "line-opacity": 0.5,
        "line-width": {
          "base": 1.2,
          "stops": [
            [12, 1],
            [13, 3],
            [14, 4],
            [20, 15],
          ],
        },
      },
    },
    {
      "id": "highway-link-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "minzoom": 13,
      "filter": [
        "all",
        ["!in", "brunnel", "bridge", "tunnel"],
        ["in", "class", "trunk", "primary", "secondary", "tertiary"],
        ["==", "ramp", 1],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": cyan.toMapColorString(),
        "line-opacity": 0.5,
        "line-width": {
          "base": 1.2,
          "stops": [
            [12, 1],
            [13, 3],
            [14, 4],
            [20, 15],
          ],
        },
      },
    },
    {
      "id": "highway-minor-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["!=", "brunnel", "tunnel"],
        ["in", "class", "minor", "service", "track"],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#cfcdca",
        "line-opacity": 0.5,
        "line-width": {
          "base": 1.2,
          "stops": [
            [12, 0.5],
            [13, 1],
            [14, 4],
            [20, 15],
          ],
        },
      },
    },
    {
      "id": "highway-secondary-tertiary-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["!in", "brunnel", "bridge", "tunnel"],
        ["in", "class", "secondary", "tertiary"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-cap": "butt",
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": red.toMapColorString(),
        "line-opacity": 0.5,
        "line-width": {
          "base": 1.2,
          "stops": [
            [8, 1.5],
            [20, 17],
          ],
        },
      },
    },
    {
      "id": "highway-primary-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "minzoom": 5,
      "filter": [
        "all",
        ["!in", "brunnel", "bridge", "tunnel"],
        ["in", "class", "primary"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-cap": "butt",
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": green.toMapColorString(),
        "line-opacity": 0.5,
        "line-width": {
          "base": 1.2,
          "stops": [
            [7, 0],
            [8, 0.6],
            [9, 1.5],
            [20, 22],
          ],
        },
      },
    },
    {
      "id": "highway-trunk-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "minzoom": 5,
      "filter": [
        "all",
        ["!in", "brunnel", "bridge", "tunnel"],
        ["in", "class", "trunk"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-cap": "butt",
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#e9ac77",
        "line-opacity": 0.5,
        "line-width": {
          "base": 1.2,
          "stops": [
            [5, 0],
            [6, 0.6],
            [7, 1.5],
            [20, 22],
          ],
        },
      },
    },
    {
      "id": "highway-motorway-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "minzoom": 4,
      "filter": [
        "all",
        ["!in", "brunnel", "bridge", "tunnel"],
        ["==", "class", "motorway"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-cap": "butt",
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#e9ac77",
        "line-opacity": 0.5,
        "line-width": {
          "base": 1.2,
          "stops": [
            [4, 0],
            [5, 0.4],
            [6, 0.6],
            [7, 1.5],
            [20, 22],
          ],
        },
      },
    },
    {
      "id": "highway-path",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["!in", "brunnel", "bridge", "tunnel"],
        ["==", "class", "path"],
      ],
      "layout": {"visibility": pathsVisible ? "visible" : "none"},
      "paint": {
        "line-color": green.toMapColorString(),
        "line-dasharray": [1.5, 0.75],
        "line-width": {
          "base": 1.2,
          "stops": [
            [15, 1.2],
            [20, 4],
          ],
        },
      },
    },
    {
      "id": "highway-motorway-link",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "minzoom": 12,
      "filter": [
        "all",
        ["!in", "brunnel", "bridge", "tunnel"],
        ["==", "class", "motorway"],
        ["==", "ramp", 1],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#fc8",
        "line-width": {
          "base": 1.2,
          "stops": [
            [12.5, 0],
            [13, 1.5],
            [14, 2.5],
            [20, 11.5],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "highway-link",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "minzoom": 13,
      "filter": [
        "all",
        ["!in", "brunnel", "bridge", "tunnel"],
        ["in", "class", "trunk", "primary", "secondary", "tertiary"],
        ["==", "ramp", 1],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#fea",
        "line-width": {
          "base": 1.2,
          "stops": [
            [12.5, 0],
            [13, 1.5],
            [14, 2.5],
            [20, 11.5],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "highway-minor",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["!=", "brunnel", "tunnel"],
        ["in", "class", "minor", "service", "track"],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#fff",
        "line-opacity": .5,
        "line-width": {
          "base": 1.2,
          "stops": [
            [13.5, 0],
            [14, 2.5],
            [20, 11.5],
          ],
        },
      },
    },
    {
      "id": "highway-secondary-tertiary",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["!in", "brunnel", "bridge", "tunnel"],
        ["in", "class", "secondary", "tertiary"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": red.toMapColorString(),
        "line-width": {
          "base": 1.2,
          "stops": [
            [6.5, 0],
            [8, 0.5],
            [20, 13],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "highway-primary",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["!in", "brunnel", "bridge", "tunnel"],
        ["in", "class", "primary"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": green.toMapColorString(),
        "line-opacity": .5,
        "line-width": {
          "base": 1.2,
          "stops": [
            [8.5, 0],
            [9, 0.5],
            [20, 18],
          ],
        },
      },
    },
    {
      "id": "highway-trunk",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["!in", "brunnel", "bridge", "tunnel"],
        ["in", "class", "trunk"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#fea",
        "line-width": {
          "base": 1.2,
          "stops": [
            [6.5, 0],
            [7, 0.5],
            [20, 18],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "highway-motorway",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "minzoom": 5,
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["!in", "brunnel", "bridge", "tunnel"],
        ["==", "class", "motorway"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#fc8",
        "line-width": {
          "base": 1.2,
          "stops": [
            [6.5, 0],
            [7, 0.5],
            [20, 18],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "railway-transit",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["==", "class", "transit"],
        ["!in", "brunnel", "tunnel"],
      ],
      "layout": {"visibility": railwayVisible ? "visible" : "none"},
      "paint": {
        "line-color": "hsla(0, 0%, 73%, 0.77)",
        "line-width": {
          "base": 1.4,
          "stops": [
            [14, 0.4],
            [20, 1],
          ],
        },
      },
    },
    {
      "id": "railway-transit-hatching",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["==", "class", "transit"],
        ["!in", "brunnel", "tunnel"],
      ],
      "layout": {"visibility": railwayVisible ? "visible" : "none"},
      "paint": {
        "line-color": "hsla(0, 0%, 73%, 0.68)",
        "line-dasharray": [0.2, 8],
        "line-width": {
          "base": 1.4,
          "stops": [
            [14.5, 0],
            [15, 2],
            [20, 6],
          ],
        },
      },
    },
    {
      "id": "railway-service",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "layout": {"visibility": railwayVisible ? "visible" : "none"},
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["==", "class", "rail"],
        ["has", "service"],
      ],
      "paint": {
        "line-color": "hsla(0, 0%, 73%, 0.77)",
        "line-width": {
          "base": 1.4,
          "stops": [
            [14, 0.4],
            [20, 1],
          ],
        },
      },
    },
    {
      "id": "railway-service-hatching",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["==", "class", "rail"],
        ["has", "service"],
      ],
      "layout": {"visibility": railwayVisible ? "visible" : "none"},
      "paint": {
        "line-color": "hsla(0, 0%, 73%, 0.68)",
        "line-dasharray": [0.2, 8],
        "line-width": {
          "base": 1.4,
          "stops": [
            [14.5, 0],
            [15, 2],
            [20, 6],
          ],
        },
      },
    },
    {
      "id": "railway",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "layout": {"visibility": railwayVisible ? "visible" : "none"},
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["!has", "service"],
        ["!in", "brunnel", "bridge", "tunnel"],
        ["==", "class", "rail"],
      ],
      "paint": {
        "line-color": "#bbb",
        "line-width": {
          "base": 1.4,
          "stops": [
            [14, 0.4],
            [15, 0.75],
            [20, 2],
          ],
        },
      },
    },
    {
      "id": "railway-hatching",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["!has", "service"],
        ["!in", "brunnel", "bridge", "tunnel"],
        ["==", "class", "rail"],
      ],
      "layout": {"visibility": railwayVisible ? "visible" : "none"},
      "paint": {
        "line-color": "#bbb",
        "line-dasharray": [0.2, 8],
        "line-width": {
          "base": 1.4,
          "stops": [
            [14.5, 0],
            [15, 3],
            [20, 8],
          ],
        },
      },
    },
    {
      "id": "bridge-motorway-link-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "bridge"],
        ["==", "class", "motorway"],
        ["==", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#e9ac77",
        "line-opacity": 0.5,
        "line-width": {
          "base": 1.2,
          "stops": [
            [12, 1],
            [13, 3],
            [14, 4],
            [20, 19],
          ],
        },
      },
    },
    {
      "id": "bridge-link-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "bridge"],
        ["in", "class", "trunk", "primary", "secondary", "tertiary"],
        ["==", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#e9ac77",
        "line-opacity": 0.5,
        "line-width": {
          "base": 1.2,
          "stops": [
            [12, 1],
            [13, 3],
            [14, 4],
            [20, 19],
          ],
        },
      },
    },
    {
      "id": "bridge-secondary-tertiary-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "bridge"],
        ["in", "class", "secondary", "tertiary"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#e9ac77",
        "line-opacity": 0.5,
        "line-width": {
          "base": 1.2,
          "stops": [
            [5, 0.4],
            [7, 0.6],
            [8, 1.5],
            [20, 21],
          ],
        },
      },
    },
    {
      "id": "bridge-trunk-primary-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "bridge"],
        ["in", "class", "primary", "trunk"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "hsl(28, 76%, 67%)",
        "line-width": {
          "base": 1.2,
          "stops": [
            [5, 0.4],
            [6, 0.6],
            [7, 1.5],
            [20, 26],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "bridge-motorway-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "bridge"],
        ["==", "class", "motorway"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#e9ac77",
        "line-width": {
          "base": 1.2,
          "stops": [
            [5, 0.4],
            [6, 0.6],
            [7, 1.5],
            [20, 26],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "bridge-minor-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["==", "brunnel", "bridge"],
        ["in", "class", "minor", "service", "track"],
      ],
      "layout": {
        "line-cap": "butt",
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#cfcdca",
        "line-opacity": 0.5,
        "line-width": {
          "base": 1.2,
          "stops": [
            [12, 0.5],
            [13, 1],
            [14, 6],
            [20, 24],
          ],
        },
      },
    },
    {
      "id": "bridge-path-casing",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["==", "brunnel", "bridge"],
        ["==", "class", "path"],
      ],
      "layout": {
        "line-cap": "butt",
        "line-join": "round",
        "visibility": pathsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#f8f4f0",
        "line-width": {
          "base": 1.2,
          "stops": [
            [15, 1.2],
            [20, 18],
          ],
        },
      },
    },
    {
      "id": "bridge-path",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["==", "brunnel", "bridge"],
        ["==", "class", "path"],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": pathsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#cba",
        "line-dasharray": [1.5, 0.75],
        "line-width": {
          "base": 1.2,
          "stops": [
            [15, 1.2],
            [20, 4],
          ],
        },
      },
    },
    {
      "id": "bridge-motorway-link",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "bridge"],
        ["==", "class", "motorway"],
        ["==", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#fc8",
        "line-width": {
          "base": 1.2,
          "stops": [
            [12.5, 0],
            [13, 1.5],
            [14, 2.5],
            [20, 11.5],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "bridge-link",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "bridge"],
        ["in", "class", "trunk", "primary", "secondary", "tertiary"],
        ["==", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#fea",
        "line-width": {
          "base": 1.2,
          "stops": [
            [12.5, 0],
            [13, 1.5],
            [14, 2.5],
            [20, 11.5],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "bridge-minor",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["==", "brunnel", "bridge"],
        ["in", "class", "minor", "service", "track"],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#fff",
        "line-opacity": 0.5,
        "line-width": {
          "base": 1.2,
          "stops": [
            [13.5, 0],
            [14, 2.5],
            [20, 11.5],
          ],
        },
      },
    },
    {
      "id": "bridge-secondary-tertiary",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "bridge"],
        ["in", "class", "secondary", "tertiary"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#fea",
        "line-width": {
          "base": 1.2,
          "stops": [
            [6.5, 0],
            [8, 0.5],
            [20, 13],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "bridge-trunk-primary",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "bridge"],
        ["in", "class", "primary", "trunk"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#fea",
        "line-width": {
          "base": 1.2,
          "stops": [
            [6.5, 0],
            [7, 0.5],
            [20, 18],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "bridge-motorway",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "bridge"],
        ["==", "class", "motorway"],
        ["!=", "ramp", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#fc8",
        "line-width": {
          "base": 1.2,
          "stops": [
            [6.5, 0],
            [7, 0.5],
            [20, 18],
          ],
        },
        "line-opacity": .5,
      },
    },
    {
      "id": "bridge-railway",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "bridge"],
        ["==", "class", "rail"],
      ],
      "layout": {"visibility": railwayVisible ? "visible" : "none"},
      "paint": {
        "line-color": "#bbb",
        "line-width": {
          "base": 1.4,
          "stops": [
            [14, 0.4],
            [15, 0.75],
            [20, 2],
          ],
        },
      },
    },
    {
      "id": "bridge-railway-hatching",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "filter": [
        "all",
        ["==", "brunnel", "bridge"],
        ["==", "class", "rail"],
      ],
      "layout": {"visibility": railwayVisible ? "visible" : "none"},
      "paint": {
        "line-color": "#bbb",
        "line-dasharray": [0.2, 8],
        "line-width": {
          "base": 1.4,
          "stops": [
            [14.5, 0],
            [15, 3],
            [20, 8],
          ],
        },
      },
    },
    {
      "id": "cablecar",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "minzoom": 13,
      "filter": ["==", "class", "cable_car"],
      "layout": {
        "line-cap": "round",
        "visibility": transportationVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "hsl(0, 0%, 70%)",
        "line-width": {
          "base": 1,
          "stops": [
            [11, 1],
            [19, 2.5],
          ],
        },
      },
    },
    {
      "id": "cablecar-dash",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "minzoom": 13,
      "filter": ["==", "class", "cable_car"],
      "layout": {
        "line-cap": "round",
        "visibility": transportationVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "hsl(0, 0%, 70%)",
        "line-dasharray": [2, 3],
        "line-width": {
          "base": 1,
          "stops": [
            [11, 3],
            [19, 5.5],
          ],
        },
      },
    },
    {
      "id": "boundary-land-level-4",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "boundary",
      "filter": [
        "all",
        [">=", "admin_level", 3],
        ["<=", "admin_level", 8],
        ["!=", "maritime", 1],
      ],
      "layout": {
        "line-join": "round",
        "visibility": boundariesVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "#9e9cab",
        "line-dasharray": [3, 1, 1, 1],
        "line-width": {
          "base": 1.4,
          "stops": [
            [4, 0.4],
            [5, 1],
            [12, 3],
          ],
        },
      },
    },
    {
      "id": "boundary-land-level-2",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "boundary",
      "filter": [
        "all",
        ["==", "admin_level", 2],
        ["!=", "maritime", 1],
        ["!=", "disputed", 1],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": boundariesVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "hsl(248, 7%, 66%)",
        "line-width": {
          "base": 1,
          "stops": [
            [0, 0.6],
            [4, 1.4],
            [5, 2],
            [12, 8],
          ],
        },
      },
    },
    {
      "id": "boundary-land-disputed",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "boundary",
      "filter": [
        "all",
        ["!=", "maritime", 1],
        ["==", "disputed", 1],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": boundariesVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "hsl(248, 7%, 70%)",
        "line-dasharray": [1, 3],
        "line-width": {
          "base": 1,
          "stops": [
            [0, 0.6],
            [4, 1.4],
            [5, 2],
            [12, 8],
          ],
        },
      },
    },
    {
      "id": "boundary-water",
      "type": "line",
      "source": "openmaptiles",
      "source-layer": "boundary",
      "minzoom": 4,
      "filter": [
        "all",
        ["in", "admin_level", 2, 4],
        ["==", "maritime", 1],
      ],
      "layout": {
        "line-cap": "round",
        "line-join": "round",
        "visibility": boundariesVisible ? "visible" : "none",
      },
      "paint": {
        "line-color": "rgba(154, 189, 214, 1)",
        "line-opacity": {
          "stops": [
            [6, 0.6],
            [10, 1],
          ],
        },
        "line-width": {
          "base": 1,
          "stops": [
            [0, 0.6],
            [4, 1.4],
            [5, 2],
            [12, 8],
          ],
        },
      },
    },
    {
      "id": "waterway-name",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "waterway",
      "minzoom": 13,
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["has", "name:latin"],
      ],
      "layout": {
        "symbol-placement": "line",
        "symbol-spacing": 350,
        "text-field": "{name:latin} {name:nonlatin}",
        "text-font": ["Orbitron Regular"],
        "text-letter-spacing": 0.2,
        "text-max-width": 5,
        "text-rotation-alignment": "map",
        "text-size": 14,
      },
      "paint": waterLabelPaint.toMap(),
    },
    {
      "id": "water-name-lakeline",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "water_name",
      "filter": ["==", "\$type", "LineString"],
      "layout": {
        "symbol-placement": "line",
        "symbol-spacing": 350,
        "text-field": "{name:latin}\n{name:nonlatin}",
        "text-font": ["Orbitron Regular"],
        "text-letter-spacing": 0.2,
        "text-max-width": 5,
        "text-rotation-alignment": "map",
        "text-size": 14,
        "visibility": labelsVisible ? "visible" : "none",
      },
      "paint": waterLabelPaint.toMap(),
    },
    {
      "id": "water-name-ocean",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "water_name",
      "filter": [
        "all",
        ["==", "\$type", "Point"],
        ["==", "class", "ocean"],
      ],
      "layout": {
        "symbol-placement": "point",
        "symbol-spacing": 350,
        "text-field": "{name:latin}",
        "text-font": ["Orbitron Regular"],
        "text-letter-spacing": 0.2,
        "text-max-width": 5,
        "text-rotation-alignment": "map",
        "text-size": 14,
        "visibility": labelsVisible ? "visible" : "none",
      },
      "paint": waterLabelPaint.toMap(),
    },
    {
      "id": "water-name-other",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "water_name",
      "filter": [
        "all",
        ["==", "\$type", "Point"],
        ["!in", "class", "ocean"],
      ],
      "layout": {
        "symbol-placement": "point",
        "symbol-spacing": 350,
        "text-field": "{name:latin}\n{name:nonlatin}",
        "text-font": ["Orbitron Regular"],
        "text-letter-spacing": 0.2,
        "text-max-width": 5,
        "text-rotation-alignment": "map",
        "text-size": {
          "stops": [
            [0, 10],
            [6, 14],
          ],
        },
        "visibility": labelsVisible ? "visible" : "none",
      },
      "paint": waterLabelPaint.toMap(),
    },
    {
      "id": "poi-level-3",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "poi",
      "minzoom": 16,
      "filter": [
        "all",
        ["==", "\$type", "Point"],
        [">=", "rank", 25],
        [
          "any",
          ["!has", "level"],
          ["==", "level", 0],
        ],
      ],
      "layout": {
        // "icon-image": "{class}_11",
        "text-anchor": "top",
        "text-field": "{name:latin}\n{name:nonlatin}",
        "text-font": ["Orbitron Regular"],
        "text-max-width": 9,
        "text-offset": [0, 0.6],
        "text-padding": 2,
        "text-size": 12,
        "visibility": poiVisible ? "visible" : "none",
      },
      "paint": poiLabelPaint.toMap(),
    },
    {
      "id": "poi-level-2",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "poi",
      "minzoom": 15,
      "filter": [
        "all",
        ["==", "\$type", "Point"],
        ["<=", "rank", 24],
        [">=", "rank", 15],
        [
          "any",
          ["!has", "level"],
          ["==", "level", 0],
        ],
      ],
      "layout": {
        // "icon-image": "{class}_11",
        "text-anchor": "top",
        "text-field": "{name:latin}\n{name:nonlatin}",
        "text-font": ["Orbitron Regular"],
        "text-max-width": 9,
        "text-offset": [0, 0.6],
        "text-padding": 2,
        "text-size": 12,
        "visibility": poiVisible ? "visible" : "none",
      },
      "paint": poiLabelPaint.toMap(),
    },
    {
      "id": "poi-level-1",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "poi",
      "minzoom": 14,
      "filter": [
        "all",
        ["==", "\$type", "Point"],
        ["<=", "rank", 14],
        ["has", "name:latin"],
        [
          "any",
          ["!has", "level"],
          ["==", "level", 0],
        ],
      ],
      "layout": {
        // "icon-image": "{class}_11",
        "text-anchor": "top",
        "text-field": "{name:latin}\n{name:nonlatin}",
        "text-font": ["Orbitron Regular"],
        "text-max-width": 9,
        "text-offset": [0, 0.6],
        "text-padding": 2,
        "text-size": 12,
        "visibility": poiVisible ? "visible" : "none",
      },
      "paint": poiLabelPaint.toMap(),
    },
    {
      "id": "poi-railway",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "poi",
      "minzoom": 13,
      "filter": [
        "all",
        ["==", "\$type", "Point"],
        ["has", "name:latin"],
        ["==", "class", "railway"],
        ["==", "subclass", "station"],
      ],
      "layout": {
        "icon-allow-overlap": false,
        "icon-ignore-placement": false,
        // "icon-image": "{class}_11",
        "icon-optional": false,
        "text-allow-overlap": false,
        "text-anchor": "top",
        "text-field": "{name:latin}\n{name:nonlatin}",
        "text-font": ["Orbitron Regular"],
        "text-ignore-placement": false,
        "text-max-width": 9,
        "text-offset": [0, 0.6],
        "text-optional": true,
        "text-padding": 2,
        "text-size": 12,
        "visibility": poiVisible ? "visible" : "none",
      },
      "paint": poiLabelPaint.toMap(),
    },
    {
      "id": "road_oneway",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "minzoom": 15,
      "filter": [
        "all",
        ["==", "oneway", 1],
        [
          "in",
          "class",
          "motorway",
          "trunk",
          "primary",
          "secondary",
          "tertiary",
          "minor",
          "service",
        ]
      ],
      "layout": {
        // "icon-image": "oneway",
        "icon-padding": 2,
        "icon-rotate": 90,
        "icon-rotation-alignment": "map",
        "icon-size": {
          "stops": [
            [15, 0.5],
            [19, 1],
          ],
        },
        "symbol-placement": "line",
        "symbol-spacing": 75,
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": SymbolPaint(
        iconOpacity: 0.5,
        iconColor: const Color(0xFF777777),
        textColor: const Color(0xFF777777),
      ).toMap(),
    },
    {
      "id": "road_oneway_opposite",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "transportation",
      "minzoom": 15,
      "filter": [
        "all",
        ["==", "oneway", -1],
        [
          "in",
          "class",
          "motorway",
          "trunk",
          "primary",
          "secondary",
          "tertiary",
          "minor",
          "service",
        ]
      ],
      "layout": {
        "icon-image": "oneway",
        "icon-padding": 2,
        "icon-rotate": -90,
        "icon-rotation-alignment": "map",
        "icon-size": {
          "stops": [
            [15, 0.5],
            [19, 1],
          ],
        },
        "symbol-placement": "line",
        "symbol-spacing": 75,
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": SymbolPaint(
        iconOpacity: 0.5,
        iconColor: const Color(0xFF777777),
        textColor: const Color(0xFF777777),
      ).toMap(),
    },
    {
      "id": "highway-name-path",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "transportation_name",
      "minzoom": 15.5,
      "filter": ["==", "class", "path"],
      "layout": {
        "symbol-placement": "line",
        "text-field": "{name:latin} {name:nonlatin}",
        "text-font": ["Orbitron Regular"],
        "text-rotation-alignment": "map",
        "visibility": roadsVisible ? "visible" : "none",
        "text-size": {
          "base": 1,
          "stops": [
            [13, 12],
            [14, 13],
          ],
        },
      },
      "paint": roadLabelPaint.toMap(),
    },
    {
      "id": "highway-name-minor",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "transportation_name",
      "minzoom": 15,
      "filter": [
        "all",
        ["==", "\$type", "LineString"],
        ["in", "class", "minor", "service", "track"],
      ],
      "layout": {
        "symbol-placement": "line",
        "text-field": "{name:latin} {name:nonlatin}",
        "text-font": ["Orbitron Regular"],
        "text-rotation-alignment": "map",
        "visibility": labelsVisible && roadsVisible ? "visible" : "none",
        "text-size": {
          "base": 1,
          "stops": [
            [13, 12],
            [14, 13],
          ],
        },
      },
      "paint": roadLabelPaint.toMap(),
    },
    {
      "id": "highway-name-major",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "transportation_name",
      "minzoom": 12.2,
      "filter": ["in", "class", "primary", "secondary", "tertiary", "trunk"],
      "layout": {
        "symbol-placement": "line",
        "text-field": "{name:latin} {name:nonlatin}",
        "text-font": ["Orbitron Regular"],
        "text-rotation-alignment": "map",
        "visibility": labelsVisible && roadsVisible ? "visible" : "none",
        "text-size": {
          "base": 1,
          "stops": [
            [13, 12],
            [14, 13],
          ],
        },
      },
      "paint": roadLabelPaint.toMap(),
    },
    {
      "id": "highway-shield",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "transportation_name",
      "minzoom": 8,
      "filter": [
        "all",
        ["<=", "ref_length", 6],
        ["==", "\$type", "LineString"],
        ["!in", "network", "us-interstate", "us-highway", "us-state"],
      ],
      "layout": {
        // "icon-image": "road_{ref_length}",
        "icon-rotation-alignment": "viewport",
        "icon-size": 1,
        "symbol-placement": {
          "base": 1,
          "stops": [
            [10, "point"],
            [11, "line"],
          ],
        },
        "symbol-spacing": 200,
        "text-field": "{ref}",
        "text-font": ["Orbitron Regular"],
        "text-rotation-alignment": "viewport",
        "text-size": 10,
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": SymbolPaint(
        iconOpacity: 0.5,
        iconColor: const Color(0xFF777777),
        textColor: const Color(0xFF777777),
      ).toMap(),
    },
    {
      "id": "highway-shield-us-interstate",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "transportation_name",
      "minzoom": 7,
      "filter": [
        "all",
        ["<=", "ref_length", 6],
        ["==", "\$type", "LineString"],
        ["in", "network", "us-interstate"],
      ],
      "layout": {
        // "icon-image": "{network}_{ref_length}",
        "icon-rotation-alignment": "viewport",
        "icon-size": 1,
        "symbol-placement": {
          "base": 1,
          "stops": [
            [7, "point"],
            [7, "line"],
            [8, "line"],
          ],
        },
        "symbol-spacing": 200,
        "text-field": "{ref}",
        "text-font": ["Orbitron Regular"],
        "text-rotation-alignment": "viewport",
        "text-size": 10,
        "visibility": roadsVisible ? "visible" : "none",
      },
      "paint": roadLabelPaint.toMap(),
    },
    {
      "id": "highway-shield-us-other",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "transportation_name",
      "minzoom": 9,
      "filter": [
        "all",
        ["<=", "ref_length", 6],
        ["==", "\$type", "LineString"],
        ["in", "network", "us-highway", "us-state"],
      ],
      "layout": {
        // "icon-image": "{network}_{ref_length}",
        "icon-rotation-alignment": "viewport",
        "icon-size": 1,
        "visibility": roadsVisible ? "visible" : "none",
        "symbol-placement": {
          "base": 1,
          "stops": [
            [10, "point"],
            [11, "line"],
          ],
        },
        "symbol-spacing": 200,
        "text-field": "{ref}",
        "text-font": ["Orbitron Regular"],
        "text-rotation-alignment": "viewport",
        "text-size": 10,
      },
      "paint": roadLabelPaint.toMap(),
    },
    {
      "id": "airport-label-major",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "aerodrome_label",
      "minzoom": 10,
      "filter": [
        "all",
        ["has", "iata"],
      ],
      "layout": {
        // "icon-image": "airport_11",
        "icon-size": 1,
        "text-anchor": "top",
        "text-field": "{name:latin}\n{name:nonlatin}",
        "text-font": ["Orbitron Regular"],
        "text-max-width": 9,
        "text-offset": [0, 0.6],
        "text-optional": true,
        "text-padding": 2,
        "text-size": 12,
        "visibility": labelsVisible ? "visible" : "none",
      },
      "paint": poiLabelPaint.toMap(),
    },
    {
      "id": "place-other",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "place",
      "filter": [
        "!in",
        "class",
        "city",
        "town",
        "village",
        "state",
        "country",
        "continent",
      ],
      "layout": {
        "text-field": "{name:latin}\n{name:nonlatin}",
        "text-font": ["Orbitron Regular"],
        "text-letter-spacing": 0.1,
        "text-max-width": 9,
        "text-size": {
          "base": 1.2,
          "stops": [
            [12, 10],
            [15, 14],
          ],
        },
        "text-transform": "uppercase",
        "visibility": labelsVisible ? "visible" : "none",
      },
      "paint": placeLabelPaint.toMap(),
    },
    {
      "id": "place-village",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "place",
      "filter": ["==", "class", "village"],
      "layout": {
        "text-field": "{name:latin}\n{name:nonlatin}",
        "text-font": ["Orbitron Regular"],
        "text-max-width": 8,
        "text-size": {
          "base": 1.2,
          "stops": [
            [10, 12],
            [15, 22],
          ],
        },
        "visibility": labelsVisible ? "visible" : "none",
      },
      "paint": placeLabelPaint.toMap(),
    },
    {
      "id": "place-town",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "place",
      "filter": ["==", "class", "town"],
      "layout": {
        "text-field": "{name:latin}\n{name:nonlatin}",
        "text-font": ["Orbitron Regular"],
        "text-max-width": 8,
        "text-size": {
          "base": 1.2,
          "stops": [
            [10, 14],
            [15, 24],
          ],
        },
        "visibility": labelsVisible ? "visible" : "none",
      },
      "paint": placeLabelPaint.toMap(),
    },
    {
      "id": "place-city",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "place",
      "filter": [
        "all",
        ["!=", "capital", 2],
        ["==", "class", "city"],
      ],
      "layout": {
        "text-field": "{name:latin}\n{name:nonlatin}",
        "text-font": ["Orbitron Regular"],
        "text-max-width": 8,
        "text-size": {
          "base": 1.2,
          "stops": [
            [7, 14],
            [11, 24],
          ],
        },
        "visibility": labelsVisible ? "visible" : "none",
      },
      "paint": placeLabelPaint.toMap(),
    },
    {
      "id": "place-city-capital",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "place",
      "filter": [
        "all",
        ["==", "capital", 2],
        ["==", "class", "city"],
      ],
      "layout": {
        // "icon-image": "star_11",
        "icon-size": 0.8,
        "text-anchor": "left",
        "text-field": "{name:latin}\n{name:nonlatin}",
        "text-font": ["Orbitron Regular"],
        "text-max-width": 8,
        "text-offset": [0.4, 0],
        "text-size": {
          "base": 1.2,
          "stops": [
            [7, 14],
            [11, 24],
          ],
        },
        "visibility": labelsVisible ? "visible" : "none",
      },
      "paint": placeLabelPaint.toMap(),
    },
    {
      "id": "place-state",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "place",
      "filter": [
        "in",
        "class",
        "state",
      ],
      "layout": {
        "text-field": "{name:latin}",
        "text-font": ["Orbitron Regular"],
        "text-letter-spacing": 0.1,
        "text-max-width": 9,
        "text-size": {
          "base": 1.2,
          "stops": [
            [12, 10],
            [15, 14],
          ],
        },
        "text-transform": "uppercase",
        "visibility": labelsVisible ? "visible" : "none",
      },
      "paint": placeLabelPaint.toMap(),
    },
    {
      "id": "place-country-other",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "place",
      "filter": [
        "all",
        ["==", "class", "country"],
        [">=", "rank", 3],
        ["!has", "iso_a2"],
      ],
      "layout": {
        "text-field": "{name:latin}",
        "text-font": ["Orbitron Regular"],
        "text-max-width": 6.25,
        "text-size": {
          "stops": [
            [3, 11],
            [7, 17],
          ],
        },
        "text-transform": "uppercase",
        "visibility": labelsVisible ? "visible" : "none",
      },
      "paint": placeLabelPaint.toMap(),
    },
    {
      "id": "place-country-3",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "place",
      "filter": [
        "all",
        ["==", "class", "country"],
        [">=", "rank", 3],
        ["has", "iso_a2"],
      ],
      "layout": {
        "text-field": "{name:latin}",
        "text-font": ["Orbitron Regular"],
        "text-max-width": 6.25,
        "text-size": {
          "stops": [
            [3, 11],
            [7, 17],
          ],
        },
        "text-transform": "uppercase",
        "visibility": labelsVisible ? "visible" : "none",
      },
      "paint": placeLabelPaint.toMap(),
    },
    {
      "id": "place-country-2",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "place",
      "filter": [
        "all",
        ["==", "class", "country"],
        ["==", "rank", 2],
        ["has", "iso_a2"],
      ],
      "layout": {
        "text-field": "{name:latin}",
        "text-font": ["Orbitron Regular"],
        "text-max-width": 6.25,
        "text-size": {
          "stops": [
            [2, 11],
            [5, 17],
          ],
        },
        "text-transform": "uppercase",
        "visibility": labelsVisible ? "visible" : "none",
      },
      "paint": placeLabelPaint.toMap(),
    },
    {
      "id": "place-country-1",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "place",
      "filter": [
        "all",
        ["==", "class", "country"],
        ["==", "rank", 1],
        ["has", "iso_a2"],
      ],
      "layout": {
        "text-field": "{name:latin}",
        "text-font": ["Orbitron Regular"],
        "text-max-width": 6.25,
        "text-size": {
          "stops": [
            [1, 11],
            [4, 17],
          ],
        },
        "text-transform": "uppercase",
        "visibility": labelsVisible ? "visible" : "none",
      },
      "paint": placeLabelPaint.toMap(),
    },
    {
      "id": "place-continent",
      "type": "symbol",
      "source": "openmaptiles",
      "source-layer": "place",
      "maxzoom": 1,
      "filter": ["==", "class", "continent"],
      "layout": {
        "text-field": "{name:latin}",
        "text-font": ["Orbitron Regular"],
        "text-max-width": 6.25,
        "text-size": 14,
        "text-transform": "uppercase",
        "visibility": labelsVisible ? "visible" : "none",
      },
      "paint": placeLabelPaint.toMap(),
    }
  ],
  "id": "bright",
};
