// Javacsript file that renders that map on Atlas Viewer

// Stores the attribution and map source for the base layer maps from Mapbox.com
var mbAttr = 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    mbUrl = 'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZGVsdGFzcGFyayIsImEiOiJjaWl1ejBmMDEwMDJldXNsejBjeHhhanBjIn0.kvUH_d89tMUM9TDoeA5G5w';

// Defines that streets/grayscale base map layers using the public mapbox tiles
var streets = L.tileLayer(mbUrl, {id: 'mapbox.streets-basic', attribution: mbAttr}),
    grayscale = L.tileLayer(mbUrl, {id: 'mapbox.light', attribution: mbAttr});

// Creates a new layer group for the geofences
var fenceLayer = new L.LayerGroup();

for (var i = 0; i < fences.length; i++) {
    L.circle([fences[i][0],fences[i][1]], fences[i][2],{
        weight: 0.5,
        fillColor: '#f03',
        fillOpacity: 0.05
    }).addTo(fenceLayer);
}

// Draws the interactive map with the base layer and geofences
// Geofences included due to the quick rendering for ~2,000 fences
// Impressions delayed until after the map draw for improved performance
var map = L.map('map', {
    center: [27.8333, -81.7170],
    zoom: 6,
    layers: [streets, fenceLayer]
});

// Uses the Marker Cluster Group plugin to draw the markers for impressions in a chunked fashion (sets of markers at a time) to prevent browser stall
var markers = L.markerClusterGroup({chunkedLoading: true});

var markerList = [];

for (var j = 0; j < impressions.length; j++) {
    var a = impressions[j]
    var marker = L.marker([a[0],a[1]]);
    marker.bindPopup(a[2].toString());
    
    markerList.push(marker);
    
    // Debug console printout to check for infinite loop
    if (j % 10000 == 0) {
        console.log('loop milestone passed: ' + j);
    }
}

// Debug console print to check for performance at start of clustering
console.log('start clustering: ' + window.performance.now());

// Adds all impression markers to the map
markers.addLayers(markerList);
map.addLayer(markers);

// Debug console print to check for performance at end of clustering
console.log('end clustering: ' + window.performance.now());

// Adds layer controls to the drawn map to allow for switching base layers, and add/removal of geofences and impressions
var baseLayers = {
    "Streets": streets,
    "Grayscale": grayscale
};

var overlays = {
    "Fences": fenceLayer,
    "Impressions": markers
};

L.control.layers(baseLayers, overlays).addTo(map);