# cyber_map

## Overview

cyber_map is a mobile application designed for offline map viewing and navigation. It has been primarily configured and tested for MacOS and Android, with the best experience currently offered on Android devices.

## Features

- Offline map viewing using .mbtiles files
- Landmark fetching and local storage for offline use
- Navigation instructions using a modified OSRM package

## Setup and Usage

### Map Data

1. On initial loading, the app will prompt you to select a .mbtiles file.
2. The app is configured to open vector mbtiles following the [OpenMapTiles Specification](https://openmaptiles.org/schema/).
3. Web tile sources are not currently supported.

### Generating Map Tiles

To create your own map tiles:

1. Fetch OSM Data (in .osm.pbf format) from [GeoFabrik](https://download.geofabrik.de/).
2. Generate tiles using [TileMaker](https://github.com/systemed/tilemaker) with the following command:

   ```zsh
   tilemaker --config resources/config-openmaptiles.json --process resources/process-openmaptiles.lua your_map_file.mbtiles
   ```

3. Alternatively, you can use this [pre-generated mbtiles file](https://drive.google.com/file/d/19LeE-ZuN-bof6JGdNwgroOXBnXP3MSM2/view?usp=sharing).

### Landmarks

Landmark data is fetched from the [Overpass API](https://wiki.openstreetmap.org/wiki/Overpass_API) and stored locally for offline use.

### Navigation

Navigation instructions are provided using a modified version of the [OSM-Routing-Client-Dart](https://github.com/baconjuggling/OSM-Routing-Client-Dart) package.

## Compatibility

- Primarily configure for and tested on MacOS and Android
- Best experience currently on Android devices

## Contributing

Contributions to improve compatibility with other platforms or enhance features are welcome. Please submit pull requests or open issues on the project repository.
