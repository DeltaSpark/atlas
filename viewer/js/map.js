var fenceLayer = new L.LayerGroup();

for (var i = 0; i < fences.length; i++) {
    L.circle([fences[i][0],fences[i][1]], fences[i][2],{
        weight: 0,
        fillColor: '#f03',
        fillOpacity: 0.2
    }).addTo(fenceLayer);
}

var mbAttr = 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    mbUrl = 'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZGVsdGFzcGFyayIsImEiOiJjaWl1ejBmMDEwMDJldXNsejBjeHhhanBjIn0.kvUH_d89tMUM9TDoeA5G5w';

var streets = L.tileLayer(mbUrl, {id: 'mapbox.streets-basic', attribution: mbAttr}),
    grayscale = L.tileLayer(mbUrl, {id: 'mapbox.light', attribution: mbAttr});

var map = L.map('map', {
    center: [27.8333, -81.7170],
    zoom: 6,
    layers: [streets, fenceLayer]
});

var baseLayers = {
    "Streets": streets,
    "Grayscale": grayscale
};

var overlays = {
    "Fences": fenceLayer
};

L.control.layers(baseLayers, overlays).addTo(map);
